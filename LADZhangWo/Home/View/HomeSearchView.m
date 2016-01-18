//
//  HomeSearchView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HomeSearchView.h"

@implementation HomeSearchView
@synthesize imageView = _imageView;
@synthesize textField = _textField;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"0xF96667"];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 16, 16)];
        _imageView.image = [UIImage imageNamed:@"icon-search.png"];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(26, 0, frame.size.width-55, frame.size.height)];
        _textField.placeholder = @"搜索商家，分类，地点";
        _textField.textColor = [UIColor whiteColor];
        _textField.font = [UIFont systemFontOfSize:13.0];
        _textField.returnKeyType = UIReturnKeySearch;
        [_textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:[UIFont boldSystemFontOfSize:13.0] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_textField];
        
    }
    return self;
}

@end
