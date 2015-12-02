//
//  NewsColumnView.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewsColumnView.h"

@implementation NewsColumnView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setButtons];
    }
    return self;
}

- (void)setButtons{
    CGFloat width = 100.0;
    CGFloat height = 50.0;
    UIButton *button;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NewsColumns" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (int i=0; i < [array count]; i++) {
        button = [[UIButton alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        [button setTitle:[array[i] objectForKey:@"cname"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:[[array[i] objectForKey:@"catid"] intValue]];
        [self addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)button{
    
}

@end
