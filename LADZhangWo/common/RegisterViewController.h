//
//  RegisterViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "LoginInputView.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>{
    @private
    int _watingTime;
}

@property(nonatomic)LoginInputView *usernameView;
@property(nonatomic)LoginInputView *mobileView;
@property(nonatomic)LoginInputView *passwordView;
@property(nonatomic,retain)UIButton *registerButton;
@property(nonatomic,retain)UITextField *seccodeField;
@property(nonatomic,retain)UIButton *seccodeButton;
@end
