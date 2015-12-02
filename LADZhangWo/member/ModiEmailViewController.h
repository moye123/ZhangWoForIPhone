//
//  ModiEmailViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface ModiEmailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    @private
    AFHTTPRequestOperationManager *_afmanager;
}

@property(nonatomic,retain)ZWUserStatus *userStatus;
@property(nonatomic,retain)UITextField *emailField;
@property(nonatomic,retain)UITextField *passwordField;
@property(nonatomic,retain)UITableView *tableView;

@end
