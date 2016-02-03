//
//  TravelItemCell.m
//  LADZhangWo
//
//  Created by Apple on 16/2/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TravelItemCell.h"
#import "UIView+size.h"
#import "UIImageView+WebCache.h"

@implementation TravelItemCell
@synthesize picView = _picView;
@synthesize titleLabel = _titleLabel;
@synthesize locationIcon = _locationIcon;
@synthesize locationLabel = _locationLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView removeFromSuperview];
        
        _picView = [[UIImageView alloc] init];
        _picView.backgroundColor = [UIColor grayColor];
        [self addSubview:_picView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        _locationIcon = [[UIImageView alloc] init];
        _locationIcon.image = [UIImage imageNamed:@"icon-location.png"];
        [self addSubview:_locationIcon];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:13.0];
        _locationLabel.textColor = [UIColor whiteColor];
        [self addSubview:_locationLabel];
    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [_picView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"pic"]]];
    [_titleLabel setText:[data objectForKey:@"title"]];
    
    NSString *locationText = [NSString stringWithFormat:@"%@ %@",[data objectForKey:@"city"],[data objectForKey:@"address"]];
    [_locationLabel setText:locationText];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.picView.frame = CGRectMake(0, 5, self.width, self.height-10);
    self.titleLabel.frame = CGRectMake(22, self.height-75, self.width-40, 30);
    self.locationIcon.frame = CGRectMake(20, self.height-40, 20, 20);
    self.locationLabel.frame = CGRectMake(43, self.height-40, self.width-60, 20);
}

@end
