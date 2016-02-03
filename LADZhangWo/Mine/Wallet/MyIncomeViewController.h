//
//  MyIncomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyIncomeViewController : DSXTableViewController<UITableViewDelegate,UITableViewDataSource>{
    @private
    UILabel *_tipsView;
}

@end
