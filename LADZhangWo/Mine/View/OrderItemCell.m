//
//  OrderItemCell.m
//  LADZhangWo
//
//  Created by Apple on 15/12/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "OrderItemCell.h"

@implementation OrderItemCell
@synthesize picView    = _picView;
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;
@synthesize numLabel   = _numLabel;
@synthesize goodsData  = _goodsData;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView removeFromSuperview];
        self.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        self.selectionStyle  = UITableViewCellSelectionStyleGray;
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self addSubview:_picView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, SWIDTH-110, 40)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, SWIDTH-110, 20)];
        _priceLabel.textColor = [UIColor colorWithHexString:@"0x3DC0AD"];
        _priceLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_priceLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH-40, 70, 30, 20)];
        _numLabel.textColor = [UIColor blackColor];
        _numLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_numLabel];
    }
    return self;
}

- (void)setGoodsData:(NSDictionary *)goodsData{
    _goodsData = goodsData;
    [_picView sd_setImageWithURL:[NSURL URLWithString:[goodsData objectForKey:@"goods_pic"]]];
    [_titleLabel setText:[goodsData objectForKey:@"goods_name"]];
    [_priceLabel setText:[NSString stringWithFormat:@"￥%@",[goodsData objectForKey:@"goods_price"]]];
    [_numLabel setText:[NSString stringWithFormat:@"x%@",[goodsData objectForKey:@"buynum"]]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
