//
//  MyOrderViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyOrderViewController.h"
#import "GoodsDetailViewController.h"
#import "PayViewController.h"

@implementation MyOrderViewController
@synthesize status = _status;
@synthesize orderList = _orderList;
@synthesize userStatus = _userStatus;
@synthesize tableView = _tableView;

- (instancetype)init{
    self = [super init];
    if (self) {
        _afmanager = [AFHTTPRequestOperationManager manager];
        _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.userStatus = [ZWUserStatus sharedStatus];
        _orderList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    UILabel *refreshView = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, SWIDTH, 50)];
    refreshView.text = @"松开手开始刷新";
    refreshView.font = [UIFont systemFontOfSize:14.0];
    refreshView.textColor = [UIColor grayColor];
    //refreshView.hidden = YES;
    [self.view addSubview:refreshView];
    
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height = tableFrame.size.height - 50;
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //_refreshControl = [[LHBRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    //self.refreshControl = _refreshControl;
    
    
    _pullUpView = [[ZWPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    self.tableView.tableFooterView = _pullUpView;
    [self refresh];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//从服务器加载数据
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(_userStatus.uid) forKey:@"uid"];
    [params setObject:_userStatus.username forKey:@"username"];
    if (_status) {
        [params setObject:@(_status) forKey:@"status"];
    }
    
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=order&ac=showlist&page=%d",_page] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            [self reloadTableViewWithArray:array];
        }else {
            NSLog(@"订单获取失败");
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//刷新表视图
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

//刷新
- (void)refresh{
    _page = 1;
    _isRefreshing = YES;
    [self loadData];
}

//加载更多
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"orderCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *order = [_orderList objectAtIndex:indexPath.section];
    NSInteger orderStatus = [[order objectForKey:@"status"] integerValue];
    if (indexPath.row == 0) {
        if ([[order objectForKey:@"shopname"] length] > 0) {
            cell.textLabel.text = [order objectForKey:@"shopname"];
        }else {
            cell.textLabel.text = @"店铺名称";
        }
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.textColor = [UIColor redColor];
        switch (orderStatus) {
            case 0:
                cell.detailTextLabel.text = @"交易成功";
                break;
            case 1:
                cell.detailTextLabel.text = @"等待买家付款";
                break;
            case 2:
                cell.detailTextLabel.text = @"等待卖家发货";
                break;
            case 3:
                cell.detailTextLabel.text = @"卖家已发货";
                break;
            case 4:
                cell.detailTextLabel.text = @"等待买家收货";
                break;
            case 5:
                cell.detailTextLabel.text = @"等待买家确认";
                break;
            case 6:
                cell.detailTextLabel.text = @"退款进行中";
                break;
            case 7:
                cell.detailTextLabel.text = @"等待卖家退款";
                break;
            case 8:
                cell.detailTextLabel.text = @"退款成功";
                break;
            default:
                break;
        }
    }
    
    if (indexPath.row == 1) {
        cell.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        cell.selectionStyle  = UITableViewCellSelectionStyleGray;
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
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"总计:%.2f",[[order objectForKey:@"total"] floatValue]];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    }
    if (indexPath.row == 3) {
        if (orderStatus == 0) {
            UIButton *evalButton = [self buttonWithTitle:@"评价"];
            evalButton.tag = [[order objectForKey:@"orderid"] integerValue];
            [evalButton setFrame:CGRectMake(SWIDTH-70, 10, 60, 30)];
            [evalButton addTarget:self action:@selector(evaluationOrder:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:evalButton];
            
            UIButton *refundButton = [self buttonWithTitle:@"申请退货"];
            refundButton.tag = indexPath.section + 1000;
            [refundButton setFrame:CGRectMake(SWIDTH-160, 10, 80, 30)];
            [cell addSubview:refundButton];
            
        }else if (orderStatus == 1){
            UIButton *cancelButton = [self buttonWithTitle:@"取消订单"];
            cancelButton.tag = indexPath.section+100;
            [cancelButton setFrame:CGRectMake(SWIDTH-160, 10, 80, 30)];
            [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:cancelButton];
            
            UIButton *payButton = [self buttonWithTitle:@"付款"];
            payButton.tag = [[order objectForKey:@"orderid"] integerValue];
            [payButton setFrame:CGRectMake(SWIDTH-70, 10, 60, 30)];
            [payButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:payButton];
        }else {
            UIButton *doneButton = [self buttonWithTitle:@"确认收货"];
            doneButton.tag = [[order objectForKey:@"orderid"] integerValue];
            [doneButton setFrame:CGRectMake(SWIDTH-90, 10, 80, 30)];
            [cell addSubview:doneButton];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if (indexPath.row == 1) {
        NSInteger goodsid = [[[_orderList objectAtIndex:indexPath.section] objectForKey:@"goods_id"] integerValue];
        GoodsDetailViewController *detailView = [[GoodsDetailViewController alloc] init];
        detailView.goodsid = goodsid;
        detailView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailView animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)cancelOrder:(UIButton *)button{
    NSInteger section = button.tag - 100;
    NSInteger orderid = [[_orderList[section] objectForKey:@"orderid"] integerValue];
    [_afmanager POST:[SITEAPI stringByAppendingString:@"&mod=order&ac=delete"] parameters:@{@"uid":@(_userStatus.uid),@"username":_userStatus.username,@"orderid":@(orderid)} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([returns isKindOfClass:[NSDictionary class]]) {
            [_orderList removeObjectAtIndex:section];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)pay:(UIButton *)button{
    NSInteger orderid = button.tag;
    PayViewController *payView = [[PayViewController alloc] init];
    payView.orderid = orderid;
    [self.navigationController pushViewController:payView animated:YES];
}

- (void)evaluationOrder:(UIButton *)button{
    
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
    [button setBackgroundImage:[UIImage imageNamed:@"button-selected.png"] forState:UIControlStateHighlighted];
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
