//
//  MyWalletViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface MyWalletViewController : UITableViewController{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    UIView *_headerView;
    UIView *_footerView;
    UILabel *_totalLabel;
}

@property(nonatomic,strong)NSDictionary *walletData;
@property(nonatomic,retain)LHBUserStatus *userStatus;

@end
