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
        self.frame = CGRectMake(0, 0, 66, 12);
        self.backgroundColor = [UIColor whiteColor];
        //UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 66, 12)];
        //backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon-star-gray.png"]];
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 66, 12)];
        [backView setImage:[UIImage imageNamed:@"icon-star-gray.png"]];
        [self addSubview:backView];
        
        CGFloat width = starnum * 66/5;
        UIView *starView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 12)];
        starView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon-star-orange.png"]];
        [self addSubview:starView];
    }
    return self;
}

@end
