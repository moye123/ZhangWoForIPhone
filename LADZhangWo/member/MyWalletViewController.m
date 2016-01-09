//
//  MyWalletViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyBillViewController.h"
#import "MyIncomeViewController.h"
#import "RechargeViewController.h"

@implementation MyWalletViewController
@synthesize walletData = _walletData;

- (instancetype)init{
    if (self = [super init]) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 120)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"0xDB7E7D"];
        self.tableView.tableHeaderView = _headerView;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        textLabel.text = @"账户总余额";
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont systemFontOfSize:15.0];
        [_headerView addSubview:textLabel];
        
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalLabel.text = @"￥0.00";
        _totalLabel.font = [UIFont boldSystemFontOfSize:24.0];
        _totalLabel.textColor = [UIColor whiteColor];
        [_totalLabel sizeToFit];
        [_totalLabel setCenter:_headerView.center];
        [_headerView addSubview:_totalLabel];
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 100)];
        self.tableView.tableFooterView = _footerView;
        
        UIButton *rechageButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 50, SWIDTH-30, 40)];
        rechageButton.backgroundColor = [UIColor whiteColor];
        rechageButton.layer.cornerRadius = 20.0;
        rechageButton.layer.masksToBounds = YES;
        [rechageButton setTitle:@"账户充值" forState:UIControlStateNormal];
        [rechageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rechageButton setBackgroundImage:[UIImage imageNamed:@"button-selected.png"] forState:UIControlStateHighlighted];
        [rechageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [rechageButton addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:rechageButton];
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的钱包"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStylePlain target:self action:@selector(showBill)];
    [rightBarButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
    [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
    [[AFHTTPRequestOperationManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=wallet&a=showdetail"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _walletData = responseObject;
            _totalLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_walletData objectForKey:@"balance"] floatValue]];
            [self.tableView reloadData];
        }else {
            [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"数据加载失败"];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(back) userInfo:nil repeats:NO];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showBill{
    MyBillViewController *billView = [[MyBillViewController alloc] init];
    [self.navigationController pushViewController:billView animated:YES];
}

- (void)recharge{
    RechargeViewController *rechargeView = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeView animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"walletCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的收益";
        if (_walletData) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_walletData objectForKey:@"total_income"] floatValue]];
        }else {
            cell.detailTextLabel.text = @"￥0.00";
        }
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"0x3DC0AD"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (indexPath.row == 0) {
        MyIncomeViewController *incomeView = [[MyIncomeViewController alloc] init];
        [self.navigationController pushViewController:incomeView animated:YES];
    }
}

@end
