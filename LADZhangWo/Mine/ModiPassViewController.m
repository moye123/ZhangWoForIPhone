//
//  ModiPassViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ModiPassViewController.h"

@implementation ModiPassViewController
@synthesize oldPassField   = _oldPassField;
@synthesize passwordField  = _passwordField;
@synthesize passwordField2 = _passwordField2;
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"修改密码"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _oldPassField   = [self textFieldWithPlaceHolder:@"请输入原密码:"];
    _passwordField  = [self textFieldWithPlaceHolder:@"请输入新密码:"];
    _passwordField2 = [self textFieldWithPlaceHolder:@"请确认新密码:"];
    
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
    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = placeHolder;
    return textField;
 }

- (void)submit{
    NSString *oldpass = _oldPassField.text;
    NSString *password = _passwordField.text;
    NSString *password2 = _passwordField2.text;
    if ([oldpass length] == 0) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"请输入原密码"];
        return;
    }
    if (![DSXValidate validatePassword:oldpass]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"原密码输入错误"];
        return;
    }
    
    if ([password length] == 0) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"请输入新密码"];
        return;
    }
    
    if (![DSXValidate validatePassword:password]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"新密码输入错误"];
        return;
    }
    
    if (![password isEqualToString:password2]) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"密码输入不一致"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([ZWUserStatus sharedStatus].uid) forKey:@"uid"];
    [params setObject:[ZWUserStatus sharedStatus].username forKey:@"username"];
    [params setObject:[oldpass md5] forKey:@"oldpass"];
    [params setObject:[password md5] forKey:@"password"];
    [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=member&a=modipass"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"uid"] integerValue] == [ZWUserStatus sharedStatus].uid) {
                [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"密码修改成功"];
                [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(back) userInfo:nil repeats:NO];
            }else {
                if ([[responseObject objectForKey:@"errno"] integerValue] == -1) {
                    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"原密码错误"];
                }
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
        return 1;
    }else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell addSubview:_oldPassField];
        }
        
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell addSubview:_passwordField];
        }
        
        if (indexPath.row == 1) {
            [cell addSubview:_passwordField2];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
