//
//  ChaoshiGoodsItemCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChaoshiGoodsItemCell.h"
#import "UIColor+color.h"
#import "UIView+Size.h"

@implementation ChaoshiGoodsItemCell
@synthesize imageView  = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;
@synthesize soldLabel  = _soldLabel;
@synthesize shopLabel  = _shopLabel;
@synthesize shopTextLabel = _shopTextLabel;
@synthesize data = _data;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:16.0];
        _priceLabel.textColor = [UIColor colorWithRed:0.15 green:0.75 blue:0.67 alpha:1];
        [self addSubview:_priceLabel];
        
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.font = [UIFont systemFontOfSize:14.0];
        _soldLabel.textColor = [UIColor grayColor];
        [self addSubview:_soldLabel];
        
        _shopLabel = [[UILabel alloc] init];
        _shopLabel.backgroundColor = [UIColor randomColor];
        _shopLabel.layer.masksToBounds = YES;
        _shopLabel.layer.cornerRadius = 10.0;
        [self addSubview:_shopLabel];
        
        _shopTextLabel = [[UILabel alloc] init];
        _shopTextLabel.font = [UIFont systemFontOfSize:10.0];
        _shopTextLabel.textColor = [UIColor whiteColor];
        [_shopLabel addSubview:_shopTextLabel];
    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"pic"]]];
    
    _titleLabel.text = [data objectForKey:@"name"];
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[data objectForKey:@"price"] floatValue]];
    _soldLabel.text  = [NSString stringWithFormat:@"已售%@",[data objectForKey:@"sold"]];
    _shopTextLabel.text  = [data objectForKey:@"shopname"];
    [_titleLabel sizeToFit];
    [_priceLabel sizeToFit];
    [_soldLabel sizeToFit];
    [_shopTextLabel sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat imageWidth = self.frame.size.width;
    CGFloat imageHeight = imageWidth;
    _imageView.frame = CGRectMake(0, 20, imageWidth, imageHeight);
    
    _titleLabel.frame = CGRectMake(5, imageHeight+20, imageWidth - 10, _titleLabel.frame.size.height);
    _priceLabel.frame = CGRectMake(5, self.frame.size.height-25, _priceLabel.frame.size.width, 20);
    _soldLabel.frame  = CGRectMake(imageWidth-_soldLabel.frame.size.width-5, self.frame.size.height-25, _soldLabel.frame.size.width, 20);
    
    _shopTextLabel.frame = CGRectMake(15, 0, _shopTextLabel.width+15, 20);
    _shopLabel.frame = CGRectMake(-10, 0, _shopTextLabel.width+10, 20);
}

@end
