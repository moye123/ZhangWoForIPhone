//
//  LHBPullUpView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWPullUpView : UILabel

- (instancetype)initWithFrame:(CGRect)frame;
- (void)beginLoading;
- (void)endLoading;

@end
