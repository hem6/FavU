class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    home_view_controller = HomeViewController.alloc.initWithNibName(nil, bundle:nil)
    navigation_controller = UINavigationController.alloc.initWithRootViewController(home_view_controller)
    @window.rootViewController = navigation_controller
    @window.makeKeyAndVisible
    true
  end

  def applicationDidEnterBackground(application)
    UsersManager.sharedManager.saveUsers
  end
end
