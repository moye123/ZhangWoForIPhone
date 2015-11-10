//
//  IncomeView.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "IncomeView.h"

@implementation IncomeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setup];
    }
    return self;
}

- (void)setup{
    CGRect backgroundFrame = self.frame;
    backgroundFrame.size.height = backgroundFrame.size.height - 50;
    UIImageView *background = [[UIImageView alloc] initWithFrame:backgroundFrame];
    [background setImage:[UIImage imageNamed:@"incomebg.png"]];
    [background setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:background];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    titleLabel.text = @"累计收益";
    titleLabel.textColor = [UIColor colorWithRed:0.85 green:0.55 blue:0.31 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:18.0 weight:500];
    [self addSubview:titleLabel];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    numberLabel.text = @"￥3:00";
    numberLabel.textColor = [UIColor colorWithRed:0.44 green:0.82 blue:0.67 alpha:1];
    numberLabel.font = [UIFont systemFontOfSize:30.0 weight:500];
    [numberLabel sizeToFit];
    [numberLabel setCenter:self.center];
    [self addSubview:numberLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 0.8)];
    line.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self addSubview:line];
    
    UILabel *inviteTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height-36, 100, 30)];
    inviteTitleLabel.text = @"累计邀请人数";
    inviteTitleLabel.font = [UIFont systemFontOfSize:18.0];
    [inviteTitleLabel sizeToFit];
    [self addSubview:inviteTitleLabel];
    
    UILabel *totalInviteLable = [[UILabel alloc] init];
    totalInviteLable.text = @"1人";
    totalInviteLable.textColor = [UIColor colorWithRed:0.42 green:0.82 blue:0.67 alpha:1];
    totalInviteLable.font = [UIFont systemFontOfSize:18.0];
    [totalInviteLable sizeToFit];
    
    CGRect frame = totalInviteLable.frame;
    frame.origin.x = self.frame.size.width - frame.size.width -20;
    frame.origin.y = self.frame.size.height - 36;
    [totalInviteLable setFrame:frame];
    [self addSubview:totalInviteLable];
}

@end
