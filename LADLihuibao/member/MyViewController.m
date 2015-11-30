//
//  MyViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyViewController.h"
#import "MyHeadView.h"
#import "MyFavoriteViewController.h"
#import "AboutusViewController.h"
#import "MyOrderViewController.h"
#import "MyWalletViewController.h"
#import "MyProfileViewController.h"

@implementation MyViewController
@synthesize mainTableView;
@synthesize userStatus;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    
    self.userStatus = [[LHBUserStatus alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:UserStatusChangedNotification object:nil];
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 30;
    frame.size.height = frame.size.height + 30;
    self.mainTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    [self setHeadView];
}

- (void)setHeadView{
    MyHeadView *headView = [[MyHeadView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    if (self.userStatus.isLogined) {
        [headView.imageView sd_setImageWithURL:[NSURL URLWithString:self.userStatus.userpic]];
        [headView.textLabel setText:self.userStatus.username];
        
        _buttonSetting = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-95, 50, 50, 30)];
        [_buttonSetting setTitle:@"设置" forState:UIControlStateNormal];
        [_buttonSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonSetting addTarget:self action:@selector(showProfile) forControlEvents:UIControlEventTouchUpInside];
        [_buttonSetting.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [headView addSubview:_buttonSetting];
        
        _buttonMessage = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-40, 54, 22, 22)];
        [_buttonMessage setBackgroundImage:[UIImage imageNamed:@"icon-message-30.png"] forState:UIControlStateNormal];
        [headView addSubview:_buttonMessage];
        
    }else{
        [headView.imageView setImage:[UIImage imageNamed:@"avatar.png"]];
        [headView.textLabel setText:@"点此登录"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLogin)];
        [headView addGestureRecognizer:tap];
        [headView setUserInteractionEnabled:YES];
    }
    self.mainTableView.tableHeaderView = headView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (UIButton *)buttonWithTitle:(NSString *)title image:(NSString *)imageName{
    CGFloat width = SWIDTH / 5;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, -1, width, 72)];
    button.layer.borderWidth = 0.6;
    button.layer.borderColor = [UIColor colorWithHexString:@"0xd5d5d5"].CGColor;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width-20)/2, 10, 22, 22)];
    imageView.image = [UIImage imageNamed:imageName];
    [button addSubview:imageView];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, width, 20)];
    textLabel.text = title;
    textLabel.font = [UIFont systemFontOfSize:14.0];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [button addSubview:textLabel];
    return button;
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的钱包";
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *totalIncomeLabel = [[UILabel alloc] init];
            totalIncomeLabel.text = @"0.00元";
            totalIncomeLabel.textColor = [UIColor grayColor];
            totalIncomeLabel.font = [UIFont systemFontOfSize:14.0];
            [totalIncomeLabel sizeToFit];
            cell.accessoryView = totalIncomeLabel;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的订单";
            
            UILabel *tipLabel = [[UILabel alloc] init];
            tipLabel.text = @"查看全部订单";
            tipLabel.textColor = [UIColor grayColor];
            tipLabel.font = [UIFont systemFontOfSize:16.0];
            [tipLabel sizeToFit];
            cell.accessoryView = tipLabel;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        //按钮
        if (indexPath.row == 1) {
            for (UIView *subview in cell.subviews) {
                [subview removeFromSuperview];
            }
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 70)];
            contentView.layer.masksToBounds = YES;
            
            CGFloat width = SWIDTH / 5;
            cell.contentView.layer.masksToBounds = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *buttonPay = [self buttonWithTitle:@"待付款" image:@"icon-wating-pay.png"];
            buttonPay.tag = 101;
            buttonPay.frame = CGRectMake(-1, -1, width+1, 72);
            [buttonPay addTarget:self action:@selector(showOrder:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:buttonPay];
            
            UIButton *buttonUse = [self buttonWithTitle:@"待使用" image:@"icon-wating-use.png"];
            buttonUse.tag = 102;
            buttonUse.frame = CGRectMake(width-1, -1, width+1, 72);
            [buttonUse addTarget:self action:@selector(showOrder:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:buttonUse];
            
            UIButton *buttonReceipt = [self buttonWithTitle:@"待收货" image:@"icon-wating-receipt.png"];
            buttonReceipt.tag = 103;
            buttonReceipt.frame = CGRectMake(width*2-1, -1, width+1, 72);
            [buttonReceipt addTarget:self action:@selector(showOrder:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:buttonReceipt];
            
            UIButton *buttonComment = [self buttonWithTitle:@"待评价" image:@"icon-wating-comment.png"];
            buttonComment.tag = 104;
            buttonComment.frame = CGRectMake(width*3-1, -1, width+1, 72);
            [buttonComment addTarget:self action:@selector(showOrder:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:buttonComment];
            
            UIButton *buttonReturn = [self buttonWithTitle:@"退货" image:@"icon-wating-return.png"];
            buttonReturn.tag = 105;
            buttonReturn.frame = CGRectMake(width*4-1, -1, width+1, 72);
            [buttonReturn addTarget:self action:@selector(showOrder:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:buttonReturn];
            [cell addSubview:contentView];
        }
    }
    
    if (indexPath.section == 2) {
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
            cell.textLabel.text = @"清除缓存";
            float cacheSize = (float)[[SDImageCache sharedImageCache] getSize]/1048576;
            UILabel *cacheSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
            cacheSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",cacheSize];
            cacheSizeLabel.textColor = [UIColor grayColor];
            cacheSizeLabel.font = [UIFont systemFontOfSize:14.0];
            [cacheSizeLabel sizeToFit];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = cacheSizeLabel;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            if (self.userStatus.isLogined) {
                cell.textLabel.text = @"退出登录";
                cell.textLabel.textColor = [UIColor redColor];
            }else {
                cell.textLabel.text = @"登录";
                cell.textLabel.textColor = [UIColor blackColor];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.userStatus.isLogined) {
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
            if (self.userStatus.isLogined) {
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
            if (self.userStatus.isLogined) {
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
            [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"已成功清除缓存"];
            [self.mainTableView reloadData];
        }
    }
    
    if (indexPath.section == 3) {
        if (self.userStatus.isLogined) {
            [self.userStatus logout];
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
    self.userStatus = [LHBUserStatus status];
    [self setHeadView];
    [self.mainTableView reloadData];
}

- (void)showLogin{
    [[DSXUI sharedUI] showLoginFromViewController:self];
}

- (void)showOrder:(UIButton *)sender{
    if (self.userStatus.isLogined) {
        MyOrderViewController *orderView = [[MyOrderViewController alloc] init];
        switch (sender.tag) {
            case 101:
                orderView.status = 1;
                orderView.title = @"待发货";
                break;
            case 102:
                orderView.status = 4;
                orderView.title = @"待使用";
                break;
            case 103:
                orderView.status = 2;
                orderView.title = @"待收货";
                break;
            case 104:
                orderView.evaluate = 0;
                orderView.title = @"待评价";
                break;
            case 105:
                orderView.status = 6;
                orderView.title = @"申请退款";
                break;
            default: orderView.title = @"我的订单";
                break;
        }
        [self.navigationController pushViewController:orderView animated:YES];
    }else {
        [self showLogin];
    }
    
}

- (void)showProfile{
    MyProfileViewController *profileView = [[MyProfileViewController alloc] init];
    [self.navigationController pushViewController:profileView animated:YES];
}

@end
