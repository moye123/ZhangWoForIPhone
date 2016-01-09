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
    UIImage *image = [UIImage imageNamed:imageName];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    return barButtonItem;
}

- (UIBarButtonItem *)barButtonWithStyle:(DSXBarButtonStyle)style target:(id)target action:(SEL)action{
    NSString *imageName;
    switch (style) {
        case DSXBarButtonStyleAdd:
            imageName = @"icon-add.png";
            break;
        case DSXBarButtonStyleBack:
            imageName = @"icon-back.png";
            break;
        case DSXBarButtonStyleClose:
            imageName = @"icon-close.png";
            break;
        case DSXBarButtonStyleDelete:
            imageName = @"icon-delete.png";
            break;
        case DSXBarButtonStyleFavor:
            imageName = @"icon-favor.png";
            break;
        case DSXBarButtonStyleLike:
            imageName = @"icon-like.png";
            break;
        case DSXBarButtonStyleMore:
            imageName = @"icon-more.png";
            break;
        case DSXBarButtonStyleMessage:
            imageName = @"icon-message.png";
            break;
        case DSXBarButtonStyleRefresh:
            imageName = @"icon-refresh.png";
            break;
        case DSXBarButtonStyleShare:
            imageName = @"icon-share.png";
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

- (UIButton *)whiteButtonWithTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    [button.layer setMasksToBounds:YES];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"button-selected.png"] forState:UIControlStateHighlighted];
    return button;
}

- (void)showPopViewWithStyle:(DSXPopViewStyle)style Message:(NSString *)message{
    NSString *imageName;
    switch (style) {
        case DSXPopViewStyleSuccess:
            imageName = @"icon-success.png";
            break;
        case DSXPopViewStyleError:
            imageName = @"icon-error.png";
            break;
        case DSXPopViewStyleWarning:
            imageName = @"icon-warning.png";
            break;
        default:
            imageName = @"icon-infomation.png";
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
    popView.backgroundColor = [UIColor blackColor];
    popView.layer.cornerRadius = 5.0;
    popView.layer.masksToBounds = YES;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    [popView addSubview:indicatorView];
    
    if (message == nil) {
        [popView setFrame:CGRectMake(0, 0, 80, 80)];
        [popView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
        [indicatorView setFrame:CGRectMake(15, 15, 50, 50)];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //[indicatorView setCenter:popView.center];
    }else {
        UILabel *label = [[UILabel alloc] init];
        label.text = message;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0];
        [label sizeToFit];
        [popView addSubview:label];
        
        popView.frame = CGRectMake(0, 0, label.frame.size.width+30, label.frame.size.height+67);
        popView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);        
        
        CGRect frame;
        frame = label.frame;
        frame.origin.x = 15;
        frame.origin.y = 52;
        [label setFrame:frame];
        [indicatorView setFrame:CGRectMake((popView.frame.size.width-40)/2, 10, 40, 40)];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:popView];
    [indicatorView startAnimating];
    return popView;
}

- (void)showLoginFromViewController:(UIViewController *)controller{
    LoginViewController *loginController = [[LoginViewController alloc] init];
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:loginController];
    [controller presentViewController:nav animated:YES completion:nil];
}

- (UILabel *)tipsViewWithTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
    [label sizeToFit];
    return label;
}

+ (UIView *)noAccessView{
    UIView *view = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon-sand.png"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"没有找到你要的信息";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [view addSubview:label];
    
    view.frame = CGRectMake(0, 0, label.frame.size.width, 80);
    imageView.frame = CGRectMake((view.frame.size.width-50)/2, 0, 50, 50);
    label.frame = CGRectMake(0, 60, label.frame.size.width, label.frame.size.height);
    return view;
}

@end