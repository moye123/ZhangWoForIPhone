//
//  MyOrderViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyOrderViewController.h"

@implementation MyOrderViewController
@synthesize status;
@synthesize orderList = _orderList;
@synthesize userStatus;
@synthesize tableView = _tableView;

- (instancetype)init{
    self = [super init];
    if (self) {
        _afmanager = [AFHTTPRequestOperationManager manager];
        _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.userStatus = [LHBUserStatus status];
        _orderList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的订单"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    UILabel *refreshView = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, SWIDTH, 50)];
    refreshView.text = @"松开手开始刷新";
    refreshView.font = [UIFont systemFontOfSize:14.0];
    refreshView.textColor = [UIColor grayColor];
    //refreshView.hidden = YES;
    [self.view addSubview:refreshView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //_refreshControl = [[LHBRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    //self.refreshControl = _refreshControl;
    
    
    _pullUpView = [[LHBPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    self.tableView.tableFooterView = _pullUpView;
    [self refresh];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=order&ac=showlist&page=%d",_page] parameters:@{@"uid":@(self.userStatus.uid),@"username":self.userStatus.username} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            
            [self reloadTableViewWithArray:array];
        }else {
            NSLog(@"订单获取失败");
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    
    if ([array count] > 0) {
        if (_isRefreshing) {
            _isRefreshing = NO;
            [_orderList removeAllObjects];
            [self.tableView reloadData];
        }
        for (NSDictionary *order in array) {
            [_orderList addObject:order];
        }
        [self.tableView reloadData];
    }
    
    if ([array count] < 20) {
        _pullUpView.hidden = YES;
    }else {
        _pullUpView.hidden = NO;
    }
    [_pullUpView endLoading];
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
}

- (void)refresh{
    _page = 1;
    _isRefreshing = YES;
    [self loadData];
}

- (void)loadMore{
    _page++;
    _isRefreshing = NO;
    [self loadData];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_orderList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 100.0;
    }else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
    }else {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
     */
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *order = [_orderList objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        cell.textLabel.text = [order objectForKey:@"goods_sn"];
        //cell.textLabel.text = @"店铺名称";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        statusLabel.text = @"交易成功";
        statusLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        statusLabel.font = [UIFont systemFontOfSize:15.0];
        [statusLabel sizeToFit];
        cell.accessoryView = statusLabel;
    }
    
    if (indexPath.row == 1) {
        cell.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [imageView sd_setImageWithURL:[order objectForKey:@"goods_pic"]];
        [cell.contentView addSubview:imageView];
        
        UILabel *titalLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, SWIDTH-110, 40)];
        titalLabel.text = [order objectForKey:@"goods_name"];
        titalLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
        titalLabel.font = [UIFont systemFontOfSize:16.0];
        [cell.contentView addSubview:titalLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, SWIDTH-110, 20)];
        priceLabel.text = [NSString stringWithFormat:@"￥%@",[order objectForKey:@"goods_price"]];
        priceLabel.textColor = [UIColor colorWithHexString:@"0x3DC0AD"];
        priceLabel.font = [UIFont systemFontOfSize:16.0];
        [cell.contentView addSubview:priceLabel];
        
        UILabel *buyNum = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH-40, 70, 30, 20)];
        buyNum.text = [NSString stringWithFormat:@"x%@",[order objectForKey:@"buynum"]];
        buyNum.textColor = [UIColor blackColor];
        buyNum.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:buyNum];
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"时间:%@",[order objectForKey:@"ordertime"]];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        UILabel *orderTotal = [[UILabel alloc] initWithFrame:CGRectZero];
        orderTotal.text = [NSString stringWithFormat:@"总计:%.2f",[[order objectForKey:@"total"] floatValue]];
        orderTotal.font = [UIFont systemFontOfSize:16.0];
        [orderTotal sizeToFit];
        cell.accessoryView = orderTotal;
    }
    if (indexPath.row == 3) {
        UIButton *cancelButton = [self buttonWithTitle:@"取消订单"];
        [cancelButton setFrame:CGRectMake(SWIDTH-150, 10, 80, 30)];
        [cell.contentView addSubview:cancelButton];
        
        UIButton *payButton = [self buttonWithTitle:@"付款"];
        [payButton setFrame:CGRectMake(SWIDTH-60, 10, 50, 30)];
        [cell.contentView addSubview:payButton];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - button
- (UIButton *)buttonWithTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 15.0;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"button-buy-selected.png"] forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor whiteColor]];
    return button;
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