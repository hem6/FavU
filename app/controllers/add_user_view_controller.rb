class AddUserViewController < UIViewController
  def viewDidLoad
    @add_user_view = AddUserView.alloc.initWithFrame(self.view.bounds)

    @text_field = @add_user_view.text_field
    @add_button = @add_user_view.add_button

    @add_button.addTarget(self, action:'add_user', forControlEvents:UIControlEventTouchUpInside)

    self.view = @add_user_view
    @client = STTwitterAPI.shared_client
  end

  def add_user
    @client.getUserInformationFor(@text_field.text, successBlock: lambda{|user|
      UsersManager.sharedManager.addUser(user)
    }, errorBlock: nil)
  end
end
