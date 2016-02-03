//
//  TravelListViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "TravelItemCell.h"

@interface TravelListViewController : DSXTableViewController<UITableViewDelegate,UITableViewDataSource,DSXDropDownMenuDelegate>{
    @private
    DSXDropDownMenu *_popMenu;
}
@property(nonatomic,assign)NSInteger catid;

@end
