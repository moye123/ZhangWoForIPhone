//
//  MyBillViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface MyBillViewController : UITableViewController{
    @private
    AFHTTPRequestOperationManager *_afmanager;
}

@property(nonatomic,strong)NSMutableArray *billList;
@property(nonatomic,retain)LHBUserStatus *userStatus;

@end
