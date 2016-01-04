//
//  RechargeViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXPayManager.h"

@interface RechargeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,DSXPayManagerDelegate>{
    @private
    UITextField *_amountField;
    NSInteger _index;
    NSString *_payType;
}

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,assign)NSInteger step;

@end
