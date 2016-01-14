//
//  ShopItemCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ShopItemCell.h"

@implementation ShopItemCell
@synthesize backView      = _backView;
@synthesize picView       = _picView;
@synthesize nameLabel     = _nameLabel;
@synthesize starView      = _starView;
@synthesize priceLabel    = _priceLabel;
@synthesize locationLabel = _locationLabel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 100)];
        _backView.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
        
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_backView addSubview:_picView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, SWIDTH-120, 30)];
        _nameLabel.font = [UIFont systemFontOfSize:16.0];
        [_backView addSubview:_nameLabel];
        
        _starView = [[DSXStarView alloc] initWithStarNum:0 position:CGPointMake(110, 30)];
        [_backView addSubview:_starView];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 75, 100, 20)];
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

- (void)setShopData:(NSDictionary *)shopData{
    _shopData = shopData;
    [_picView sd_setImageWithURL:[NSURL URLWithString:[shopData objectForKey:@"pic"]]];
    [_starView setStarNum:3];
    [_priceLabel setText:[NSString stringWithFormat:@"￥:10元起"]];
    [_nameLabel setText:[shopData objectForKey:@"shopname"]];
    [_locationLabel setText:[shopData objectForKey:@"distance"]];
    [_locationLabel sizeToFit];
    [_locationLabel setFrame:CGRectMake(_backView.frame.size.width-_locationLabel.frame.size.width-10, 80, _locationLabel.frame.size.width, _locationLabel.frame.size.height)];
}

@end
