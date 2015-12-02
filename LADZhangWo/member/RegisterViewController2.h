//
//  RegisterViewController2.h
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface RegisterViewController2 : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain)UITextField *emailField;
@property(nonatomic,retain)UITextField *passwordField;
@property(nonatomic,retain)UIButton *registerButton;

@end
