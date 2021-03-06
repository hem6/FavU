class TimelineViewController < UITableViewController
  def viewDidLoad
    super
    @last_timeline_count = 0
    configure_table_view
    configure_gesture_recognizers
  end

  def dealloc
    @timeline.removeObserver(self, forKeyPath:"tweets") if @timeline

    super
  end

  def configure_table_view
    self.tableView.registerClass(TweetCell, forCellReuseIdentifier:"TweetCell")
    self.tableView.allowsSelection = false
    self.tableView.tableFooterView = UIView.new.tap do |fv|
      fv.frame = [[0, 0], [self.view.frame.size.width, 44]]

      @indicator_view = UIActivityIndicatorView.new.tap do |iv|
        iv.style = UIActivityIndicatorViewStyleGray
        iv.center = [fv.center.x, fv.center.y]
      end

      fv << @indicator_view
    end

    @refresh_control = UIRefreshControl.new
    self.refreshControl = @refresh_control

    @refresh_control.addTarget(self, action:'refresh', forControlEvents:UIControlEventValueChanged)
  end

  def configure_gesture_recognizers
    single_tap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'single_tapped:')
    single_tap.numberOfTapsRequired = 1
    self.tableView.addGestureRecognizer(single_tap)

    double_tap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'double_tapped:')
    double_tap.numberOfTapsRequired = 2
    self.tableView.addGestureRecognizer(double_tap)

    single_tap.requireGestureRecognizerToFail(double_tap)
  end

  def timeline=(timeline)
    # キー値監視しているtimelineを、displayOffsetを保存して入れ替える
    if @timeline
      @timeline.removeObserver(self, forKeyPath:"tweets")
      @timeline.displayOffset = self.tableView.contentOffset
    end

    @timeline = timeline
    @timeline.addObserver(self, forKeyPath:"tweets", options:0, context:nil)

    #慣性スクロールを止める
    self.tableView.setContentOffset(self.tableView.contentOffset, animated:false)

    # 入れ替えられたタイムラインを表示
    self.tableView.reloadData
    self.tableView.contentOffset = @timeline.displayOffset
    @last_timeline_count = @timeline.count

    if @timeline.count == 0
      refresh
      @indicator_view.startAnimating
    end
  end

  def refresh
    if @timeline.nil? || @timeline.updating?
      @refresh_control.endRefreshing
      return
    end
    @timeline.update
  end

  def observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    return unless object == @timeline

    if @timeline.prepended? and
       @last_timeline_count != 0 and
       @last_timeline_count != @timeline.count

      prepended_count = @timeline.count - @last_timeline_count
      tableView(self.tableView, reloadDataWithKeepingContentOffset:prepended_count)
      @last_timeline_count = @timeline.count
    else
      @last_timeline_count = @timeline.count
      self.tableView.reloadData
    end

    @refresh_control.endRefreshing
    @indicator_view.stopAnimating
  end

  def tableView(tableView, reloadDataWithKeepingContentOffset:prepended_count)
    offset = tableView.contentOffset
    tableView.reloadData

    prepended_count.times do |i|
      index_path = NSIndexPath.indexPathForRow(i, inSection:0)
      offset.y += self.tableView(tableView, heightForRowAtIndexPath:index_path)
    end

    if offset.y > tableView.contentSize.height
      offset.y = 0
    end
    puts offset.y
    tableView.setContentOffset(offset)
  end

  # UITapGestureRecognizer Action

  def single_tapped(recognizer)
    index_path = indexpath_for_tapped_row(recognizer)
    return unless index_path

    open_tweet_for_indexpath(index_path)
  end

  def double_tapped(recognizer)
    index_path = indexpath_for_tapped_row(recognizer)
    return unless index_path

    favorite_tweet_for_indexpath(index_path)
  end

  def indexpath_for_tapped_row(recognizer)
    point = recognizer.locationOfTouch(0, inView:self.tableView)
    return self.tableView.indexPathForRowAtPoint(point)
  end

  def open_tweet_for_indexpath(index_path)
    tweet = @timeline.tweetForIndexPath(index_path)
    @tweet_detail_view_controller = TweetDetailViewController.new(tweet)
    self.navigationController.pushViewController(@tweet_detail_view_controller, animated:true)
  end

  def favorite_tweet_for_indexpath(index_path)
    tweet = @timeline.tweetForIndexPath(index_path)
    favorited = tweet.toggleFavorite

    cell = self.tableView.cellForRowAtIndexPath(index_path)
    cell.configure_star(favorited)
  end

  ### UITableViewDataSource

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath:indexPath)
    tweet = @timeline.tweetForIndexPath(indexPath)
    cell.fill_with_tweet(tweet)
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    return 0 unless @timeline
    @timeline.count
  end

  ### UITableViewDelegate

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    tweet = @timeline.tweetForIndexPath(indexPath)
    TweetCell.heightForTweet(tweet)
  end

  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    if (not @timeline.updating? and
        @timeline.count > 100 and
        indexPath.row >= @timeline.count - 5)

      @timeline.update(true)
      @indicator_view.startAnimating
    end
  end
end
