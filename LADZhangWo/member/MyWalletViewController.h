//
//  MyWalletViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyWalletViewController : UITableViewController{
    @private
    UIView *_headerView;
    UIView *_footerView;
    UILabel *_totalLabel;
}

- (instancetype)init;
@property(nonatomic,strong)NSDictionary *walletData;

@end
