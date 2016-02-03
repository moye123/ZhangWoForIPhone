//
//  MyFavoriteViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavorItemCell.h"

@interface MyFavoriteViewController : DSXTableViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,DSXRefreshDelegate>{
    UIToolbar *_toolbar;
}

@end
