//
//  MyAddressViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyAddressViewController.h"
#import "AddAddressViewController.h"

@implementation MyAddressViewController
@synthesize addressList = _addressList;
@synthesize tableView   = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"管理收货地址"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnew)];
    self.navigationItem.rightBarButtonItem = rightButton;

    _addressList = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.hidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *loadingView = [[DSXUI standardUI] showLoadingViewWithMessage:@"正在加载.."];
    NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),@"username":[ZWUserStatus sharedStatus].username};
    [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=address&a=showlist"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [loadingView removeFromSuperview];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _addressList = [NSMutableArray arrayWithArray:responseObject];
            [_tableView reloadData];
            [_tableView setHidden:NO];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [loadingView removeFromSuperview];
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addnew{
    AddAddressViewController *addView = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:addView animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_addressList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSDictionary *address = [_addressList objectAtIndex:indexPath.row];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 30)];
    titleLabel.text = [address objectForKey:@"name"];
    titleLabel.font = [UIFont fontWithName:DSXFontStyleMedinum size:18.0];
    [titleLabel sizeToFit];
    [cell addSubview:titleLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, SWIDTH-20, 20)];
    phoneLabel.text = [address objectForKey:@"phone"];
    phoneLabel.font = [UIFont fontWithName:DSXFontStyleDemilight size:16.0];
    [cell addSubview:phoneLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, SWIDTH-20, 40)];
    addressLabel.text = [NSString stringWithFormat:@"地址:%@%@",[address objectForKey:@"district"],[address objectForKey:@"address"]];
    addressLabel.font = [UIFont systemFontOfSize:14.0];
    addressLabel.numberOfLines = 2;
    [cell addSubview:addressLabel];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger addressid = [[[_addressList objectAtIndex:indexPath.row] objectForKey:@"addressid"] integerValue];
        NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                                 @"username":[ZWUserStatus sharedStatus].username,
                                 @"addressid":@(addressid)};
        [[AFHTTPSessionManager sharedManager] GET:[SITEAPI stringByAppendingString:@"&c=address&a=delete"] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"addressid"] integerValue] == addressid) {
                    [_addressList removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
}

@end
