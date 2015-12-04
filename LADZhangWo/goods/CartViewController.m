//
//  CartViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CartViewController.h"

@implementation CartViewController
@synthesize cartList = _cartList;
@synthesize tableView = _tableView;
@synthesize userStatus = _userStatus;

- (void)viewDidLoad{
    [super viewDidLoad];

    _cartList = [NSMutableArray array];
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _userStatus = [ZWUserStatus status];
    
    CGRect frame = self.view.bounds;
    frame.size.height = frame.size.height - 60;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _pullUpView = [[ZWPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    _tableView.tableFooterView = _pullUpView;
    [self refresh];
}

- (void)refresh{
    _page = 1;
    _isRefreshing = YES;
    [self loadData];
}

- (void)loadMore{
    _page++;
    [self loadData];
}

- (void)loadData{
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=cart&ac=showlist&uid=%ld&page=%d",(long)_userStatus.uid,_page] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            [self reloadTableViewWithArray:array];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            [_cartList removeAllObjects];
            [_tableView reloadData];
        }
        
        for (id item in array) {
            [_cartList addObject:item];
        }
        [_tableView reloadData];
    }
    if ([array count] < 20) {
        _pullUpView.hidden = YES;
    }else{
        _pullUpView.hidden = NO;
    }
    [_pullUpView endLoading];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_cartList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 45;
    }else {
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *cart = [_cartList objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x555555"];
        if ([[cart objectForKey:@"shopname"] isEqualToString:@""]) {
            cell.textLabel.text = @"店铺名称";
        }else {
            
            cell.textLabel.text = [cart objectForKey:@"shopname"];
        }
    }
    
    if (indexPath.row == 1) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[cart objectForKey:@"goods_pic"]]];
        [cell addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 160, 40)];
        nameLabel.text = [cart objectForKey:@"goods_name"];
        nameLabel.numberOfLines = 2;
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        [nameLabel sizeToFit];
        [cell addSubview:nameLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 100, 20)];
        priceLabel.text = [cart objectForKey:@"goods_price"];
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = [UIFont systemFontOfSize:14.0];
        [cell addSubview:priceLabel];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, 100, 20)];
        numLabel.text = [NSString stringWithFormat:@"X%@",[cart objectForKey:@"buynum"]];
        numLabel.font = [UIFont systemFontOfSize:14.0];
        [cell addSubview:numLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(260, 20, 0.8, 60)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"0xE3E3E5"];
        [cell addSubview:lineView];
        
        UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 35, 20, 20)];
        [editButton setBackgroundImage:[UIImage imageNamed:@"icon-edit-cart.png"] forState:UIControlStateNormal];
        [cell addSubview:editButton];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return YES;
    }else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cart = [_cartList objectAtIndex:indexPath.section];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=cart&ac=delete&cartid=%@&uid=%ld",[cart objectForKey:@"cartid"],(long)_userStatus.uid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            //NSLog(@"%@",returns);
            if ([returns isKindOfClass:[NSDictionary class]]) {
                if ([[returns objectForKey:@"affects"] integerValue] > 0) {
                    [_cartList removeObjectAtIndex:indexPath.section];
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat diffHeight = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
    if (diffHeight > 50) {
        if (_pullUpView.hidden == NO) {
            [_pullUpView beginLoading];
            [self loadMore];
        }
    }
    
    if (scrollView.contentOffset.y < 120) {
        [self refresh];
    }
}

@end
