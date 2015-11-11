//
//  localView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "localView.h"

@implementation localView
@synthesize textLabel;
@synthesize imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, frame.size.height)];
        self.textLabel.text = @"六盘水";
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.textLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 6.5, 16, 16)];
        self.imageView.image = [UIImage imageNamed:@"icon-arrow-down.png"];
        [self addSubview:self.imageView];
    }
    return self;
}

@end
