//
//  RegisterViewController2.m
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RegisterViewController2.h"
#import "LoginInputView.h"

@implementation RegisterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    [self setTitle:@"邮箱注册"];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"手机注册" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //邮箱输入框
    LoginInputView *emailView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 40)];
    emailView.imageView.image = [UIImage imageNamed:@"account.png"];
    emailView.textField.placeholder = @"请输入邮箱:";
    [self.view addSubview:emailView];
    
    self.emailField = emailView.textField;
    self.emailField.returnKeyType = UIReturnKeyDone;
    self.emailField.delegate = self;
    
    //密码输入框
    LoginInputView *passwordView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 60, SWIDTH-20, 40)];
    passwordView.imageView.image = [UIImage imageNamed:@"password.png"];
    passwordView.textField.placeholder = @"请输入密码:";
    passwordView.textField.secureTextEntry = YES;
    [self.view addSubview:passwordView];
    
    self.passwordField = passwordView.textField;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.delegate = self;
    
    //注册按钮
    self.registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 170, SWIDTH-20, 37)];
    [self.registerButton setBackgroundImage:[UIImage imageNamed:@"button-register"] forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:[UIImage imageNamed:@"button-register-selected.png"] forState:UIControlStateHighlighted];
    [self.registerButton addTarget:self action:@selector(checkRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkRegister{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    if ([email length] < 3) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"邮箱输入错误"];
        return;
    }
    
    if ([password length] < 6) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"密码输入错误，至少6位"];
        return;
    }
    
    if (email && password) {
        [params setObject:email forKey:@"email"];
        [params setObject:password forKey:@"password"];
        [params setObject:@"email" forKey:@"type"];
        self.registerButton.enabled = NO;
        UIView *loadingView = [[DSXUI sharedUI] showLoadingViewWithMessage:@"注册中..."];
        [[LHBUserStatus status] register:params success:^(id responseObject) {
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(registerSucceed:) userInfo:loadingView repeats:NO];
        } failure:^(NSString *errorMsg) {
            self.registerButton.enabled = YES;
            [loadingView removeFromSuperview];
            [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:errorMsg];
        }];
    }
}

- (void)registerSucceed:(NSTimer *)timer{
    UIView *view = [timer userInfo];
    [view removeFromSuperview];
    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"注册成功"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
