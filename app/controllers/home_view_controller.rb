class HomeViewController < UIViewController
  def viewDidLoad
    super

    ## viewの設定
    @homeView = HomeView.alloc.initWithFrame([[0, 0], [self.view.frame.size.width, self.view.frame.size.height]])

    @tableView = @homeView.tableView
    @tableView.dataSource = self
    @tableView.delegate = self

    @refreshControl = @homeView.refreshControl
    @refreshControl.addTarget(self, action:'refresh', forControlEvents:UIControlEventValueChanged)

    @collectionView = @homeView.collectionView
    @collectionView.dataSource = self
    @collectionView.delegate = self

    self.view = @homeView

    ## modelの設定
    @usersManager = UsersManager.sharedManager
    @timelinesManager = TimelinesManager.sharedManager

    @user = @usersManager.users.first
    @timeline = @timelinesManager.timelineForUser(@user)
    @timeline.addObserver(self, forKeyPath:"tweets", options:0, context:nil)

    self.title = @user["screen_name"]
  end

  def refresh
    @timeline.update
  end

  def load_more
    @timeline.update(true)
  end

  ### UITableViewDataSource

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
    tweet = @timeline.tweetForIndexPath(indexPath)
    cell.fill_with_tweet(tweet)
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @timeline.count
  end

  ### UITableViewDelegate

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    tweet = @timeline.tweetForIndexPath(indexPath)
    TweetCell.heightForTweet(tweet)
  end

  ### TableViewの更新

  def observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    if object == @timeline && keyPath == 'tweets'
      @refreshControl.endRefreshing
      @tableView.reloadData
    end
  end

  ### UICollectionViewDataSource

  def collectionView(collectionView, numberOfItemsInSection:section)
    @usersManager.numberOfUsers
  end

  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
    cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath:indexPath)
    cell.fillWithUser(@usersManager.userForIndexPath(indexPath))
    cell
  end

  ### UICollectionViewDelegate

  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    collectionView.deselectItemAtIndexPath(indexPath, animated: true)

    @timeline.removeObserver(self, forKeyPath:"tweets")

    @user = @usersManager.userForIndexPath(indexPath)
    @timeline = @timelinesManager.timelineForUser(@user)

    @timeline.addObserver(self, forKeyPath:"tweets", options:0, context:nil)
    self.title = @user["screen_name"]

    @tableView.reloadData
  end
end
