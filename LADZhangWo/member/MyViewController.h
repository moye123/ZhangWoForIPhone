//
//  MyViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    @private
    UIButton *_buttonMessage;
    UIButton *_buttonSetting;
}

@property(nonatomic,retain)UIView *topView;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)ZWUserStatus *userStatus;

@end
