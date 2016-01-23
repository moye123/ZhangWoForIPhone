//
//  RegWithEmailViewController.m
//  LADZhangWo
//
//  Created by Apple on 16/1/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RegWithEmailViewController.h"

@implementation RegWithEmailViewController
@synthesize usernameView   = _usernameView;
@synthesize emailView      = _emailView;
@synthesize passwordView   = _passwordView;
@synthesize registerButton = _registerButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    [self setTitle:@"邮箱注册"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    //用户名
    _usernameView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 40)];
    _usernameView.leftImage = @"icon-username.png";
    _usernameView.placeHolder = @"请输入用户名:";
    _usernameView.textField.delegate = self;
    [self.view addSubview:_usernameView];
    
    //邮箱输入框
    _emailView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 60, SWIDTH-20, 40)];
    _emailView.leftImage = @"icon-mobilefill.png";
    _emailView.placeHolder = @"请输入邮箱地址:";
    _emailView.textField.delegate = self;
    [self.view addSubview:_emailView];
    
    //密码输入框
    _passwordView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 110, SWIDTH-20, 40)];
    _passwordView.leftImage = @"icon-lock.png";
    _passwordView.placeHolder = @"请输入密码:";
    _passwordView.textField.secureTextEntry = YES;
    _passwordView.textField.delegate = self;
    [self.view addSubview:_passwordView];
    
    _registerButton = [DSXUI longButtonWithTitle:@"注册"];
    _registerButton.frame = CGRectMake(10, 170, SWIDTH-20, 40);
    _registerButton.layer.cornerRadius = 20.0;
    [_registerButton addTarget:self action:@selector(checkRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkRegister{
    NSString *username = _usernameView.text;
    NSString *email    = _emailView.text;
    NSString *password = _passwordView.text;

    if (![username isUsername]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"用户名输入错误"];
        return;
    }
    if (![email isEmail]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"邮箱地址输入错误"];
        return;
    }
    if (![password isPassword]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"密码输入错误,至少6位"];
        return;
    }
    
    if (username && email && password) {
        _registerButton.enabled = NO;
        NSDictionary *params = @{@"username":username,
                                 @"email":email,
                                 @"password":password,
                                 @"type":@"email"};
        UIView *loadingView = [[DSXUI standardUI] showLoadingViewWithMessage:@"注册中..."];
        [[ZWUserStatus sharedStatus] register:params success:^(id responseObject) {
            [NSTimer scheduledTimerWithTimeInterval:2
                                             target:self
                                           selector:@selector(registerSucceed:)
                                           userInfo:loadingView repeats:NO];
        } failure:^(NSString *errorMsg) {
            _registerButton.enabled = YES;
            [loadingView removeFromSuperview];
            [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:errorMsg];
        }];
    }
}

- (void)registerSucceed:(NSTimer *)timer{
    UIView *view = [timer userInfo];
    [view removeFromSuperview];
    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"注册成功"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
