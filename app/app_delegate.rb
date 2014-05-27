class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    config_navigation_bar
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    user_timelines_controller = UserTimelinesController.alloc.initWithNibName(nil, bundle:nil)
    navigation_controller = UINavigationController.alloc.initWithRootViewController(user_timelines_controller)
    @window.rootViewController = navigation_controller
    @window.makeKeyAndVisible
    true
  end

  def config_navigation_bar
    UINavigationBar.appearance.barTintColor = UIColor.whiteColor
  end

  def applicationDidEnterBackground(application)
    UsersManager.sharedManager.saveUsers
  end
end
