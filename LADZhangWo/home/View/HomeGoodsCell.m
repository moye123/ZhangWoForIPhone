//
//  HomeGoodsCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HomeGoodsCell.h"

@implementation HomeGoodsCell
@synthesize backView      = _backView;
@synthesize picView       = _picView;
@synthesize nameLabel     = _nameLabel;
@synthesize starView      = _starView;
@synthesize soldLabel     = _soldLabel;
@synthesize priceLabel    = _priceLabel;
@synthesize locationLabel = _locationLabel;
@synthesize goodsData     = _goodsData;
@synthesize imageWidth    = _imageWidth;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imageWidth = 100;
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithHexString:@"0xf5f5f5"];
        
        _picView = [[UIImageView alloc] init];
        _picView.layer.masksToBounds = YES;
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        [_backView addSubview:_picView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16.0];
        [_backView addSubview:_nameLabel];
        
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.font = [UIFont systemFontOfSize:14.0];
        _soldLabel.textColor = [UIColor grayColor];
        [_backView addSubview:_soldLabel];
        
        _starView = [[DSXStarView alloc] init];
        [_backView addSubview:_starView];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14.0];
        _priceLabel.textColor = [UIColor colorWithRed:0.97 green:0.47 blue:0.29 alpha:1];
        [_backView addSubview:_priceLabel];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:12.0];
        _locationLabel.textColor = [UIColor grayColor];
        [_backView addSubview:_locationLabel];
        [self addSubview:_backView];
    }
    return self;
}

- (void)setGoodsData:(NSDictionary *)goodsData{
    _goodsData = goodsData;
    
    [_picView sd_setImageWithURL:[NSURL URLWithString:[goodsData objectForKey:@"pic"]]];
    [_starView setStarNum:[[goodsData objectForKey:@"score"] intValue]];
    [_priceLabel setText:[NSString stringWithFormat:@"￥:%@",[goodsData objectForKey:@"price"]]];
    [_nameLabel setText:[goodsData objectForKey:@"name"]];
    [_soldLabel setText:[NSString stringWithFormat:@"已售%@",[goodsData objectForKey:@"sold"]]];
    [_locationLabel setText:[goodsData objectForKey:@"distance"]];
    [_locationLabel sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _backView.frame      = CGRectMake(10, 5, SWIDTH-20, _imageWidth);
    _picView.frame       = CGRectMake(0, 0, _imageWidth, _imageWidth);
    _nameLabel.frame     = CGRectMake(_imageWidth+10, 0, SWIDTH-_imageWidth-20, 35);
    _starView.position   = CGPointMake(_imageWidth+10, 35);
    _soldLabel.frame     = CGRectMake(_imageWidth+10, _imageWidth-45, 80, 20);
    _priceLabel.frame    = CGRectMake(_imageWidth+10, _imageWidth-25, 100, 20);
    _locationLabel.frame = CGRectMake(_backView.frame.size.width-_locationLabel.frame.size.width-10, _imageWidth-22, _locationLabel.frame.size.width, _locationLabel.frame.size.height);
}

@end
