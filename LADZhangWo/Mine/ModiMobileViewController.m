//
//  ModiMobileViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ModiMobileViewController.h"

@implementation ModiMobileViewController
@synthesize mobileField    = _mobileField;
@synthesize seccodeField   = _seccodeField;
@synthesize secButton      = _secButton;
@synthesize mobilenewField = _mobilenewField;
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"修改手机号"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _mobileField = [self textFieldWithPlaceHolder:@"请输入手机号"];
    _mobileField.text = [ZWUserStatus sharedStatus].mobile;
    
    _seccodeField = [self textFieldWithPlaceHolder:@"请输入验证码"];
    [_seccodeField sizeThatFits:CGSizeMake(100, 40)];
    
    _secButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _secButton.layer.cornerRadius = 15.0;
    _secButton.layer.masksToBounds = YES;
    _secButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_secButton setBackgroundColor:[UIColor colorWithHexString:@"0xe2e2e2"]];
    [_secButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_secButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _mobilenewField = [self textFieldWithPlaceHolder:@"请输入新号码"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 100)];
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, SWIDTH-20, 40)];
    submitButton.layer.cornerRadius = 20.0;
    submitButton.layer.masksToBounds = YES;
    [submitButton setBackgroundColor:[UIColor whiteColor]];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button-selected.png"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
    _tableView.tableFooterView = footerView;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)textFieldWithPlaceHolder:(NSString *)placeHolder{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, 40)];
    textField.font = [UIFont systemFontOfSize:16.0];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = placeHolder;
    return textField;
}

- (void)sendSecCode{
    NSString *phone = _mobileField.text;
    if ([phone isMobile]) {
        NSString *urlString = [NSString stringWithFormat:@"&c=member&a=sendseccode&phone=%@",phone];
        [[DSXHttpManager sharedManager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                _secCode = [responseObject objectForKey:@"seccode"];
                if (_secCode != nil) {
                    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"验证码发送成功"];
                    _waitSeconds = 60;
                    [_secButton setTitle:@"重新发送(60)" forState:UIControlStateNormal];
                    [_secButton setEnabled:NO];
                    [_secButton setBackgroundColor:[UIColor colorWithHexString:@"0xf5f5f5"]];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wating:) userInfo:nil repeats:YES];
                }else {
                    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"验证码发送失败"];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        NSLog(@"手机号输入错误");
    }
}

- (void)wating:(NSTimer *)timer{
    _waitSeconds--;
    [_secButton setTitle:[NSString stringWithFormat:@"重新发送(%d)",_waitSeconds] forState:UIControlStateNormal];
    if (_waitSeconds < 1) {
        [timer invalidate];
        [_secButton setEnabled:YES];
        [_secButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [_secButton setBackgroundColor:[UIColor colorWithHexString:@"0xe2e2e2"]];
    }
}

- (void)submit{
    NSString *mobile = _mobileField.text;
    NSString *mobilenew = _mobilenewField.text;
    NSString *secCode = _seccodeField.text;
    if (![secCode isEqualToString:_secCode]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"验证码错误"];
        return;
    }
    
    if (![mobilenew isMobile]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"新手机号输入错误"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([ZWUserStatus sharedStatus].uid) forKey:@"uid"];
    [params setObject:[ZWUserStatus sharedStatus].username forKey:@"username"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:mobilenew forKey:@"newmobile"];
    [params setObject:secCode forKey:@"seccode"];
    
    [[DSXHttpManager sharedManager] POST:@"&c=member&a=modimobile" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[ZWUserStatus sharedStatus].userInfo];
                [userInfo setObject:mobilenew forKey:@"mobile"];
                [[ZWUserStatus sharedStatus] update];
                [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"手机修改成功"];
                [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(back) userInfo:nil repeats:NO];
            }else {
                [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError
                                                 Message:[responseObject objectForKey:@"errno"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell addSubview:_mobileField];
        }
        
        if (indexPath.row == 1) {
            [cell addSubview:_seccodeField];
            cell.accessoryView = _secButton;
            [_secButton addTarget:self action:@selector(sendSecCode) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell addSubview:_mobilenewField];
        }
    }
    return cell;
}

@end
