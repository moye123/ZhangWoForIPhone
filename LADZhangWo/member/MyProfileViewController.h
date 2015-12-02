//
//  MyProfileViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

- (instancetype)init;

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)ZWUserStatus *userStatus;

@end
