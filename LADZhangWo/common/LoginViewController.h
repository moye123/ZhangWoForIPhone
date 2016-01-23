//
//  LoginViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "LoginInputView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain)LoginInputView *usernameView;
@property(nonatomic,retain)LoginInputView *passwordView;
@property(nonatomic,retain)UIButton *loginButton;
@end
