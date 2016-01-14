//
//  searchBar.m
//  LADLihuibao
//
//  Created by Apple on 15/11/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "searchBar.h"

@implementation searchBar
@synthesize imageView;
@synthesize textField;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"0xF96667"];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 16, 16)];
        self.imageView.image = [UIImage imageNamed:@"icon-search.png"];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imageView];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(26, 0, frame.size.width-55, frame.size.height)];
        self.textField.placeholder = @"搜索商家，分类，地点";
        self.textField.textColor = [UIColor whiteColor];
        self.textField.font = [UIFont systemFontOfSize:13.0];
        self.textField.returnKeyType = UIReturnKeySearch;
        [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [self.textField setValue:[UIFont boldSystemFontOfSize:13.0] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:self.textField];
        
    }
    return self;
}

@end
