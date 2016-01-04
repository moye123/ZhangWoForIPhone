//
//  GoodsBottomView.m
//  LADZhangWo
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GoodsBottomView.h"

@implementation GoodsBottomView
@synthesize goodsid = _goodsid;
@synthesize cartButton = _cartButton;
@synthesize buyButton  = _buyButton;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xf5f5f5"];
        CGFloat buttonWidth = (frame.size.width-40)/2;
        _cartButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 4, buttonWidth, 35)];
        _cartButton.layer.cornerRadius = 15.0;
        _cartButton.layer.masksToBounds = YES;
        _cartButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_cartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_cartButton setBackgroundImage:[UIImage imageNamed:@"button-addcart.png"] forState:UIControlStateNormal];
        [_cartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_cartButton];
        
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth+30, 4, buttonWidth, 35)];
        _buyButton.layer.cornerRadius = 15.0;
        _buyButton.layer.masksToBounds = YES;
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_buyButton setTitle:@"立即订购" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buyButton setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_buyButton];
    }
    return self;
}

@end
