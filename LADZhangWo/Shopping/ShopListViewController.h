//
//  ShopListViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopItemCell.h"

@interface ShopListViewController : DSXTableViewController<UITableViewDelegate,UITableViewDataSource,DSXDropDownMenuDelegate>{
    @private
    DSXDropDownMenu *_popMenu;
}

@end
