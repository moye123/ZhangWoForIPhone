//
//  MyViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyViewController.h"
#import "MyFavoriteViewController.h"
#import "AboutusViewController.h"
#import "MyOrderViewController.h"
#import "MyWalletViewController.h"
#import "SettingViewController.h"
#import "MyMessageViewController.h"

@implementation MyViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:UserStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeadView) name:UserImageChangedNotification object:nil];
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 30;
    frame.size.height+= 30;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setHeadView];
    
    _orderCatView = [[OrderCatView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 70)];
    _orderCatView.touchDelegate = self;
    
    _loginout = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _loginout.textAlignment = NSTextAlignmentCenter;
    _loginout.font = [UIFont systemFontOfSize:16.0];
}

- (void)setHeadView{
    _headerView = [[MyHeadView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    _tableView.tableHeaderView = _headerView;
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        [_headerView.imageView sd_setImageWithURL:[NSURL URLWithString:[[ZWUserStatus sharedStatus] userpic]]];
        [_headerView.textLabel setText:[[ZWUserStatus sharedStatus] username]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSetting)];
        [_headerView.imageView addGestureRecognizer:tap];
        [_headerView.imageView setUserInteractionEnabled:YES];
        
        _buttonSetting = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-95, 50, 50, 30)];
        [_buttonSetting setTitle:@"设置" forState:UIControlStateNormal];
        [_buttonSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonSetting addTarget:self action:@selector(showSetting) forControlEvents:UIControlEventTouchUpInside];
        [_buttonSetting.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_headerView addSubview:_buttonSetting];
        
        _buttonMessage = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-40, 54, 22, 22)];
        [_buttonMessage setBackgroundImage:[UIImage imageNamed:@"icon-message-30.png"] forState:UIControlStateNormal];
        [_buttonMessage addTarget:self action:@selector(showMessage) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_buttonMessage];
        
    }else{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLogin)];
        UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar.png"]];
        [_headerView setImageView:avatar];
        [_headerView addGestureRecognizer:tap];
        [_headerView setUserInteractionEnabled:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - ordercateview delegate
- (void)orderCatView:(OrderCatView *)catView didSelectedAtItem:(NSDictionary *)data{
   NSInteger tag = [[data objectForKey:@"tag"] intValue];
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        MyOrderViewController *orderView = [[MyOrderViewController alloc] init];
        switch (tag) {
            case 1:
                orderView.shippingStatus = @"1";
                orderView.title = @"待发货";
                break;
            case 2:
                orderView.shippingStatus = @"4";
                orderView.title = @"待使用";
                break;
            case 3:
                orderView.shippingStatus = @"2";
                orderView.title = @"待收货";
                break;
            case 4:
                orderView.evaluateStatus = @"1";
                orderView.title = @"待评价";
                break;
            case 5:
                orderView.orderStatus = @"2";
                orderView.title = @"申请退款";
                break;
            default: orderView.title = @"全部订单";
                break;
        }
        [self.navigationController pushViewController:orderView animated:YES];
    }else {
        [self showLogin];
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 4;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 70;
    }else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的钱包";
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的订单";
            cell.detailTextLabel.text = @"查看全部订单";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        //按钮
        if (indexPath.row == 1) {
            [cell addSubview:_orderCatView];
        }
    }
    
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的收藏";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"关于我们";
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"评分";
        }
        if (indexPath.row == 3) {
            float cacheSize = (float)[[SDImageCache sharedImageCache] getSize]/1048576;
            cell.textLabel.text = @"清除缓存";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB",cacheSize];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    if (indexPath.section == 3) {
        [cell addSubview:_loginout];
        if (indexPath.row == 0) {
            if ([[ZWUserStatus sharedStatus] isLogined]) {
                _loginout.text = @"退出登录";
                _loginout.textColor = [UIColor redColor];
            }else {
                _loginout.text = @"登录";
                _loginout.textColor = [UIColor blackColor];
            }
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[ZWUserStatus sharedStatus] isLogined]) {
                MyWalletViewController *walletView = [[MyWalletViewController alloc] init];
                [self.navigationController pushViewController:walletView animated:YES];
            }else {
                [self showLogin];
            }
        }
    }
    
    if (indexPath.section == 1) {
        //我的订单
        if (indexPath.row == 0) {
            if ([[ZWUserStatus sharedStatus] isLogined]) {
                MyOrderViewController *orderView = [[MyOrderViewController alloc] init];
                orderView.title = @"我的订单";
                [self.navigationController pushViewController:orderView animated:YES];
            }else {
                [self showLogin];
            }
        }
    }
    
    if (indexPath.section == 2) {
        //我的收藏
        if (indexPath.row == 0) {
            if ([[ZWUserStatus sharedStatus] isLogined]) {
                MyFavoriteViewController *favorView = [[MyFavoriteViewController alloc] init];
                [self.navigationController pushViewController:favorView animated:YES];
            }else{
                [self showLogin];
            }
            
        }
        //关于我们
        if (indexPath.row == 1) {
            AboutusViewController *aboutView = [[AboutusViewController alloc] init];
            [self.navigationController pushViewController:aboutView animated:YES];
        }
        
        //打开评分页面
        if (indexPath.row == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apple.com/cn"]];
        }
        
        //清除缓存
        if (indexPath.row == 3) {
            [[SDImageCache sharedImageCache] clearDisk];
            [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"已成功清除缓存"];
            [_tableView reloadData];
        }
    }
    
    if (indexPath.section == 3) {
        if ([[ZWUserStatus sharedStatus] isLogined]) {
            [[ZWUserStatus sharedStatus] logout];
        }
        [self showLogin];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

#pragma mark -
- (void)userStatusChanged{
    [[ZWUserStatus sharedStatus] reloadData];
    [self setHeadView];
    [_tableView reloadData];
}

- (void)showLogin{
    [[ZWUserStatus sharedStatus] showLoginFromViewController:self];
}

- (void)showSetting{
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        SettingViewController *setttingView = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:setttingView animated:YES];
    }else {
        [self showLogin];
    }
}

- (void)showMessage{
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        MyMessageViewController *messageView = [[MyMessageViewController alloc] init];
        [self.navigationController pushViewController:messageView animated:YES];
    }else {
        [self showLogin];
    }
}

@end
