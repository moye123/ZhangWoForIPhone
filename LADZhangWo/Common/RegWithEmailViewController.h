//
//  RegWithEmailViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "LoginInputView.h"

@interface RegWithEmailViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic)LoginInputView *usernameView;
@property(nonatomic)LoginInputView *emailView;
@property(nonatomic)LoginInputView *passwordView;
@property(nonatomic,retain)UIButton *registerButton;

@end
