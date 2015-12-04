//
//  MyHeadView.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyHeadView.h"

@implementation MyHeadView
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.textLabel = [[UILabel alloc] init];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top-bg.png"]];
    }
    return self;
}

- (void)setImageView:(UIImageView *)imageView{
    if (imageView) {
        _imageView = imageView;
        _imageView.frame = CGRectMake(0, 0, 80, 80);
        _imageView.layer.cornerRadius = 40;
        _imageView.layer.masksToBounds = YES;
        CGPoint center = self.center;
        center.y = center.y + 10;
        _imageView.center = center;
        [self addSubview:_imageView];
    }
}

- (void)setTextLabel:(UILabel *)textLabel{
    if (textLabel) {
        _textLabel = textLabel;
        CGPoint center = self.center;
        _textLabel.frame = CGRectMake(0, center.y+50, self.frame.size.width, 30);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:18.0];
        [self addSubview:_textLabel];
    }
}

@end
