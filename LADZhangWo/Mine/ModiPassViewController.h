//
//  ModiPassViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface ModiPassViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

}

@property(nonatomic,retain)UITextField *oldPassField;
@property(nonatomic,retain)UITextField *passwordField;
@property(nonatomic,retain)UITextField *passwordField2;
@property(nonatomic,retain)UITableView *tableView;

@end