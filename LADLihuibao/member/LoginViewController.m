//
//  LoginViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LoginInputView.h"

@implementation LoginViewController
@synthesize usernameField;
@synthesize passwordField;
@synthesize loginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    [self setTitle:@"登录利惠宝"];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(closeLogin)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(showRegister)];
    
    //用户名输入框
    LoginInputView *usernameView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 40)];
    usernameView.imageView.image = [UIImage imageNamed:@"account.png"];
    usernameView.textField.placeholder = @"用户名/邮箱/手机号";
    [self.view addSubview:usernameView];
    self.usernameField = usernameView.textField;
    self.usernameField.delegate = self;
    self.usernameField.returnKeyType = UIReturnKeyDone;
    
    //密码输入框
    LoginInputView *passwordView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 60, SWIDTH-20, 40)];
    passwordView.imageView.image = [UIImage imageNamed:@"password.png"];
    passwordView.textField.placeholder = @"密码";
    passwordView.textField.secureTextEntry = YES;
    [self.view addSubview:passwordView];
    self.passwordField = passwordView.textField;
    self.passwordField.delegate = self;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 170, SWIDTH-20, 37)];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"button-login.png"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"button-login-selected.png"] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    NSDictionary *loginInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"loginInfo"];
    if (loginInfo) {
        self.usernameField.text = [loginInfo objectForKey:@"account"];
        self.passwordField.text = [loginInfo objectForKey:@"password"];
    }
}

- (void)closeLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showRegister{
    RegisterViewController *registerController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)login{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSString *account = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if ([account length] < 1) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"账号输入错误"];
        return;
    }
    
    if ([password length] < 6) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"密码不能少于6位"];
        return;
    }
    [userInfo setObject:account forKey:@"account"];
    [userInfo setObject:password forKey:@"password"];
    UIView *loadingView = [[DSXUI sharedUI] showLoadingViewWithMessage:@"登录中..."];
    [[LHBUserStatus status] login:userInfo success:^(id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"loginInfo"];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loginSucceed:) userInfo:loadingView repeats:NO];
    } failure:^(NSString *errorMsg) {
        [loadingView removeFromSuperview];
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:errorMsg];
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
