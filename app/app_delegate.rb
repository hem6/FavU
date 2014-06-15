class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    user_timelines_controller = UserTimelinesController.alloc.initWithNibName(nil, bundle:nil)
    navigation_controller = UINavigationController.alloc.initWithRootViewController(user_timelines_controller)
    config_navigation_bar
    @window.rootViewController = navigation_controller

    @window.makeKeyAndVisible
    true
  end

  def config_navigation_bar
    UINavigationBar.appearance.barTintColor = "#1E95D4".uicolor
    UINavigationBar.appearance.titleTextAttributes = {
      NSForegroundColorAttributeName => UIColor.whiteColor,
      NSFontAttributeName            => UIFont.boldSystemFontOfSize(18)
    }
    UINavigationBar.appearance.tintColor = UIColor.whiteColor
  end

  def applicationDidEnterBackground(application)
    manager = UsersManager.sharedManager
    manager.updateUsers
    manager.saveUsers
  end
end
