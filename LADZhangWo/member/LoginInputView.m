//
//  LoginInputView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LoginInputView.h"

@implementation LoginInputView
@synthesize imageView;
@synthesize textField;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:imageView];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, frame.size.width-50, 40)];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:self.textField];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
@end
