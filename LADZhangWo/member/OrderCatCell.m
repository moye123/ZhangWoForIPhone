//
//  OrderCatCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OrderCatCell.h"

@implementation OrderCatCell
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize data = _data;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-30)/2, 10, 26, 26)];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    _imageView.image = [UIImage imageNamed:[data objectForKey:@"icon"]];
    _titleLabel.text = [data objectForKey:@"title"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
