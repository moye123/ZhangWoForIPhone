//
//  MyIncomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyIncomeViewController : UITableViewController{
    @private
}

@property(nonatomic,strong)NSMutableArray *incomeList;
@property(nonatomic,retain)ZWUserStatus *userStatus;

@end
