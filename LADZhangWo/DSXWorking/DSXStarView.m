//
//  DSXStarView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXStarView.h"

@implementation DSXStarView
@synthesize starNum = _starNum;
@synthesize position = _position;
- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 77, 14);
        self.backgroundColor = [UIColor clearColor];
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 77, 14)];
        [backView setImage:[UIImage imageNamed:@"icon-star-gray.png"]];
        [backView setContentMode:UIViewContentModeLeft];
        [self addSubview:backView];
        
        _starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-star-orange.png"]];
        [_starView.layer setMasksToBounds:YES];
        [_starView setContentMode:UIViewContentModeLeft];
        [self addSubview:_starView];
    }
    return self;
}

- (instancetype)initWithStarNum:(NSInteger)starNum position:(CGPoint)position{
    if (self = [self init]) {
        self.starNum = starNum;
        self.position = position;
    }
    return self;
}

- (void)setStarNum:(NSInteger)starNum{
    _starNum = starNum;
    CGFloat width = (CGFloat)starNum * 77/5;
    [_starView setFrame:CGRectMake(0, 0, width, 14)];
}

- (void)setPosition:(CGPoint)position{
    _position = position;
    CGRect frame = self.frame;
    frame.origin.x = position.x;
    frame.origin.y = position.y;
    [self setFrame:frame];
}

@end
