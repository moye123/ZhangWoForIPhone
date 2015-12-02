//
//  ModiEmailViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface ModiEmailViewController : UIViewController{
    @private
    AFHTTPRequestOperationManager *_afmanager;
}

@property(nonatomic,retain)LHBUserStatus *userStatus;
@property(nonatomic,retain)UITextField *emailField;
@property(nonatomic,retain)UITextField *passwordField;

@end
