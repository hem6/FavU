class AddUserViewController < UIViewController
  def viewDidLoad
    super
    @users_manager = UsersManager.sharedManager
    configure_timeline_view_controller
    configure_add_user_view
    self.title = "Add User"
  end

  def viewDidAppear(animated)
    super
    @text_field.becomeFirstResponder
  end

  def configure_timeline_view_controller
    @timeline_view_controller = TimelineViewController.new

    # AddUserViewの下部にTimelineViewを追加。
    @timeline_view_controller.view.frame = [[0, 46],
      [self.view.frame.size.width, self.view.frame.size.height - 46]]
    self.view << @timeline_view_controller.view

    # childViewControllerに設定・通知
    self.addChildViewController(@timeline_view_controller)
    @timeline_view_controller.didMoveToParentViewController(self)
  end

  def configure_add_user_view
    @add_user_view = AddUserView.alloc.initWithFrame([[0, 0], [self.view.frame.size.width, 110]])
    @text_field = @add_user_view.text_field
    @text_field.delegate = self

    self.view << @add_user_view
  end

  # 右上のadd/removeボタンの切り替え。@userが登録済みならremove、未登録ならaddボタンを表示
  def config_right_bar_button_item
    unless @user
      self.navigationItem.rightBarButtonItem = nil
      return
    end

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

  ### UITextField Delegate

  def textFieldShouldReturn(textField)
    textField.resignFirstResponder

    return false if textField.text.length == 0

    @user = User.userWithScreenName(textField.text)
    self.title = "Add @#{@user.screen_name}"
    @timeline_view_controller.timeline = Timeline.new(@user)
    config_right_bar_button_item

    return false
  end
end
