//
//  GoodsItemCell.m
//  LADZhangWo
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GoodsItemCell.h"

@implementation GoodsItemCell
@synthesize picView = _picView;
@synthesize titleLabel = _titleLabel;
@synthesize starView = _starView;
@synthesize priceLabel = _priceLabel;
@synthesize locationLabel = _locationLabel;
@synthesize goodsData = _goodsData;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _picWidth = SWIDTH * 0.37;
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _picWidth, _picWidth)];
        _picView.layer.masksToBounds = YES;
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_picView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picWidth+25, 10, SWIDTH-_picWidth-30, 40)];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textAlignment = NSTextAlignmentJustified;
        [self addSubview:_titleLabel];
        
        _starView = [[DSXStarView alloc] initWithStarNum:0 position:CGPointMake(_picWidth+25, 50)];
        [self addSubview:_starView];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picWidth+25, _picWidth-10, 100, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:15.0];
        _priceLabel.textColor = [UIColor colorWithHexString:@"0x3DC0AD"];
        [self addSubview:_priceLabel];
    }
    return self;
}

- (void)setGoodsData:(NSDictionary *)goodsData{
    _goodsData = goodsData;
    [_picView sd_setImageWithURL:[NSURL URLWithString:[goodsData objectForKey:@"pic"]]];
    [_titleLabel setText:[goodsData objectForKey:@"name"]];
    [_starView setStarNum:[[goodsData objectForKey:@"score"] integerValue]];
    [_priceLabel setText:[NSString stringWithFormat:@"￥:%.2f",[[goodsData objectForKey:@"price"] floatValue]]];
}

@end
