//
//  SearchViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface SearchViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>{
    @private
}

@property(nonatomic)NSMutableArray *dataList;
@property(nonatomic)UISearchBar *searchBar;

@end
