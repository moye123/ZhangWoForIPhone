//
//  InviteViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface InviteViewController : UIViewController{
    @private
    NSString *_inviteKey;
}
- (void)getInviteCode;

@property(nonatomic,strong)NSString *inviteCode;
@property(nonatomic,retain)ZWUserStatus *userStatus;
@end
