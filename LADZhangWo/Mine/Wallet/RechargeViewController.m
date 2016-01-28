//
//  RechargeViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RechargeViewController.h"
#import "MyWalletViewController.h"

@implementation RechargeViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"账户充值"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
    
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 100)];
    _tableView.tableFooterView = footerView;
    
    UIButton *submitButton = [DSXUI whiteButtonWithTitle:@"确认充值"];
    [submitButton setFrame:CGRectMake(10, 50, SWIDTH-20, 40)];
    [submitButton.layer setCornerRadius:20.0];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
    
    _amountField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SWIDTH-115, 40)];
    _amountField.placeholder = @"请输入充值金额";
    _amountField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _amountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _index = 0;
    _payType = @"wechat";
    _hasSubmitPay = NO;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done{
    [self.view endEditing:YES];
}

- (void)submit{
    [_amountField resignFirstResponder];
    if (_hasSubmitPay == YES) {
        return;
    }
    DSXPayManager *pay = [DSXPayManager sharedManager];
    pay.delegate = self;
    pay.orderName = @"账号充值";
    pay.orderDetail = @"长沃账号充值";
    //pay.orderAmount = @"0.01";
    pay.orderAmount = _amountField.text;
    if (!(pay.orderAmount.floatValue > 0)) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleWarning Message:@"请输入有效金额"];
        return;
    }
    _hasSubmitPay = YES;
    NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                             @"username":[ZWUserStatus sharedStatus].username,
                             @"billname":pay.orderName,
                             @"detail":pay.orderDetail,
                             @"amount":pay.orderAmount};
    [[DSXHttpManager sharedManager] POST:@"&c=bill&a=create" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *returns = [responseObject objectForKey:@"data"];
            if ([[returns objectForKey:@"billid"] integerValue] > 0) {
                
                pay.payID   = [returns objectForKey:@"billid"];
                pay.orderNO = [NSString stringWithFormat:@"zw%@",pay.payID];
                pay.payType = @"recharge";
                if ([_payType isEqualToString:@"wechat"]) {
                    [pay WechatPay];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尽请期待" message:@"此支付方式暂未开通" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - paymanager delegate
- (void)payManager:(DSXPayManager *)manager didFinishedWithCode:(int)errCode{
    if (errCode == 0) {
        NSDictionary *params =@{@"uid":@([ZWUserStatus sharedStatus].uid),
                                @"username":[ZWUserStatus sharedStatus].username,
                                @"amount":manager.orderAmount};
        [[DSXHttpManager sharedManager] POST:@"" parameters:params progress:nil success:nil failure:nil];
        [self back];
    }else {
        _hasSubmitPay = NO;
    }
}

#pragma mark --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rechargeCell"];
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.imageView.image = [UIImage imageNamed:@"icon-wechat.png"];
        cell.textLabel.text = @"微信支付";
    }
    
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"icon-alipay.png"];
        cell.textLabel.text = @"支付宝支付";
        cell.selected = YES;
    }
    
    if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"icon-unionpay.png"];
        cell.textLabel.text = @"银联支付";
    }
    
    if (indexPath.row == 3) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"充值金额:";
        cell.accessoryView = _amountField;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (indexPath.row < 3) {
        // 取消前一个选中的，就是单选啦
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        
        // 选中操作
        UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        // 保存选中的
        _index = indexPath.row;
        
        if (indexPath.row == 0) {
            _payType = @"wechat";
        }
        if (indexPath.row == 1) {
            _payType = @"alipay";
        }
        if (indexPath.row == 2) {
            _payType = @"unionpay";
        }
    }
    [_amountField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_tableView endEditing:YES];
    [_amountField resignFirstResponder];
}

#pragma mark - payment

@end
