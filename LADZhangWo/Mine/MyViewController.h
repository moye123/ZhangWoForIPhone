//
//  MyViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCatView.h"
#import "MyHeadView.h"
#import "TitleCell.h"

@interface MyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,OrderCatViewDelegate>{
    @private
    UIButton *_buttonMessage;
    UIButton *_buttonSetting;
    MyHeadView *_headerView;
    OrderCatView *_orderCatView;
    UILabel *_loginout;
}

@property(nonatomic,retain)UIView *topView;
@property(nonatomic,retain)UITableView *tableView;

@end
