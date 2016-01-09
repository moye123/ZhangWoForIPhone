//
//  PayViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PayViewController.h"
#import "MyOrderViewController.h"

@implementation PayViewController
@synthesize orderID     = _orderID;
@synthesize orderName   = _orderName;
@synthesize orderDetail = _orderDetail;
@synthesize tableView   = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"付款"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    _hasSubmitPay = NO;
    //生成支付账单
    NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                             @"username":[ZWUserStatus sharedStatus].username,
                             @"orderid":_orderID,
                             @"billname":_orderName,
                             @"detail":_orderDetail};
    [[AFHTTPRequestOperationManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=order&a=createbill"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                _billID = [responseObject objectForKey:@"billid"];
                _billAmount = [responseObject objectForKey:@"amount"];
                _tableView.hidden = NO;
                [_tableView reloadData];
            }
        }else {
            [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"账单生成失败"];
            [self back];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payCell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"订单名称:%@",_orderName];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"订单金额:￥%@", _billAmount];
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"支付方式";
            cell.textLabel.font = [UIFont systemFontOfSize:18.0];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"微信支付";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.imageView.frame = CGRectMake(0, 0, 25, 25);
            cell.imageView.image = [UIImage imageNamed:@"icon-wechat.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"支付宝支付";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.imageView.frame = CGRectMake(0, 0, 25, 25);
            cell.imageView.image = [UIImage imageNamed:@"icon-alipay.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"银行卡支付";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.imageView.frame = CGRectMake(0, 0, 25, 25);
            cell.imageView.image = [UIImage imageNamed:@"icon-unionpay.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return;
        }
        if (_hasSubmitPay) {
            return;
        }
        if (!_billID || !_billAmount) {
            return;
        }
        //调起支付
        DSXPayManager *payManager = [DSXPayManager sharedManager];
        payManager.delegate    = self;
        payManager.orderNO     = [NSString stringWithFormat:@"zw%@",_billID];
        payManager.orderName   = _orderName;
        payManager.orderDetail = _orderDetail;
        payManager.orderAmount = _billAmount;
        //payManager.orderAmount = @"0.01";
        payManager.payID   = _billID;
        payManager.payType = @"payment";
        if (indexPath.row == 1) {
            _hasSubmitPay = YES;
            [payManager WechatPay];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"敬请期待" message:@"暂未开通此支付方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

#pragma mark - payment delegate
- (void)payManager:(DSXPayManager *)manager didFinishedWithCode:(int)errCode{
    if (errCode == 0) {
        NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                                 @"username":[ZWUserStatus sharedStatus].username,
                                 @"orderid":_orderID};
        [[AFHTTPRequestOperationManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=order&a=updatepaystatus"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                /*
                if (![self.navigationController popViewControllerAnimated:YES]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                 */
                MyOrderViewController *myOrderView = [[MyOrderViewController alloc] init];
                [self.navigationController pushViewController:myOrderView animated:YES];
            }else {
                NSLog(@"%@",responseObject);
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }else {
        _hasSubmitPay = NO;
    }
}

@end
