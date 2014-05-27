class UserSelectViewController < UIViewController
  attr_accessor :delegate
  def viewDidLoad
    super

    configure_views
    configure_model
  end

  def configure_views
    @user_select_view = UserSelectView.alloc.initWithFrame(self.view.bounds)

    @collection_view = @user_select_view.collectionView
    @collection_view.dataSource = self
    @collection_view.delegate = self

    self.view = @user_select_view
  end

  def configure_model
    @users_manager = UsersManager.sharedManager
    @users_manager.addObserver(self, forKeyPath:"users", options:0, context:nil)
  end

  def observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    return unless object == @users_manager
    @collection_view.reloadData
  end

  def delegate=(delegate)
    @delegate = WeakRef.new(delegate)
  end

  ### UICollectionViewDataSource

  def collectionView(collectionView, numberOfItemsInSection:section)
    @users_manager.numberOfUsers + 1
  end

  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
    identifier = indexPath.row == @users_manager.numberOfUsers ? "AddUserCell" : "UserCell"
    cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath:indexPath)
    cell.fillWithUser(@users_manager.userForIndexPath(indexPath)) if identifier == "UserCell"
    cell
  end

  ### UICollectionViewDelegate

  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    collectionView.deselectItemAtIndexPath(indexPath, animated: true)

    if indexPath.row == @users_manager.numberOfUsers
      add_user_cell_tapped
      return
    end

    #TODO: ユーザー選択処理
    @delegate.userSelected(@users_manager.userForIndexPath(indexPath))
  end

  def add_user_cell_tapped
    @delegate.addUserCellTapped
  end

  ### LXReorderableCollectionViewDataSource

  def collectionView(collectionView, itemAtIndexPath:fromIndexPath, willMoveToIndexPath:toIndexPath)
    @users_manager.moveUser(fromIndexPath, toIndexPath)
  end

  def collectionView(collectionView, canMoveItemAtIndexPath:indexPath)
    # ユーザー追加セルだけfalse
    return falese if indexPath.row == @users_manager.numberOfUsers
    true
  end

  def collectionView(collectionView, itemAtIndexPath:fromIndexPath, canMoveToIndexPath:toIndexPath)
    # ユーザー追加セルだけfalse
    return falese if indexPath.row == @users_manager.numberOfUsers
    true
  end
end
