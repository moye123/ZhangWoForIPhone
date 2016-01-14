//
//  FavorItemCell.m
//  LADZhangWo
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "FavorItemCell.h"

@implementation FavorItemCell
@synthesize picView = _picView;
@synthesize titleLabel = _titleLabel;
@synthesize timeLabel = _timeLabel;
@synthesize priceLabel = _priceLabel;
@synthesize locationLabel = _locationLabel;
@synthesize favorData = _favorData;
@synthesize idType = _idType;

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
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picWidth+25, 50, 120, 20)];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_timeLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picWidth+25, _picWidth-10, 100, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:15.0];
        _priceLabel.textColor = [UIColor colorWithHexString:@"0x3DC0AD"];
        [self addSubview:_priceLabel];
    }
    return self;
}

- (void)setFavorData:(NSDictionary *)favorData{
    _favorData = favorData;
    [_picView sd_setImageWithURL:[NSURL URLWithString:[favorData objectForKey:@"pic"]]];
    if ([_idType isEqualToString:@"aid"] || [_idType isEqualToString:@"travelid"]) {
        [_titleLabel setText:[favorData objectForKey:@"title"]];
        [_priceLabel setText:[favorData objectForKey:@"username"]];
    }
    
    if ([_idType isEqualToString:@"goodsid"] || [_idType isEqualToString:@"csgoodsid"]) {
        [_titleLabel setText:[favorData objectForKey:@"name"]];
        [_priceLabel setText:[NSString stringWithFormat:@"￥:%.2f",[[favorData objectForKey:@"price"] floatValue]]];
    }
    
    if ([_idType isEqualToString:@"shopid"] || [_idType isEqualToString:@"chaoshiid"]) {
        [_titleLabel setText:[favorData objectForKey:@"shopname"]];
        [_priceLabel setText:[favorData objectForKey:@"username"]];
    }
    
}

@end
