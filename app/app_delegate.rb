class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return if RUBYMOTION_ENV == 'test'
    rootViewController = ViewController.alloc.initWithStyle(UITableViewStyleGrouped)
    rootViewController.title = 'TestiOS'

    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    true
  end
end
