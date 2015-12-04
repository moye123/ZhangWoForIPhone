//
//  DSXUI.m
//  YuShuiHePan
//
//  Created by songdewei on 15/9/15.
//  Copyright (c) 2015年 yushuihepan. All rights reserved.
//

#import "DSXUI.h"
#import "LoginViewController.h"
#import "ZWNavigationController.h"

NSString *const DSXFontStyleThin = @"Noto-Sans-S-Chinese-Thin";
NSString *const DSXFontStyleLight = @"Noto-Sans-S-Chinese-Light";
NSString *const DSXFontStyleDemilight = @"Noto-Sans-S-Chinese-DemiLight";
NSString *const DSXFontStyleMedinum = @"Noto-Sans-S-Chinese-Medium";
NSString *const DSXFontStyleBold = @"Noto-Sans-S-Chinese-Bold";
NSString *const DSXFontStyleBlack = @"Noto-Sans-S-Chinese-Black";
@implementation DSXUI

+ (instancetype)sharedUI{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (UIBarButtonItem *)barButtonWithImage:(NSString *)imageName target:(id)target action:(SEL)action{
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    return barButtonItem;
}

- (UIBarButtonItem *)barButtonWithStyle:(DSXBarButtonStyle)style target:(id)target action:(SEL)action{
    NSString *imageName;
    switch (style) {
        case DSXBarButtonStyleBack:
            imageName = @"icon-back.png";
            break;
        case DSXBarButtonStyleBackWhite:
            imageName = @"icon-back-white.png";
            break;
        case DSXBarButtonStyleFavorite:
            imageName = @"icon-favorite.png";
            break;
        case DSXBarButtonStyleLike:
            imageName = @"icon-like.png";
            break;
        case DSXBarButtonStyleShare:
            imageName = @"icon-share.png";
            break;
        case DSXBarButtonStyleAdd:
            imageName = @"icon-add.png";
            break;
        case DSXBarButtonStyleRefresh:
            imageName = @"icon-refresh.png";
            break;
        case DSXBarButtonStyleMore:
            imageName = @"icon-more.png";
            break;
        case DSXBarButtonStyleMoreWhite:
            imageName = @"icon-more-white.png";
            break;
        case DSXBarButtonStyleClose:
            imageName = @"icon-close.png";
            break;
        default:
            break;
    }
    return [self barButtonWithImage:imageName target:target action:action];
}

- (UIButton *)longButtonWithTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    [button.layer setMasksToBounds:YES];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"button-bg.png"] forState:UIControlStateHighlighted];
    return button;
}

- (void)showPopViewWithStyle:(DSXPopViewStyle)style Message:(NSString *)message{
    NSString *imageName;
    switch (style) {
        case DSXPopViewStyleDone:
            imageName = @"icon-done.png";
            break;
        case DSXPopViewStyleError:
            imageName = @"icon-error.png";
            break;
        case DSXPopViewStyleWarning:
            imageName = @"icon-warn.png";
            break;
        default:
            imageName = @"icon-info.png";
            break;
    }
    
    UIView *popView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [popView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0];
    [label sizeToFit];
    [popView addSubview:label];
    popView.backgroundColor = [UIColor blackColor];
    popView.layer.cornerRadius = 5.0;
    popView.layer.masksToBounds = YES;
    popView.frame = CGRectMake(0, 0, label.frame.size.width+30, label.frame.size.height+67);
    popView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    [imageView setFrame:CGRectMake((popView.frame.size.width-32)/2, 10, 32, 32)];
    
    CGRect frame;
    frame = label.frame;
    frame.origin.x = 15;
    frame.origin.y = 52;
    [label setFrame:frame];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:popView];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hidePopView:) userInfo:popView repeats:NO];
}

- (void)hidePopView:(NSTimer *)timer{
    UIView *popView = [timer userInfo];
    [popView removeFromSuperview];
}

- (UIView *)showLoadingViewWithMessage:(NSString *)message{
    UIView *popView = [[UIView alloc] init];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [popView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0];
    [label sizeToFit];
    [popView addSubview:label];
    popView.backgroundColor = [UIColor blackColor];
    popView.layer.cornerRadius = 5.0;
    popView.layer.masksToBounds = YES;
    popView.frame = CGRectMake(0, 0, label.frame.size.width+30, label.frame.size.height+67);
    popView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    [indicatorView setFrame:CGRectMake((popView.frame.size.width-40)/2, 10, 40, 40)];
    CGRect frame;
    frame = label.frame;
    frame.origin.x = 15;
    frame.origin.y = 52;
    [label setFrame:frame];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:popView];
    return popView;
}

- (void)showLoginFromViewController:(UIViewController *)controller{
    LoginViewController *loginController = [[LoginViewController alloc] init];
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:loginController];
    [controller presentViewController:nav animated:YES completion:nil];
}

@end