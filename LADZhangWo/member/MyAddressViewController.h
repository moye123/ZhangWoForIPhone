//
//  MyAddressViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyAddressViewController : UIViewController

@property(nonatomic,retain)ZWUserStatus *userStatus;
@property(nonatomic,strong)NSMutableArray *addressList;

@end
