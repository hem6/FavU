class UserTimelinesController < UIViewController
  def viewDidLoad
    super

    configure_timeline_view_controller
    configure_user_select_view_controller
    configure_models
  end

  def configure_timeline_view_controller
    @timeline_view_controller = TimelineViewController.new

    # user_select_viewの高さ80を画面下部に空ける。
    @timeline_view_controller.view.frame = [[0, 0],
      [self.view.frame.size.width, self.view.frame.size.height - 80]]
    self.view << @timeline_view_controller.view

    # childViewControllerに設定・通知
    self.addChildViewController(@timeline_view_controller)
    @timeline_view_controller.didMoveToParentViewController(self)
  end

  def configure_user_select_view_controller
    @user_select_view_controller = UserSelectViewController.new
    @user_select_view_controller.delegate = self

    # 画面下部に高さ80で設定
    @user_select_view_controller.view.frame = [[0, self.view.frame.size.height - 80],
                                               [self.view.frame.size.width, 80]]
    self.view << @user_select_view_controller.view

    # childViewControllerに設定・通知
    self.addChildViewController(@user_select_view_controller)
    @user_select_view_controller.didMoveToParentViewController(self)
  end

  def configure_models
    @timelines_manager = TimelinesManager.sharedManager
    @users_manager = UsersManager.sharedManager
    self.user = @users_manager.users.first
  end

  # 右上のadd/removeボタンの切り替え。@userが登録済みならremove、未登録ならaddボタンを表示
  def config_right_bar_button_item
    @add_button ||= UIBarButtonItem.alloc.initWithTitle("add",
                                                        style:UIBarButtonItemStyleBordered,
                                                        target:self,
                                                        action:'add_button_tapped')

    @remove_button ||= UIBarButtonItem.alloc.initWithTitle("remove",
                                                        style:UIBarButtonItemStyleBordered,
                                                        target:self,
                                                        action:'remove_button_tapped')
    @remove_button.tintColor = UIColor.redColor

    if @users_manager.indexPathForUser(@user)
      self.navigationItem.rightBarButtonItem = @remove_button
    else
      self.navigationItem.rightBarButtonItem = @add_button
    end
  end

  def user=(user)
    unless user
      self.title = "FavU"
      return
    end

    @user = user
    @timeline_view_controller.timeline = @timelines_manager.timelineForUser(@user)
    self.title = @user["screen_name"]
    config_right_bar_button_item
  end

  def remove_button_tapped
    @timelines_manager.deleteTimelineForUser(@user)
    user_index_path = @users_manager.indexPathForUser(@user)
    @users_manager.deleteUserForIndexPath(user_index_path)
    config_right_bar_button_item
  end

  def add_button_tapped
    @users_manager.addUser(@user)
    config_right_bar_button_item
  end

  ### @user_select_view delegate

  def userSelected(user)
    self.user = user
  end

  def addUserCellTapped
    controller = AddUserViewController.new
    self.navigationController.pushViewController(controller, animated:true)
  end
end
