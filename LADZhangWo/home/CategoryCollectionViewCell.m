//
//  CategoryCollectionViewCell.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CategoryCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CategoryCollectionViewCell

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setData:(NSDictionary *)dict{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 50)/2, 0, 50, 57)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"channelimage"]]];
    [self addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 57, self.frame.size.width, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [dict objectForKey:@"channelname"];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:titleLabel];
}

@end
