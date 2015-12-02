//
//  ModiEmailViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ModiEmailViewController.h"

@implementation ModiEmailViewController
@synthesize userStatus = _userStatus;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"修改绑定邮箱"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    _userStatus = [ZWUserStatus status];
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    UIView *emailView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 40)];
    emailView.layer.cornerRadius = 5.0;
    emailView.layer.masksToBounds = YES;
    emailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:emailView];
    
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-40, 40)];
    _emailField.placeholder = @"请输入邮箱地址:";
    _emailField.font = [UIFont systemFontOfSize:16.0];
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [emailView addSubview:_emailField];
    
    
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, SWIDTH-20, 40)];
    passwordView.layer.cornerRadius = 5.0;
    passwordView.layer.masksToBounds = YES;
    passwordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordView];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-40, 40)];
    _passwordField.placeholder = @"请输入密码:";
    _passwordField.font = [UIFont systemFontOfSize:16.0];
    _passwordField.secureTextEntry = YES;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordView addSubview:_passwordField];
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 140, SWIDTH-20, 40)];
    submitButton.layer.cornerRadius = 20.0;
    submitButton.layer.masksToBounds = YES;
    [submitButton setBackgroundColor:[UIColor whiteColor]];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button-buy-selected.png"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submit{
    NSString *email = _emailField.text;
    if (![DSXValidate validateEmail:email]) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"邮箱格式错误"];
        return;
    }
    
    NSString *password = _passwordField.text;
    if (![DSXValidate validatePassword:password]) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"密码输入错误"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(_userStatus.uid) forKey:@"uid"];
    [params setObject:_userStatus.username forKey:@"username"];
    [params setObject:email forKey:@"email"];
    [params setObject:[password md5] forKey:@"password"];
    [_afmanager POST:[SITEAPI stringByAppendingString:@"&mod=member&ac=resetemail"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([returns isKindOfClass:[NSDictionary class]]) {
            if ([[returns objectForKey:@"email"] isEqualToString:email]) {
                [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDone Message:@"邮箱绑定成功"];
                [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(back) userInfo:nil repeats:NO];
            }else {
                if ([[returns objectForKey:@"errno"] integerValue] == -1) {
                    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"邮箱格式错误"];
                }
                if ([[returns objectForKey:@"errno"] integerValue] == -2) {
                    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"密码错误"];
                }
            }
        }else {
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
