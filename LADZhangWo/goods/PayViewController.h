//
//  PayViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface PayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)NSInteger orderid;
@property(nonatomic,strong)NSString *orderno;
@property(nonatomic,strong)NSString *orderTitle;
@property(nonatomic,assign)float total;
@property(nonatomic,retain)UITableView *tableView;

@end
