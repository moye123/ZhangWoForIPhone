//
//  RegisterViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterViewController2.h"
#import "LoginInputView.h"

@implementation RegisterViewController
@synthesize mobileField;
@synthesize passwordField;
@synthesize registerButton;
@synthesize seccodeField;
@synthesize seccodeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    [self setTitle:@"手机注册"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBackWhite target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邮箱注册" style:UIBarButtonItemStylePlain target:self action:@selector(showRegister)];
    
    //手机号输入框
    LoginInputView *mobileView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 40)];
    mobileView.imageView.image = [UIImage imageNamed:@"account.png"];
    mobileView.textField.placeholder = @"请输入手机号:";
    [self.view addSubview:mobileView];
    
    self.mobileField = mobileView.textField;
    self.mobileField.returnKeyType = UIReturnKeyDone;
    self.mobileField.delegate = self;
    
    //密码输入框
    LoginInputView *passwordView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 60, SWIDTH-20, 40)];
    passwordView.imageView.image = [UIImage imageNamed:@"password.png"];
    passwordView.textField.placeholder = @"请输入密码:";
    passwordView.textField.secureTextEntry = YES;
    [self.view addSubview:passwordView];
    
    self.passwordField = passwordView.textField;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.delegate = self;
    
    //短信验证码
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(10, 120, SWIDTH-20, 40)];
    secView.backgroundColor = [UIColor whiteColor];
    
    self.seccodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 120, 40)];
    self.seccodeField.placeholder = @"短信验证码:";
    self.seccodeField.returnKeyType = UIReturnKeyDone;
    self.seccodeField.delegate = self;
    [secView addSubview:self.seccodeField];
    
    //发送验证码按钮
    self.seccodeButton = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-120, 0, 100, 40)];
    [self.seccodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.seccodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.seccodeButton setBackgroundImage:[UIImage imageNamed:@"seccodebutton.png"] forState:UIControlStateNormal];
    [self.seccodeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.seccodeButton addTarget:self action:@selector(sendSecCode) forControlEvents:UIControlEventTouchUpInside];
    [secView addSubview:self.seccodeButton];
    
    [self.view addSubview:secView];
    
    self.registerButton = [[DSXUI sharedUI] longButtonWithTitle:@"注册"];
    self.registerButton.frame = CGRectMake(10, 230, SWIDTH-20, 40);
    self.registerButton.layer.cornerRadius = 20.0;
    [self.registerButton addTarget:self action:@selector(checkRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showRegister{
    RegisterViewController2 *registerController = [[RegisterViewController2 alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)sendSecCode{
    NSString *phone = self.mobileField.text;
    if ([phone length] == 11) {
        _watingTime = 60;
        self.seccodeButton.enabled = NO;
        [self.seccodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.seccodeButton setBackgroundImage:[UIImage imageNamed:@"seccodebutton2.png"] forState:UIControlStateNormal];
        [self.seccodeButton setTitle:@"重新发送(60)" forState:UIControlStateNormal];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wating:) userInfo:nil repeats:YES];
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDone Message:@"验证码发送成功"];
        
        NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=member&ac=sendseccode&phone=%@",phone];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //NSLog(@"发送成功");
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }else {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"手机号码输入错误"];
    }
    
}

- (void)wating:(NSTimer *)timer{
    _watingTime--;
    [self.seccodeButton setTitle:[NSString stringWithFormat:@"重新发送(%d)",_watingTime] forState:UIControlStateNormal];
    if (_watingTime < 1) {
        [timer invalidate];
        self.seccodeButton.enabled = YES;
        [self.seccodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.seccodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.seccodeButton setBackgroundImage:[UIImage imageNamed:@"seccodebutton.png"] forState:UIControlStateNormal];
    }
}

- (void)checkRegister{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *mobile = self.mobileField.text;
    NSString *password = self.passwordField.text;
    NSString *seccode = self.seccodeField.text;
    if ([mobile length] != 11) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"手机号码输入错误"];
        return;
    }
    if ([password length] < 6) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"密码输入错误,至少6位"];
        return;
    }
    
    if ([seccode length] != 6) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"验证码输入错误"];
        return;
    }
    
    if (mobile && password && seccode) {
        [params setObject:mobile forKey:@"mobile"];
        [params setObject:password forKey:@"password"];
        [params setObject:seccode forKey:@"seccode"];
        [params setObject:@"mobile" forKey:@"type"];
        self.registerButton.enabled = NO;
        UIView *loadingView = [[DSXUI sharedUI] showLoadingViewWithMessage:@"注册中..."];
        [[ZWUserStatus sharedStatus] register:params success:^(id responseObject) {
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
