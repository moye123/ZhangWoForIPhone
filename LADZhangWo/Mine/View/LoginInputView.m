//
//  LoginInputView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LoginInputView.h"

@implementation LoginInputView
@synthesize imageView = _imageView;
@synthesize textField = _textField;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, frame.size.width-50, 40)];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_textField];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
@end
