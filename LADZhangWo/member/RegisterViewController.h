//
//  RegisterViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>{
    @private
    int _watingTime;
}

@property(nonatomic,retain)UITextField *mobileField;
@property(nonatomic,retain)UITextField *passwordField;
@property(nonatomic,retain)UIButton *registerButton;
@property(nonatomic,retain)UITextField *seccodeField;
@property(nonatomic,retain)UIButton *seccodeButton;
@end
