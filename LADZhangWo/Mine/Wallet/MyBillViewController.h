//
//  MyBillViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillItemCell.h"

@interface MyBillViewController : DSXTableViewController<UITableViewDelegate,UITableViewDataSource>{
    @private
    UILabel *_tipsView;
}

@end
