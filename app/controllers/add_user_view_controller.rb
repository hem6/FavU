class AddUserViewController < UIViewController
  def viewDidLoad
    @add_user_view = AddUserView.alloc.initWithFrame(self.view.bounds)

    @text_field = @add_user_view.text_field
    @add_button = @add_user_view.add_button

    @add_button.addTarget(self, action:'add_user', forControlEvents:UIControlEventTouchUpInside)

    @usersManager = UsersManager.sharedManager

    self.view = @add_user_view
  end

  def add_user
    @usersManager.addUserWithScreenName(@text_field.text)
  end
end
