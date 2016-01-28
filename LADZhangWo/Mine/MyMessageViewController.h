//
//  MyMessageViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeViewCell.h"

@interface MyMessageViewController : UITableViewController<DSXRefreshDelegate>{
    @private
    BOOL _isRefreshing;
    int _page;
}

- (instancetype)init;
@property(nonatomic,strong)NSMutableArray *messageList;

@end
