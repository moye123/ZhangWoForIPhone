//
//  ServiceItemCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ServiceItemCell.h"

@implementation ServiceItemCell
@synthesize serviceData   = _serviceData;
@synthesize imageWidth    = _imageWidth;
@synthesize startView     = _startView;
@synthesize contactLabel  = _contactLabel;
@synthesize addressLabel  = _addressLabel;
@synthesize distanceLabel = _distanceLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _startView = [[DSXStarView alloc] init];
        [self addSubview:_startView];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_addressLabel];
        
        _contactLabel = [[UILabel alloc] init];
        _contactLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_contactLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:12.0];
        _distanceLabel.textColor = [UIColor redColor];
        [self addSubview:_distanceLabel];
    }
    return self;
}

- (void)setServiceData:(NSDictionary *)serviceData{
    _serviceData = serviceData;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[serviceData objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.textLabel setText:[serviceData objectForKey:@"title"]];
    [_startView setStarNum:[[serviceData objectForKey:@"score"] integerValue]];
    [_contactLabel setText:[NSString stringWithFormat:@"TEL:%@",[serviceData objectForKey:@"contact"]]];
    [_addressLabel setText:[serviceData objectForKey:@"address"]];
    [_distanceLabel setText:@"100m"];
    [_distanceLabel sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.frame = CGRectMake(10, 10, _imageWidth, _imageWidth);
    self.textLabel.frame = CGRectMake(_imageWidth+20, 10, SWIDTH-_imageWidth-30, 25);
    self.textLabel.font  = [UIFont systemFontOfSize:16.0];
    _startView.position  = CGPointMake(_imageWidth+20, 40);
    _contactLabel.frame  = CGRectMake(_imageWidth+20, _imageWidth-30, 150, 20);
    _addressLabel.frame  = CGRectMake(_imageWidth+20, _imageWidth-10, 120, 20);
    _distanceLabel.frame = CGRectMake(SWIDTH-_distanceLabel.frame.size.width-10, _imageWidth-10, _distanceLabel.frame.size.width, _distanceLabel.frame.size.height);
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
