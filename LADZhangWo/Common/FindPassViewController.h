//
//  FindPassViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface FindPassViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic)int step;
@property(nonatomic)UITextField *textField;
@property(nonatomic)UIButton *submitButton;
@property(nonatomic)NSString *phone;
@property(nonatomic)NSString *seccode;

@end
