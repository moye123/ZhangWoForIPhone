//
//  OrderDetailViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "OrderItemCell.h"

@interface OrderDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSInteger orderid;
@property(nonatomic)NSDictionary *orderData;
@end
