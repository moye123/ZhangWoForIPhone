//
//  DSXStarView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXStarView.h"

@implementation DSXStarView

- (instancetype)initWithStar:(NSInteger)starnum{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 77, 14);
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 77, 14)];
        [backView setImage:[UIImage imageNamed:@"icon-star-gray.png"]];
        [self addSubview:backView];
        
        CGFloat width = (CGFloat)starnum * 66/5;
        UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 14)];
        [starView setImage:[UIImage imageNamed:@"icon-star-orange.png"]];
        [starView.layer setMasksToBounds:YES];
        [starView setContentMode:UIViewContentModeLeft];
        //starView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon-star-orange.png"]];
        [self addSubview:starView];
    }
    return self;
}

@end
