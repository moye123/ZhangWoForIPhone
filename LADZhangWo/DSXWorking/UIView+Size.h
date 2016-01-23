//
//  UIView+Size.h
//  XiangBaLao
//
//  Created by Apple on 16/1/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(size)
- (CGSize)size;
- (CGPoint)position;
- (void)setSize:(CGSize)size;
- (void)setPosition:(CGPoint)position;

@property(nonatomic)CGSize size;
@property(nonatomic)CGPoint position;
@end
