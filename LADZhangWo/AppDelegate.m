//
//  AppDelegate.m
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "IncomeViewController.h"
#import "CartViewController.h"
#import "MyViewController.h"
#import "LoginViewController.h"
#import "DSXPayManager.h"

@implementation AppDelegate
@synthesize scrollView  = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize hideButton  = _hideButton;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //微信注册
    [WXApi registerApp:WXAppID withDescription:@"长沃"];
    
    [NSThread sleepForTimeInterval:1];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    //启动动画
    _scrollView = [[UIScrollView alloc] initWithFrame:self.window.frame];
    _scrollView.contentSize = CGSizeMake(self.window.frame.size.width*3, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAd)];
    doubleTap.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:doubleTap];
    [_scrollView setUserInteractionEnabled:YES];
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.window.frame.size.width*i, 0, self.window.frame.size.width, self.window.frame.size.height)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"launch_%d.png",i]]];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [_scrollView addSubview:imageView];
        UITapGestureRecognizer *adTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ADImageTap:)];
        [imageView addGestureRecognizer:adTap];
        [imageView setUserInteractionEnabled:YES];
        if (i == 2) {
            _hideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
            _hideButton.layer.cornerRadius = 5.0;
            _hideButton.layer.masksToBounds = YES;
            _hideButton.layer.borderColor = [UIColor whiteColor].CGColor;
            _hideButton.layer.borderWidth = 0.8;
            _hideButton.backgroundColor = [UIColor clearColor];
            _hideButton.center = CGPointMake(self.window.center.x, SHEIGHT-120);
            [_hideButton setTitle:@"立即体验" forState:UIControlStateNormal];
            [_hideButton addTarget:self action:@selector(hideAd) forControlEvents:UIControlEventTouchDown];
            [imageView addSubview:_hideButton];
        }
    }
    [tabBarController.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 3;
    _pageControl.center = CGPointMake(self.window.center.x, SHEIGHT-50);
    [tabBarController.view addSubview:_pageControl];
    //[NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(hideAd) userInfo:nil repeats:NO];

    ZWNavigationController *navHome,*navIncome,*navCart,*navMy;
    HomeViewController *homeView = [[HomeViewController alloc] init];
    homeView.title = @"主页";
    navHome = [[ZWNavigationController alloc] initWithRootViewController:homeView];
    navHome.tabBarItem = [self tabBarItemWithTitle:@"主页" image:@"icon-home.png" selectedImage:@"icon-homefill.png"];
    
    IncomeViewController *incomeView = [[IncomeViewController alloc] init];
    incomeView.title = @"收益";
    navIncome = [[ZWNavigationController alloc] initWithRootViewController:incomeView];
    navIncome.tabBarItem = [self tabBarItemWithTitle:@"收益" image:@"icon-income.png" selectedImage:@"icon-incomefill.png"];
    
    CartViewController *cartView = [[CartViewController alloc] init];
    [cartView setTitle:@"我的购物车"];
    navCart = [[ZWNavigationController alloc] initWithRootViewController:cartView];
    navCart.tabBarItem = [self tabBarItemWithTitle:@"购物车" image:@"icon-cart.png" selectedImage:@"icon-cartfill.png"];
    
    MyViewController *myView = [[MyViewController alloc] init];
    [myView setTitle:@"我的"];
    navMy = [[ZWNavigationController alloc] initWithRootViewController:myView];
    navMy.style = ZWNavigationStyleGray;
    navMy.tabBarItem = [self tabBarItemWithTitle:@"我的" image:@"icon-my.png" selectedImage:@"icon-myfill.png"];
    
    [tabBarController setViewControllers:@[navHome,navIncome,navCart,navMy]];
    [tabBarController.tabBar setBackgroundColor:[UIColor tabBarColor]];
    if ([CLLocationManager locationServicesEnabled]) {
        CLLocationManager *clmanager = [[CLLocationManager alloc] init];
        CLLocation *location = [clmanager location];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placeMark = [placemarks firstObject];
                [[NSUserDefaults standardUserDefaults] setObject:placeMark.locality forKey:@"locality"];
            }else {
                //NSLog(@"%@", error);
            }
        }];
    }
    
    return YES;
}

- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0.36 blue:0.16 alpha:1]} forState:UIControlStateSelected];
    return tabBarItem;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/SWIDTH;
    [_pageControl setCurrentPage:index];
}

- (void)hideAd{
    [_scrollView removeFromSuperview];
    [_pageControl removeFromSuperview];
}

- (void)ADImageTap:(UITapGestureRecognizer *)tap{
    
}

#pragma mark - tabbarcontroller delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (![[ZWUserStatus sharedStatus] isLogined]) {
        if ([viewController isEqual:tabBarController.viewControllers[1]] || [viewController isEqual:tabBarController.viewControllers[2]]) {
            [[ZWUserStatus sharedStatus] showLoginFromViewController:tabBarController];
            return NO;
            
        }else {
            return true;
        }
    }else{
        return YES;
    }
}

#pragma mark - weixin
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:[DSXPayManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:[DSXPayManager sharedManager]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lihuibao1688.LADLihuibao" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LADLihuibao" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LADLihuibao.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
