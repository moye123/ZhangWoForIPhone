//
//  RegisterViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegWithEmailViewController.h"

@implementation RegisterViewController
@synthesize usernameView = _usernameView;
@synthesize mobileView   = _mobileView;
@synthesize passwordView = _passwordView;
@synthesize registerButton = _registerButton;
@synthesize seccodeField   = _seccodeField;
@synthesize seccodeButton  = _seccodeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    [self setTitle:@"手机注册"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邮箱注册" style:UIBarButtonItemStylePlain target:self action:@selector(showRegister)];
    
    //用户名
    _usernameView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 40)];
    _usernameView.leftImage = @"icon-username.png";
    _usernameView.placeHolder = @"请输入用户名:";
    _usernameView.textField.delegate = self;
    [self.view addSubview:_usernameView];
    
    //手机号输入框
    _mobileView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 60, SWIDTH-20, 40)];
    _mobileView.leftImage = @"icon-mobilefill.png";
    _mobileView.placeHolder = @"请输入手机号:";
    _mobileView.textField.delegate = self;
    _mobileView.textField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_mobileView];
    
    //密码输入框
    _passwordView = [[LoginInputView alloc] initWithFrame:CGRectMake(10, 110, SWIDTH-20, 40)];
    _passwordView.leftImage = @"icon-lock.png";
    _passwordView.placeHolder = @"请输入密码:";
    _passwordView.textField.secureTextEntry = YES;
    _passwordView.textField.delegate = self;
    [self.view addSubview:_passwordView];
    
    //短信验证码
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(10, 160, SWIDTH-20, 40)];
    secView.backgroundColor = [UIColor whiteColor];
    
    _seccodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 120, 40)];
    _seccodeField.placeholder = @"短信验证码:";
    _seccodeField.returnKeyType = UIReturnKeyDone;
    _seccodeField.delegate = self;
    _seccodeField.keyboardType = UIKeyboardTypeNumberPad;
    [secView addSubview:_seccodeField];
    
    //发送验证码按钮
    _seccodeButton = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-120, 0, 100, 40)];
    [_seccodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_seccodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_seccodeButton setBackgroundImage:[UIImage imageNamed:@"seccodebutton.png"] forState:UIControlStateNormal];
    [_seccodeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_seccodeButton addTarget:self action:@selector(sendSecCode) forControlEvents:UIControlEventTouchUpInside];
    [secView addSubview:_seccodeButton];
    
    [self.view addSubview:secView];
    
    _registerButton = [DSXUI longButtonWithTitle:@"注册"];
    _registerButton.frame = CGRectMake(10, 260, SWIDTH-20, 40);
    _registerButton.layer.cornerRadius = 20.0;
    [_registerButton addTarget:self action:@selector(checkRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showRegister{
    RegWithEmailViewController *registerController = [[RegWithEmailViewController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)sendSecCode{
    NSString *phone = _mobileView.text;
    if ([phone length] == 11) {
        [[DSXHttpManager sharedManager] GET:@"&c=member&a=sendseccode" parameters:@{@"phone":phone} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                _watingTime = 60;
                _seccodeButton.enabled = NO;
                [_seccodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [_seccodeButton setBackgroundImage:[UIImage imageNamed:@"seccodebutton2.png"] forState:UIControlStateNormal];
                [_seccodeButton setTitle:@"重新发送(60)" forState:UIControlStateNormal];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wating:) userInfo:nil repeats:YES];
                [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"验证码发送成功"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"手机号码输入错误"];
    }
    
}

- (void)wating:(NSTimer *)timer{
    _watingTime--;
    [_seccodeButton setTitle:[NSString stringWithFormat:@"重新发送(%d)",_watingTime] forState:UIControlStateNormal];
    if (_watingTime < 1) {
        [timer invalidate];
        [_seccodeButton setEnabled:YES];
        [_seccodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [_seccodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_seccodeButton setBackgroundImage:[UIImage imageNamed:@"seccodebutton.png"] forState:UIControlStateNormal];
    }
}

- (void)checkRegister{
    NSString *username = _usernameView.text;
    NSString *mobile   = _mobileView.text;
    NSString *password = _passwordView.text;
    NSString *seccode  = _seccodeField.text;
    if (![username isUsername]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"用户名输入错误"];
        return;
    }
    if (![mobile isMobile]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"手机号码输入错误"];
        return;
    }
    if (![password isPassword]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"密码输入错误,至少6位"];
        return;
    }
    
    if ([seccode length] != 6) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"验证码输入错误"];
        return;
    }
    
    if (username && mobile && password && seccode) {
        _registerButton.enabled = NO;
        NSDictionary *params = @{@"username":username,
                                 @"mobile":mobile,
                                 @"password":password,
                                 @"seccode":seccode,
                                 @"type":@"mobile"};
        [[DSXActivityIndicator sharedIndicator] showModalViewWithTitle:@"注册中..."];
        [[ZWUserStatus sharedStatus] register:params success:^(id responseObject) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[DSXActivityIndicator sharedIndicator] hide];
                [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"注册成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } failure:^(NSString *errorMsg) {
            _registerButton.enabled = YES;
            [[DSXActivityIndicator sharedIndicator] hide];
            [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:errorMsg];
        }];
    }
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
