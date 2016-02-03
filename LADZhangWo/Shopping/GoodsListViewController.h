//
//  GoodsListViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsItemCell.h"
#import "ChooseToolbar.h"

@interface GoodsListViewController : DSXTableViewController<UITableViewDelegate,UITableViewDataSource,DSXDropDownMenuDelegate,ChooseToolbarDelegate>{
    @private
    DSXDropDownMenu *_popMenu;
    ChooseToolbar *_chooseBar;
    NSString *_sortBy;
    NSString *_asc;
}

@property(nonatomic,assign)NSInteger catid;

@end
