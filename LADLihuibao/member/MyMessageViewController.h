//
//  MyMessageViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface MyMessageViewController : UITableViewController{
    @private
    AFHTTPRequestOperationManager *_afmanager;
}

- (instancetype)init;

@property(nonatomic,retain)LHBUserStatus *userStatus;
@property(nonatomic,strong)NSMutableArray *messageList;

@end
