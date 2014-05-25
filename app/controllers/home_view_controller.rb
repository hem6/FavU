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

    ## navigationBarの設定
    self.title = @user["screen_name"]

    @add_button = UIBarButtonItem.alloc.initWithTitle("add", style:UIBarButtonItemStyleBordered, target:self, action:'add_button_tapped')
    @remove_button = UIBarButtonItem.alloc.initWithTitle("remove", style:UIBarButtonItemStyleBordered, target:self, action:'remove_button_tapped')

    self.navigationItem.rightBarButtonItem = @remove_button
  end

  def refresh
    @timeline.update
  end

  def load_more
    @timeline.update(true)
  end

  def remove_button_tapped
    user_index_path = @usersManager.indexPathForUser(@user)
    @usersManager.deleteUserForIndexPath(user_index_path)
    @collectionView.deleteItemsAtIndexPaths([user_index_path])

    self.navigationItem.rightBarButtonItem = @add_button
  end

  def add_button_tapped
    @usersManager.addUser(@user)
    @collectionView.insertItemsAtIndexPaths([[0, @usersManager.numberOfUsers - 1].nsindexpath])
    self.navigationItem.rightBarButtonItem = @remove_button
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
    @usersManager.numberOfUsers + 1
  end

  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
    if indexPath.row == @usersManager.numberOfUsers
      cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddUserCell", forIndexPath:indexPath)
      return cell
    end

    cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath:indexPath)
    cell.fillWithUser(@usersManager.userForIndexPath(indexPath))
    cell
  end

  ### UICollectionViewDelegate

  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    collectionView.deselectItemAtIndexPath(indexPath, animated: true)

    if indexPath.row == @usersManager.numberOfUsers
      add_user_cell_tapped
      return
    end

    @timeline.removeObserver(self, forKeyPath:"tweets")

    @user = @usersManager.userForIndexPath(indexPath)
    @timeline = @timelinesManager.timelineForUser(@user)

    @timeline.addObserver(self, forKeyPath:"tweets", options:0, context:nil)
    self.title = @user["screen_name"]

    @tableView.reloadData
  end

  def add_user_cell_tapped
    controller = AddUserViewController.new
    self.navigationController.pushViewController(controller, animated:true)
  end

  ### LXReorderableCollectionViewDataSource

  def collectionView(collectionView, itemAtIndexPath:fromIndexPath, willMoveToIndexPath:toIndexPath)
    @usersManager.moveUser(fromIndexPath, toIndexPath)
  end

  def collectionView(collectionView, canMoveItemAtIndexPath:indexPath)
    return falese if indexPath.row == @usersManager.numberOfUsers
    true
  end

  def collectionView(collectionView, itemAtIndexPath:fromIndexPath, canMoveToIndexPath:toIndexPath)
    return falese if indexPath.row == @usersManager.numberOfUsers
    true
  end
end
