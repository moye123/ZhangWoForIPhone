//
//  AppDelegate.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "ZWCommon.h"
#import "LaunchView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic)LaunchView *launchView;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

