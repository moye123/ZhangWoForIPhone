//
//  SafeViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SafeViewController.h"
#import "ModiEmailViewController.h"
#import "ModiPassViewController.h"
#import "ModiMobileViewController.h"

@implementation SafeViewController
@synthesize userStatus = _userStatus;
@synthesize tableView = _tableView;

- (instancetype)init{
    self = [super init];
    if (self) {
        _userStatus = [ZWUserStatus sharedStatus];
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"账户安全"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"用户名";
            UILabel *usernameLabel = [[UILabel alloc] init];
            usernameLabel.text = _userStatus.username;
            usernameLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
            [usernameLabel sizeToFit];
            cell.accessoryView = usernameLabel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"修改手机号";
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"修改邮箱";
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"修改密码";
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            ModiMobileViewController *modiMobileView = [[ModiMobileViewController alloc] init];
            [self.navigationController pushViewController:modiMobileView animated:YES];
        }
        if (indexPath.row == 2) {
            ModiEmailViewController *modiEmailView = [[ModiEmailViewController alloc] init];
            [self.navigationController pushViewController:modiEmailView animated:YES];
        }
        
        if (indexPath.row == 3) {
            ModiPassViewController *modiPassView = [[ModiPassViewController alloc] init];
            [self.navigationController pushViewController:modiPassView animated:YES];
        }
    }
}

@end
