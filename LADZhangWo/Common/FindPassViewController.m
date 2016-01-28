//
//  FindPassViewController.m
//  LADZhangWo
//
//  Created by Apple on 16/1/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FindPassViewController.h"

@implementation FindPassViewController
@synthesize step = _step;
@synthesize textField = _textField;
@synthesize submitButton = _submitButton;
@synthesize phone   = _phone;
@synthesize seccode = _seccode;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    [self setTitle:@"找回密码"];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    if (!_step) {
        _step = 1;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SWIDTH, 20)];
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, SWIDTH-20, 40)];
    _textField.font = [UIFont systemFontOfSize:15.0];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 5.0;
    _textField.layer.borderWidth = 0.8;
    _textField.layer.borderColor = [UIColor colorWithHexString:@"0xe5e5e5"].CGColor;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_textField];
    
    _submitButton = [DSXUI longButtonWithTitle:@"下一步"];
    _submitButton.frame = CGRectMake(10, 150, SWIDTH-20, 40);
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5.0;
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:[UIColor colorWithHexString:@"0x009900"]];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"button-highlight.png"] forState:UIControlStateHighlighted];
    [_submitButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    if (_step == 1) {
        titleLabel.text = @"请输入你绑定的手机号";
        _textField.placeholder = @"请输入手机号:";
        _textField.keyboardType = UIKeyboardTypePhonePad;
    }else if (_step == 2){
        titleLabel.text = @"请输入你手机收到的验证码";
        _textField.placeholder = @"请输入验证码:";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }else if(_step == 3) {
        titleLabel.text = @"请设置新密码";
        _textField.placeholder = @"请输入新密码:";
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.secureTextEntry = YES;
    }else if (_step == 4){
        [_textField setHidden:YES];
        titleLabel.text = @"密码修改成功";
        titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        titleLabel.textColor = [UIColor colorWithHexString:@"0x006600"];
        
        _submitButton.frame = CGRectMake(10, 110, SWIDTH-20, 40);
        [_submitButton setTitle:@"马上登录" forState:UIControlStateNormal];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextStep:(UIButton *)button{
    if (_step == 1) {
        _phone = _textField.text;
        if ([_phone isMobile]) {
            [[DSXHttpManager sharedManager] POST:@"&c=member&a=findpass&step=1" parameters:@{@"phone":_phone} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                        
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];
            FindPassViewController *findView = [[FindPassViewController alloc] init];
            findView.step = 2;
            findView.phone = _phone;
            [self.navigationController pushViewController:findView animated:YES];
        }else {
            [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"手机号输入错误"];
        }
    }
    
    if (_step == 2) {
        _seccode = _textField.text;
        if ([_seccode length] > 0) {
            [[DSXHttpManager sharedManager] POST:@"&c=member&a=findpass&step=2" parameters:@{@"phone":_phone,@"seccode":_seccode} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                        FindPassViewController *findView = [[FindPassViewController alloc] init];
                        findView.step = 3;
                        findView.phone = _phone;
                        findView.seccode = _seccode;
                        [self.navigationController pushViewController:findView animated:YES];
                        
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    }
    
    if (_step == 3) {
        NSString *password = _textField.text;
        if (![_phone isMobile]) {
            return;
        }
        if ([_seccode length] == 0) {
            return;
        }
        if (![password isPassword]) {
            [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"密码输入错误"];
            return;
        }
        NSDictionary *params = @{@"phone":_phone,@"seccode":_seccode,@"password":password};
        [[DSXHttpManager sharedManager] POST:@"&c=member&a=findpass&step=3" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                    FindPassViewController *findView = [[FindPassViewController alloc] init];
                    findView.step = 4;
                    [self.navigationController pushViewController:findView animated:YES];
                    
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
    
    if (_step == 4) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
