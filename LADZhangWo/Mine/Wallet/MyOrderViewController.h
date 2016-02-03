//
//  MyOrderViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItemCell.h"
#import "OrderCommonCell.h"

@interface MyOrderViewController : DSXTableViewController<UITableViewDelegate,UITableViewDataSource,DSXDropDownMenuDelegate>{
    @private
    UILabel *_tipsView;
    DSXDropDownMenu *_popMenu;
}

@property(nonatomic,strong)NSString *orderStatus;
@property(nonatomic,strong)NSString *payStatus;
@property(nonatomic,strong)NSString *shippingStatus;
@property(nonatomic,strong)NSString *evaluateStatus;
- (instancetype)init;
@end
