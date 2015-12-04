//
//  DSXUI.h
//  YuShuiHePan
//
//  Created by songdewei on 15/9/15.
//  Copyright (c) 2015年 yushuihepan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    DSXBarButtonStyleBack,
    DSXBarButtonStyleBackWhite,
    DSXBarButtonStyleAdd,
    DSXBarButtonStyleLike,
    DSXBarButtonStyleShare,
    DSXBarButtonStyleFavorite,
    DSXBarButtonStyleRefresh,
    DSXBarButtonStyleMore,
    DSXBarButtonStyleMoreWhite,
    DSXBarButtonStyleClose
}DSXBarButtonStyle;

typedef NS_ENUM(NSInteger,DSXPopViewStyle){
    DSXPopViewStyleDefault,
    DSXPopViewStyleWarning,
    DSXPopViewStyleDone,
    DSXPopViewStyleError
};

UIKIT_EXTERN NSString *const DSXFontStyleThin;
UIKIT_EXTERN NSString *const DSXFontStyleLight;
UIKIT_EXTERN NSString *const DSXFontStyleDemilight;
UIKIT_EXTERN NSString *const DSXFontStyleMedinum;
UIKIT_EXTERN NSString *const DSXFontStyleBold;
UIKIT_EXTERN NSString *const DSXFontStyleBlack;

@interface DSXUI : NSObject

+ (instancetype)sharedUI;

- (UIBarButtonItem *)barButtonWithImage:(NSString *)imageName target:(id)target action:(SEL)action;
- (UIBarButtonItem *)barButtonWithStyle:(DSXBarButtonStyle)style target:(id)target action:(SEL)action;
- (UIButton *)longButtonWithTitle:(NSString *)title;
- (void)showPopViewWithStyle:(DSXPopViewStyle)style Message:(NSString *)message;
- (UIView *)showLoadingViewWithMessage:(NSString *)message;
- (void)showLoginFromViewController:(UIViewController *)controller;


@end