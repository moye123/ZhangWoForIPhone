//
//  MyProfileViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
    @private
    UIDatePicker *_datePicker;
    DSXModalView *_datePickerView;
    AFHTTPRequestOperationManager *_afmanager;
}

- (instancetype)init;

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)ZWUserStatus *userStatus;
@property(nonatomic,retain)NSMutableDictionary *profile;

@end
