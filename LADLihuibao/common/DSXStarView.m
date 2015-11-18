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
        self.frame = CGRectMake(0, 0, 88, 16);
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 16)];
        backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon-star-gray.png"]];
        [self addSubview:backView];
        
        CGFloat width = starnum * 88/5;
        UIView *starView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 16)];
        starView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon-star-orange.png"]];
        [self addSubview:starView];
    }
    return self;
}

@end
