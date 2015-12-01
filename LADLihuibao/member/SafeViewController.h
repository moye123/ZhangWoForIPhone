//
//  SafeViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface SafeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

- (instancetype)init;

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)LHBUserStatus *userStatus;

@end