//
//  ServiceListViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemCell.h"

@interface ServiceListViewController : DSXTableViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,DSXRefreshDelegate>{
    @private
    UIView *_noaccessView;
}

@property(nonatomic)NSInteger catid;
@end
