//
//  ModiEmailViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ModiEmailViewController.h"

@implementation ModiEmailViewController
@synthesize emailField    = _emailField;
@synthesize passwordField = _passwordField;
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"修改绑定邮箱"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    [self.view addSubview:_tableView];
    
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-40, 40)];
    _emailField.placeholder = @"请输入邮箱地址:";
    _emailField.font = [UIFont systemFontOfSize:16.0];
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-40, 40)];
    _passwordField.placeholder = @"请输入密码:";
    _passwordField.font = [UIFont systemFontOfSize:16.0];
    _passwordField.secureTextEntry = YES;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, SWIDTH-20, 40)];
    submitButton.layer.cornerRadius = 20.0;
    submitButton.layer.masksToBounds = YES;
    [submitButton setBackgroundColor:[UIColor whiteColor]];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button-selected.png"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 100)];
    [footerView addSubview:submitButton];
    _tableView.tableFooterView = footerView;
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
    [params setObject:@([ZWUserStatus sharedStatus].uid) forKey:@"uid"];
    [params setObject:[ZWUserStatus sharedStatus].username forKey:@"username"];
    [params setObject:email forKey:@"email"];
    [params setObject:[password md5] forKey:@"password"];
    [[AFHTTPRequestOperationManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=member&a=modiemail"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"email"] isEqualToString:email]) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[ZWUserStatus sharedStatus].userInfo];
                [userInfo setObject:email forKey:@"email"];
                //[_userStatus setUserInfo:userInfo];
                [[ZWUserStatus sharedStatus] update];
                [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"邮箱绑定成功"];
                [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(back) userInfo:nil repeats:NO];
            }else {
                if ([[responseObject objectForKey:@"errno"] intValue] == -1) {
                    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"邮箱格式错误"];
                }
                if ([[responseObject objectForKey:@"errno"] intValue] == -2) {
                    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"密码错误"];
                }
            }
        }else {
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        [cell addSubview:_emailField];
    }
    
    if (indexPath.row == 1) {
        [cell addSubview:_passwordField];
    }
    return cell;
}

@end
