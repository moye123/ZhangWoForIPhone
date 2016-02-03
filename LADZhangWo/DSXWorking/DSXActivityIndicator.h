//
//  DSXActivityIndicator.h
//  XiangBaLao
//
//  Created by Apple on 16/2/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DSXActivityIndicator : NSObject
@property(nonatomic)NSString *title;
@property(nonatomic,readonly)UIWindow *window;
@property(nonatomic,readonly)UIView *modalView;
@property(nonatomic,readonly)UIView *loadingView;
@property(nonatomic,readonly)UILabel *textLabel;
@property(nonatomic,readonly)UIActivityIndicatorView *indicatorView;

- (instancetype)init;
+ (instancetype)sharedIndicator;

- (void)showViewWithTitle:(NSString *)title;
- (void)showModalViewWithTitle:(NSString *)title;
- (void)hide;

@end
