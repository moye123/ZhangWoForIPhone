//
//  DSXRefreshView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Size.h"

@interface DSXRefreshView : UIView

@property(nonatomic,readonly)UILabel *textLabel;
@property(nonatomic,readonly)UIActivityIndicatorView *indicatorView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
