//
//  BuyViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface BuyViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>{
    @private
    UILabel *_buyNum;
    UITextField *_numField;
    UIButton *_useCoupons;
    UILabel *_total;
    UIButton *_submitButton;
    AFHTTPRequestOperationManager *_afmanager;
}

- (instancetype)init;

@property(nonatomic,assign)NSInteger goodsid;
@property(nonatomic,strong)NSDictionary *goodsdata;
@property(nonatomic,retain)UITableView *contentTableView;
@property(nonatomic,retain)LHBUserStatus *userStatus;

@end
