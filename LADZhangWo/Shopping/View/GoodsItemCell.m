//
//  GoodsItemCell.m
//  LADZhangWo
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GoodsItemCell.h"

@implementation GoodsItemCell
@synthesize backView      = _backView;
@synthesize picView       = _picView;
@synthesize nameLabel     = _nameLabel;
@synthesize starView      = _starView;
@synthesize soldLabel     = _soldLabel;
@synthesize priceLabel    = _priceLabel;
@synthesize shopLabel     = _shopLabel;
@synthesize locationLabel = _locationLabel;
@synthesize goodsData     = _goodsData;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView removeFromSuperview];
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        
        _picView = [[UIImageView alloc] init];
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.layer.masksToBounds = YES;
        _picView.layer.cornerRadius = 3.0;
        _picView.backgroundColor = [UIColor grayColor];
        [_backView addSubview:_picView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16.0];
        [_backView addSubview:_nameLabel];
        
        _starView = [[DSXStarView alloc] init];
        [_backView addSubview:_starView];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _priceLabel.textColor = [UIColor colorWithRed:0.97 green:0.47 blue:0.29 alpha:1];
        [_backView addSubview:_priceLabel];
        
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.font = [UIFont systemFontOfSize:14.0];
        _soldLabel.textColor = [UIColor grayColor];
        [_backView addSubview:_soldLabel];
        
        _shopLabel = [[UILabel alloc] init];
        _shopLabel.font = [UIFont systemFontOfSize:12.0];
        _shopLabel.textColor = [UIColor grayColor];
        [_backView addSubview:_shopLabel];
        
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
    [_shopLabel setText:[goodsData objectForKey:@"shopname"]];
    [_locationLabel setText:[goodsData objectForKey:@"distance"]];
    [_locationLabel sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_priceLabel sizeToFit];
    [_soldLabel sizeToFit];
    [_shopLabel sizeToFit];
    [_locationLabel sizeToFit];
    CGFloat imageWidth   = self.frame.size.height-20;
    CGFloat imageHeight  = imageWidth;
    CGFloat lineHeight   = imageHeight/4;
    _backView.frame      = CGRectMake(10, 10, SWIDTH-20, imageWidth);
    _picView.frame       = CGRectMake(0, 0, imageWidth, imageHeight);
    _nameLabel.frame     = CGRectMake(imageWidth+10, 0, SWIDTH-imageWidth-20, lineHeight);
    _starView.position   = CGPointMake(imageWidth+10, lineHeight+3);
    _priceLabel.frame    = CGRectMake(imageWidth+10, lineHeight*2, _priceLabel.frame.size.width, lineHeight);
    _soldLabel.frame     = CGRectMake(_backView.frame.size.width - _soldLabel.frame.size.width, lineHeight*2, _soldLabel.frame.size.width, lineHeight);
    _shopLabel.frame     = CGRectMake(imageWidth+10, lineHeight*3, _shopLabel.frame.size.width, lineHeight);
    _locationLabel.frame = CGRectMake(_backView.frame.size.width-_locationLabel.frame.size.width, lineHeight*3, _locationLabel.frame.size.width,lineHeight);
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
