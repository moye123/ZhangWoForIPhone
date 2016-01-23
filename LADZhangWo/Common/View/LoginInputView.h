//
//  LoginInputView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginInputView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic)NSString *leftImage;
@property(nonatomic)NSString *placeHolder;
@property(nonatomic)NSString *text;
@property(nonatomic,readonly)UIImageView *leftView;
@property(nonatomic,readonly)UITextField *textField;

@end
