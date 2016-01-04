//
//  PayViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "DSXPayManager.h"

@interface PayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DSXPayManagerDelegate>{
    @private
    NSString *_billID;
    NSString *_billAmount;
}

@property(nonatomic,strong)NSString *orderID;
@property(nonatomic,strong)NSString *orderName;
@property(nonatomic,strong)NSString *orderDetail;
@property(nonatomic,retain)UITableView *tableView;

@end
