//
//  MyIncomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface MyIncomeViewController : UITableViewController{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    int _page;
}

@property(nonatomic,strong)NSMutableArray *incomeList;
@property(nonatomic,retain)LHBUserStatus *userStatus;

@end