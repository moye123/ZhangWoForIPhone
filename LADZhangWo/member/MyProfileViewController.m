//
//  MyProfileViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyAddressViewController.h"

@implementation MyProfileViewController
@synthesize tableView = _tableView;
@synthesize userStatus = _userStatus;
@synthesize profile = _profile;

- (instancetype)init{
    self = [super init];
    if (self) {
        _userStatus = [ZWUserStatus status];
        _afmanager = [[AFHTTPRequestOperationManager alloc] init];
        _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        [self.view addSubview:_tableView];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"个人资料"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    UIView *loadingView = [[DSXUI sharedUI] showLoadingViewWithMessage:@"正在加载.."];
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=profile&ac=showdetail&uid=%ld",(long)_userStatus.uid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([returns isKindOfClass:[NSDictionary class]]) {
            _profile = [NSMutableDictionary dictionaryWithDictionary:returns];
            _tableView.hidden = NO;
            [_tableView reloadData];
            [loadingView removeFromSuperview];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"profileCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"用户名";
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = _userStatus.username;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (indexPath.row == 1) {
            _userStatus.imageView.frame = CGRectMake(0, -5, 30, 30);
            _userStatus.imageView.layer.cornerRadius = 15.0;
            _userStatus.imageView.layer.masksToBounds = YES;
            cell.textLabel.text = @"头像";
            cell.detailTextLabel.text = @"       ";
            [cell.detailTextLabel addSubview:_userStatus.imageView];
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"生日";
            cell.detailTextLabel.text = [_profile objectForKey:@"birthday"];
            cell.detailTextLabel.tag = 101;
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"性别";
            if ([[_profile objectForKey:@"usersex"] integerValue] == 1) {
                cell.detailTextLabel.text = @"男";
            }else {
                cell.detailTextLabel.text = @"女";
            }
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = @"收货地址管理";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
            [actionSheet addButtonWithTitle:@"本地相册"];
            [actionSheet addButtonWithTitle:@"拍照"];
            [actionSheet addButtonWithTitle:@"取消"];
            [actionSheet setCancelButtonIndex:2];
            [actionSheet setDelegate:self];
            [actionSheet setTag:101];
            [actionSheet showInView:self.view];
        }
        
        if (indexPath.row == 2) {
            _datePickerView = [[DSXModalView alloc] init];
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
            _datePicker.datePickerMode = UIDatePickerModeDate;
            [_datePickerView.contentView addSubview:_datePicker];
            
            UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [doneButton setTitle:@"确定" forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [doneButton setFrame:CGRectMake(SWIDTH-50, 10, 40, 30)];
            [doneButton addTarget:self action:@selector(setBirthDay) forControlEvents:UIControlEventTouchUpInside];
            [_datePickerView.contentView addSubview:doneButton];
            [_datePickerView show];
        }
        
        if (indexPath.row == 3) {
            UIActionSheet *sexSheet = [[UIActionSheet alloc] init];
            [sexSheet addButtonWithTitle:@"男"];
            [sexSheet addButtonWithTitle:@"女"];
            [sexSheet addButtonWithTitle:@"取消"];
            [sexSheet setCancelButtonIndex:2];
            [sexSheet showInView:self.view];
            [sexSheet setTag:102];
            [sexSheet setDelegate:self];
        }
        
        if (indexPath.row == 4) {
            MyAddressViewController *addressView = [[MyAddressViewController alloc] init];
            [self.navigationController pushViewController:addressView animated:YES];
        }
    }
}

- (void)setBirthDay{
    NSDate *date = [_datePicker date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(_userStatus.uid) forKey:@"uid"];
    [params setObject:_userStatus.username forKey:@"username"];
    [params setObject:[formater stringFromDate:date] forKey:@"profilenew[birthday]"];
    [_afmanager POST:[SITEAPI stringByAppendingString:@"&mod=profile&ac=update"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //[[DSXUtil sharedUtil] nslogStringWithData:responseObject];
        id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([returns isKindOfClass:[NSDictionary class]]) {
            if ([[returns objectForKey:@"uid"] integerValue] == _userStatus.uid) {
                //[[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDone Message:@"修改成功"];
                [_profile setObject:[formater stringFromDate:date] forKey:@"birthday"];
                [_datePickerView hide];
                [_tableView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)setSex:(NSInteger)sex{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(_userStatus.uid) forKey:@"uid"];
    [params setObject:_userStatus.username forKey:@"username"];
    [params setObject:@(sex) forKey:@"profilenew[usersex]"];
    [_afmanager POST:[SITEAPI stringByAppendingString:@"&mod=profile&ac=update"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([returns isKindOfClass:[NSDictionary class]]) {
            if ([[returns objectForKey:@"uid"] integerValue] == _userStatus.uid) {
                [_profile setObject:@(sex) forKey:@"usersex"];
                [_tableView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 102) {
        if (buttonIndex == 0) {
            [self setSex:1];
        }
        if (buttonIndex == 1) {
            [self setSex:0];
        }
    }
}

@end
