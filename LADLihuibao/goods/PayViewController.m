//
//  PayViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PayViewController.h"

@implementation PayViewController
@synthesize orderid;
@synthesize orderno;
@synthesize orderTitle;
@synthesize total;
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"付款"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
            cell.textLabel.text = [NSString stringWithFormat:@"订单名称:%@",self.orderTitle];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"订单金额:￥%.2f", self.total];
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
            cell.textLabel.text = @"支付宝支付";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.imageView.frame = CGRectMake(0, 0, 25, 25);
            cell.imageView.image = [UIImage imageNamed:@"icon-alipay.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"银行卡支付";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.imageView.frame = CGRectMake(0, 0, 25, 25);
            cell.imageView.image = [UIImage imageNamed:@"icon-unionpay.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"微信支付";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.imageView.frame = CGRectMake(0, 0, 25, 25);
            cell.imageView.image = [UIImage imageNamed:@"icon-wechat.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

@end
