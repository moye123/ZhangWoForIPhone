//
//  LoginViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindPassViewController.h"

@implementation LoginViewController
@synthesize usernameView = _usernameView;
@synthesize passwordView = _passwordView;
@synthesize loginButton  = _loginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    [self setTitle:@"登录"];
    
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(closeLogin)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(showRegister)];
    
    //用户名输入框
    _usernameView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 40)];
    _usernameView.leftImage = @"icon-username.png";
    _usernameView.placeHolder = @"用户名/邮箱/手机号";
    _usernameView.textField.delegate = self;
    [self.view addSubview:_usernameView];
    
    //密码输入框
    _passwordView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 60, SWIDTH-20, 40)];
    _passwordView.leftImage = @"icon-lock.png";
    _passwordView.placeHolder = @"密码";
    _passwordView.textField.secureTextEntry = YES;
    [self.view addSubview:_passwordView];
    
    _loginButton = [DSXUI longButtonWithTitle:@"登录"];
    _loginButton.frame = CGRectMake(10, 160, SWIDTH-20, 40);
    _loginButton.layer.cornerRadius = 20.0;
    [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    NSDictionary *loginInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"loginInfo"];
    if (loginInfo) {
        _usernameView.text = [loginInfo objectForKey:@"account"];
        _passwordView.text = [loginInfo objectForKey:@"password"];
    }
    
    //找回密码
    UIButton *findPAssword = [[UIButton alloc] initWithFrame:CGRectMake((SWIDTH-200)/2, 220, 200, 30)];
    [findPAssword setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [findPAssword setTitleColor:[UIColor colorWithRed:0 green:0.45 blue:0.64 alpha:1] forState:UIControlStateNormal];
    [findPAssword.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [findPAssword addTarget:self action:@selector(findPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findPAssword];
}

- (void)closeLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showRegister{
    RegisterViewController *registerController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)findPassword:(UIButton *)button{
    FindPassViewController *findView = [[FindPassViewController alloc] init];
    findView.step = 1;
    [self.navigationController pushViewController:findView animated:YES];
}

- (void)login{
    
    NSString *account  = _usernameView.text;
    NSString *password = _passwordView.text;
    if ([account length] < 1) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"账号输入错误"];
        return;
    }
    
    if ([password length] < 6) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"密码不能少于6位"];
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:account forKey:@"account"];
    [userInfo setObject:password forKey:@"password"];
    UIView *loadingView = [[DSXUI standardUI] showLoadingViewWithMessage:@"登录中,请稍后..."];
    [[ZWUserStatus sharedStatus] login:userInfo success:^(id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"loginInfo"];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loginSucceed:) userInfo:loadingView repeats:NO];
    } failure:^(NSString *errorMsg) {
        [loadingView removeFromSuperview];
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:errorMsg];
    }];
}

- (void)loginSucceed:(NSTimer *)timer{
    UIView *view = [timer userInfo];
    [view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
