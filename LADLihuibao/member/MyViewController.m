//
//  MyViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyViewController.h"
#import "MyHeadView.h"

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

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 6;
    }else if (section == 2){
        return 3;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的收益";
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *totalIncomeLabel = [[UILabel alloc] init];
            totalIncomeLabel.text = @"0.00元";
            totalIncomeLabel.textColor = [UIColor grayColor];
            totalIncomeLabel.font = [UIFont systemFontOfSize:14.0];
            [totalIncomeLabel sizeToFit];
            cell.accessoryView = totalIncomeLabel;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的订单";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"我的优惠券";
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"我的收藏";
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"待评论";
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = @"我的评论";
        }
        
        if (indexPath.row == 5) {
            cell.textLabel.text = @"每日推荐";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关于";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"评分";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (indexPath.row == 2) {
            float cacheSize = [[SDImageCache sharedImageCache] getSize]/1048576;
            UILabel *cacheSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
            cacheSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",cacheSize];
            cacheSizeLabel.textColor = [UIColor grayColor];
            cacheSizeLabel.font = [UIFont systemFontOfSize:14.0];
            [cacheSizeLabel sizeToFit];
            cell.textLabel.text = @"清除缓存";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = cacheSizeLabel;
        }
        
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
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
        }
        if (indexPath.row == 1) {
            
        }
        if (indexPath.row == 2) {
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

#pragma mark -
- (void)userStatusChanged{
    self.userStatus = [LHBUserStatus status];
    [self setHeadView];
    [self.mainTableView reloadData];
}

- (void)showLogin{
    [[DSXUI sharedUI] showLoginFromViewController:self];
}

@end
