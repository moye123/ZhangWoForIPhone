//
//  ModiMobileViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface ModiMobileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    AFHTTPRequestOperationManager *_afmanager;
    NSInteger _waitSeconds;
    NSString *_secCode;
}

@property(nonatomic,retain)ZWUserStatus *userStatus;
@property(nonatomic,retain)UITextField *mobileField;
@property(nonatomic,retain)UITextField *seccodeField;
@property(nonatomic,retain)UIButton *secButton;
@property(nonatomic,retain)UITextField *mobilenewField;
@property(nonatomic,retain)UITableView *tableView;

@end
