//
//  MyHeadView.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyHeadView.h"

@implementation MyHeadView
@synthesize imageView;
@synthesize textLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top-bg.png"]];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        self.imageView.layer.cornerRadius = 40;
        self.imageView.layer.masksToBounds = YES;
        CGPoint center = self.center;
        center.y = center.y + 10;
        self.imageView.center = center;
        [self addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, center.y+45, frame.size.width, 30)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:18.0];
        [self addSubview:self.textLabel];
    }
    return self;
}

@end
