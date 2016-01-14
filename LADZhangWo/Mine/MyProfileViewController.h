//
//  MyProfileViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    @private
    UIDatePicker *_datePicker;
    DSXModalView *_datePickerView;
}

- (instancetype)init;

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSMutableDictionary *profile;

@end
