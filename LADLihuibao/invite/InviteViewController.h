//
//  InviteViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface InviteViewController : UIViewController
- (void)getInviteCode;

@property(nonatomic,strong)NSString *inviteCode;
@property(nonatomic,retain)LHBUserStatus *userStatus;
@end
