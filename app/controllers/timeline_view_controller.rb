class TimelineViewController < UIViewController
  def viewDidLoad
    super
    configure_views
  end

  def dealloc
    @timeline.removeObserver(self, forKeyPath:"tweets") if @timeline

    super
  end

  def configure_views
    @timeline_view = TimelineView.alloc.initWithFrame(self.view.bounds)

    @table_view = @timeline_view.tableView
    @table_view.dataSource = self
    @table_view.delegate = self

    @refresh_control = @timeline_view.refreshControl
    @refresh_control.addTarget(self, action:'refresh', forControlEvents:UIControlEventValueChanged)

    self.view = @timeline_view
  end

  def timeline=(timeline)
    # キー値監視しているtimelineを、displayOffsetを保存して入れ替える
    if @timeline
      @timeline.removeObserver(self, forKeyPath:"tweets")
      @timeline.displayOffset = @table_view.contentOffset
    end

    @timeline = timeline
    @timeline.addObserver(self, forKeyPath:"tweets", options:0, context:nil)

    @table_view.reloadData
    @table_view.contentOffset = @timeline.displayOffset
  end

  def refresh
    @timeline.update if @timeline
  end

  def observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    return unless object == @timeline
    @refresh_control.endRefreshing
    @table_view.reloadData
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

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)

    tweet = @timeline.tweetForIndexPath(indexPath)
    @tweet_detail_view_controller = TweetDetailViewController.new(tweet)

    self.navigationController.pushViewController(@tweet_detail_view_controller, animated:true)
  end
end
