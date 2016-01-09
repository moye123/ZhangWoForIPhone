//
//  OrderDetailViewController.m
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "ShopDetailViewController.h"

@implementation OrderDetailViewController
@synthesize tableView = _tableView;
@synthesize orderid   = _orderid;
@synthesize orderData = _orderData;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"订单详情"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    CGRect frame = self.view.bounds;
    frame.size.height-= 60;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"titleCell"];
    [_tableView registerClass:[OrderItemCell class] forCellReuseIdentifier:@"goodsCell"];
    
    //下载订单数据
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=order&a=showdetail&uid=%ld&orderid=%ld",(long)[ZWUserStatus sharedStatus].uid,(long)_orderid];
    [[AFHTTPRequestOperationManager sharedManager] GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _orderData = responseObject;
            _tableView.hidden = NO;
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [[_orderData objectForKey:@"data"] count] + 1;
    }else {
        return 7;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 45;
        }else {
            return 100;
        }
    }else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSArray *goodsArray = [_orderData objectForKey:@"data"];
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            cell.textLabel.text = [_orderData objectForKey:@"shopname"];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            NSDictionary *goodsData = [goodsArray objectAtIndex:(indexPath.row-1)];
            OrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
            cell.goodsData = goodsData;
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            cell.textLabel.text = @"订单详情";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(1, 0, -1, 0);
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"0x888888"];
            cell.layer.masksToBounds = YES;
            if (indexPath.row == 1) {
                cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@",[_orderData objectForKey:@"orderno"]];
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = [NSString stringWithFormat:@"订单金额: ￥%.2f",[[_orderData objectForKey:@"amount"] floatValue]];
            }
            if (indexPath.row == 3) {
                cell.textLabel.text = [NSString stringWithFormat:@"交易时间: %@",[_orderData objectForKey:@"dateline"]];
            }
            if (indexPath.row == 4) {
                cell.textLabel.text = [NSString stringWithFormat:@"收货人姓名: %@",[_orderData objectForKey:@"consignee"]];
            }
            if (indexPath.row == 5) {
                cell.textLabel.text = [NSString stringWithFormat:@"联系电话: %@",[_orderData objectForKey:@"tel"]];
            }
            if (indexPath.row == 6) {
                cell.textLabel.text = [NSString stringWithFormat:@"收货地址: %@",[_orderData objectForKey:@"address"]];
            }
            return cell;
        }
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
            shopView.shopid = [[_orderData objectForKey:@"shopid"] integerValue];
            [self.navigationController pushViewController:shopView animated:YES];
        }else {
            NSArray *goodsArray = [_orderData objectForKey:@"data"];
            NSDictionary *goodsData = [goodsArray objectAtIndex:(indexPath.row-1)];
            GoodsDetailViewController *goodsView = [[GoodsDetailViewController alloc] init];
            goodsView.goodsid = [[goodsData objectForKey:@"id"] integerValue];
            goodsView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsView animated:YES];
        }
    }
}

@end
