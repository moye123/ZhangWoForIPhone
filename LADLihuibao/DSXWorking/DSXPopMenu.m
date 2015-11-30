//
//  DSXPopMenu.m
//  LADLihuibao
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXPopMenu.h"

@implementation DSXPopMenu

- (instancetype)init{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, -150, 100, 170);
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 23, 18)];
        [arrow setImage:[UIImage imageNamed:@"pop-arrow.png"]];
        [self addSubview:arrow];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 18, 100, 150)];
        contentView.layer.cornerRadius = 10.0;
        contentView.layer.masksToBounds = YES;
        contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pop-bg.png"]];
        [self addSubview:contentView];
        
        UIButton *messageButton = [self buttonWithImage:@"pop-message.png" andTitle:@"消息"];
        messageButton.frame = CGRectMake(0, 0, frame.size.width, 50);
        [contentView addSubview:messageButton];
        
        UIButton *favorButton = [self buttonWithImage:@"pop-favor.png" andTitle:@"收藏"];
        favorButton.frame = CGRectMake(0, 51, frame.size.width, 50);
        [contentView addSubview:favorButton];
        
        UIButton *homeButtom = [self buttonWithImage:@"pop-home.png" andTitle:@"首页"];
        homeButtom.frame = CGRectMake(0, 102, frame.size.width, 50);
        [contentView addSubview:homeButtom];
        
    }
    return self;
}

- (UIButton *)buttonWithImage:(NSString *)imageName andTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundColor:[UIColor blackColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 22, 22)];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [button addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 14, 0, 0)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    [button addSubview:titleLabel];
    return button;
}

- (void)toggle{
    if (self.hidden) {
        self.hidden = NO;
        CGRect frame = self.frame;
        frame.origin.y = 60;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        self.hidden = YES;
        CGRect frame = self.frame;
        frame.origin.y = -150;
        self.frame = frame;
    }
}

@end
