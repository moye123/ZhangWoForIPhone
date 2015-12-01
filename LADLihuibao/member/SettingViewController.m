//
//  SettingViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SettingViewController.h"
#import "MyProfileViewController.h"
#import "SafeViewController.h"
#import "FeedbackViewController.h"

@implementation SettingViewController
@synthesize tableView = _tableView;
@synthesize userStatus = _userStatus;

- (instancetype)init{
    self = [super init];
    if (self) {
        _userStatus = [LHBUserStatus status];
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"个人设置"];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"修改资料";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"账号安全";
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"意见反馈";
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"使用帮助";
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MyProfileViewController *profileView = [[MyProfileViewController alloc] init];
            [self.navigationController pushViewController:profileView animated:YES];
        }
        
        if (indexPath.row == 1) {
            SafeViewController *safeView = [[SafeViewController alloc] init];
            [self.navigationController pushViewController:safeView animated:YES];
        }
        
        if (indexPath.row == 2) {
            FeedbackViewController *feedbackView = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackView animated:YES];
        }
    }
}

@end
