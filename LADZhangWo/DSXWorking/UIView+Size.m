//
//  UIView+Size.m
//  XiangBaLao
//
//  Created by Apple on 16/1/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIView+Size.h"

@implementation UIView(size)

- (CGSize)size{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (CGPoint)position{
    return CGPointMake(self.frame.origin.x, self.frame.origin.y);
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size.width  = size.width;
    frame.size.height = size.height;
    [self setFrame:frame];
}

- (void)setPosition:(CGPoint)position{
    CGRect frame = self.frame;
    frame.origin.x = position.x;
    frame.origin.y = position.y;
    [self setFrame:frame];
}


@end
