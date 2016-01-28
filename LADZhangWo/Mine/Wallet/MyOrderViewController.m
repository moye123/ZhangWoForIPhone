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
#import "MyFavoriteViewController.h"
#import "MyMessageViewController.h"
#import "OrderDetailViewController.h"

@implementation MyOrderViewController
@synthesize orderList      = _orderList;
@synthesize tableView      = _tableView;
@synthesize orderStatus    = _orderStatus;
@synthesize payStatus      = _payStatus;
@synthesize shippingStatus = _shippingStatus;
@synthesize evaluateStatus = _evaluateStatus;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    if (!self.title) {
        self.title = @"我的订单";
    }
    
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    _orderList = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [_tableView registerClass:[OrderItemCell class] forCellReuseIdentifier:@"orderGoodsCell"];
    [_tableView registerClass:[OrderCommonCell class] forCellReuseIdentifier:@"Cell1"];
    [_tableView registerClass:[OrderCommonCell class] forCellReuseIdentifier:@"Cell2"];
    [_tableView registerClass:[OrderCommonCell class] forCellReuseIdentifier:@"Cell3"];
    [self.view addSubview:self.tableView];
    
    _refreshControl = [[DSXRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.refreshControl = _refreshControl;
    tableViewController.tableView = _tableView;
    
    _pullUpView = [[DSXPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    _tableView.tableFooterView = _pullUpView;
    [self refresh];
    
    _tipsView = [[UILabel alloc] init];
    _tipsView.text = @"订单空空也";
    _tipsView.textColor = [UIColor grayColor];
    _tipsView.font = [UIFont systemFontOfSize:16.0];
    _tipsView.hidden = YES;
    [_tipsView sizeToFit];
    [_tipsView setCenter:CGPointMake(self.view.center.x, 200)];
    [self.view addSubview:_tipsView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPopMenu{
    [_popMenu toggle];
}

- (void)dropDownMenu:(DSXDropDownMenu *)dropDownMenu didSelectedAtCellItem:(UITableViewCell *)cellItem withData:(NSDictionary *)data{
    [dropDownMenu slideUp];
    NSString *action = [data objectForKey:@"action"];
    if ([action isEqualToString:@"shownotice"]) {
        MyMessageViewController *messageView = [[MyMessageViewController alloc] init];
        [self.navigationController pushViewController:messageView animated:YES];
    }
    
    if ([action isEqualToString:@"showfavorite"]) {
        MyFavoriteViewController *favorView = [[MyFavoriteViewController alloc] init];
        [self.navigationController pushViewController:favorView animated:YES];
    }
    
    if ([action isEqualToString:@"showhome"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.tabBarController setSelectedIndex:0];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_popMenu slideUp];
}

//从服务器加载数据
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
    [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
    if (_orderStatus) {
        [params setObject:_orderStatus forKey:@"order_status"];
    }
    if (_payStatus) {
        [params setObject:_payStatus forKey:@"pay_status"];
    }
    if (_shippingStatus) {
        [params setObject:_shippingStatus forKey:@"shipping_status"];
    }
    if (_evaluateStatus) {
        [params setObject:_evaluateStatus forKey:@"evaluate_status"];
    }
    [params setObject:@(_page) forKey:@"page"];
    [[DSXHttpManager sharedManager] POST:@"&c=order&a=showlist" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self reloadTableViewWithArray:[responseObject objectForKey:@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

//刷新表视图
- (void)reloadTableViewWithArray:(NSArray *)array{
    if (_isRefreshing) {
        _isRefreshing = NO;
        [_orderList removeAllObjects];
        [_tableView reloadData];
    }
    for (NSDictionary *order in array) {
        [_orderList addObject:order];
    }
    [_tableView reloadData];
    
    if ([array count] < 20) {
        _pullUpView.hidden = YES;
    }else {
        _pullUpView.hidden = NO;
    }
    [_pullUpView endLoading];
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    if ([_orderList count] == 0) {
        _tipsView.hidden = NO;
    }else {
        _tipsView.hidden = YES;
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

- (float)totalValue:(NSArray *)goodsArray{
    float totlaValue = 0;
    for (NSDictionary *dict in goodsArray) {
        float price = [[dict objectForKey:@"goods_price"] floatValue];
        NSInteger buynum = [[dict objectForKey:@"buynum"] integerValue];
        totlaValue+= price * buynum;
    }
    return totlaValue;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_orderList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *goodsArray = [[_orderList objectAtIndex:section] objectForKey:@"data"];
    return [goodsArray count]+3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *goodsArray = [[_orderList objectAtIndex:indexPath.section] objectForKey:@"data"];
    if (indexPath.row >0 && indexPath.row <= [goodsArray count]) {
        return 100.0;
    }else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *orderData = [_orderList objectAtIndex:indexPath.section];
    NSArray *goodsArray = [orderData objectForKey:@"data"];
    NSInteger goodsCount = [goodsArray count];
    
    if (indexPath.row >0 && indexPath.row <= goodsCount) {
        NSDictionary *goodsData = [goodsArray objectAtIndex:(indexPath.row-1)];
        OrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderGoodsCell" forIndexPath:indexPath];
        [cell setGoodsData:goodsData];
        return cell;
    }else {
        NSString *order_status    = [orderData objectForKey:@"order_status"];//订单状态
        NSString *pay_status      = [orderData objectForKey:@"pay_status"];//支付状态
        NSString *shipping_status = [orderData objectForKey:@"shipping_status"];//运输状态
        NSString *evaluate_status = [orderData objectForKey:@"evaluate_status"];//评价状态
        
        if (indexPath.row == 0) {
            OrderCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([[orderData objectForKey:@"shopname"] length] > 0) {
                cell.textLabel.text = [orderData objectForKey:@"shopname"];
            }else {
                cell.textLabel.text = @"店铺名称";
            }
            cell.textLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell.detailTextLabel.textColor = [UIColor redColor];
            
            if ([order_status isEqualToString:@"1"]) {
                cell.detailTextLabel.text = @"交易成功";
            }else {
                
                if ([pay_status isEqualToString:@"1"]) {
                    
                    if ([shipping_status isEqualToString:@"1"]) {
                        cell.detailTextLabel.text = @"等待卖家发货";
                    }else if ([shipping_status isEqualToString:@"2"]){
                        cell.detailTextLabel.text = @"等待买家收货";
                    }else {
                        cell.detailTextLabel.text = @"交易成功";
                    }
                }else {
                    cell.detailTextLabel.text = @"等待付款";
                }
            }
            return cell;
        }
        
        if (indexPath.row == (goodsCount+1)) {
            float totalValue = [self totalValue:goodsArray];
            OrderCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [NSString stringWithFormat:@"时间:%@",[orderData objectForKey:@"addtime"]];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"小计:%.2f",totalValue];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
            return cell;
        }
        if (indexPath.row == (goodsCount+2)) {
            OrderCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (UIView *subview in cell.subviews) {
                [subview removeFromSuperview];
            }
            if ([order_status isEqualToString:@"1"]) {
                if ([evaluate_status isEqualToString:@"1"]) {
                    UIButton *refundButton = [self buttonWithTitle:@"申请退货"];
                    refundButton.tag = indexPath.section + 1000;
                    [refundButton setFrame:CGRectMake(SWIDTH-160, 10, 80, 30)];
                    [cell addSubview:refundButton];
                }else {
                    UIButton *evalButton = [self buttonWithTitle:@"查看详情"];
                    evalButton.tag = [[orderData objectForKey:@"orderid"] integerValue];
                    [evalButton setFrame:CGRectMake(SWIDTH-90, 10, 80, 30)];
                    [evalButton addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:evalButton];
                    /**
                    UIButton *refundButton = [self buttonWithTitle:@"申请退货"];
                    refundButton.tag = indexPath.section + 1000;
                    [refundButton setFrame:CGRectMake(SWIDTH-160, 10, 80, 30)];
                    [cell addSubview:refundButton];
                     */
                }
                
            }else {
                if ([pay_status isEqualToString:@"1"]) {
                    if ([shipping_status isEqualToString:@"1"]) {
                        UIButton *doneButton = [self buttonWithTitle:@"提醒卖家发货"];
                        doneButton.tag = [[orderData objectForKey:@"orderid"] integerValue];
                        [doneButton setFrame:CGRectMake(SWIDTH-130, 10, 120, 30)];
                        [doneButton addTarget:self action:@selector(notice:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:doneButton];
                    }else if ([shipping_status isEqualToString:@"2"]){
                        UIButton *doneButton = [self buttonWithTitle:@"确认收货"];
                        doneButton.tag = [[orderData objectForKey:@"orderid"] integerValue];
                        [doneButton setFrame:CGRectMake(SWIDTH-90, 10, 80, 30)];
                        [doneButton addTarget:self action:@selector(takedelivery:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:doneButton];
                    }
                }else {
                    UIButton *cancelButton = [self buttonWithTitle:@"取消订单"];
                    [cancelButton setTag:indexPath.section];
                    [cancelButton setFrame:CGRectMake(SWIDTH-160, 10, 80, 30)];
                    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:cancelButton];
                    
                    UIButton *payButton = [self buttonWithTitle:@"付款"];
                    [payButton setTag:indexPath.section+100];
                    [payButton setFrame:CGRectMake(SWIDTH-70, 10, 60, 30)];
                    [payButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:payButton];
                }
            }
            return cell;
        }
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *orderData = [_orderList objectAtIndex:indexPath.section];
    NSArray *goodsArray = [orderData objectForKey:@"data"];
    NSInteger goodsCount = [goodsArray count];
    if (indexPath.row >0 && indexPath.row <= goodsCount){
        NSDictionary *goodsData = [goodsArray objectAtIndex:(indexPath.row-1)];
        GoodsDetailViewController *detailView = [[GoodsDetailViewController alloc] init];
        detailView.goodsid = [[goodsData objectForKey:@"goods_id"] integerValue];
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

- (void)cancel:(UIButton *)button{
    NSInteger section = button.tag;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
    [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
    [params setObject:[_orderList[section] objectForKey:@"orderid"] forKey:@"orderid"];
    [[DSXHttpManager sharedManager] POST:@"&c=order&a=delete" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //[_orderList removeObjectAtIndex:section];
            //[_tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            [self refresh];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)pay:(UIButton *)button{
    NSInteger section = button.tag - 100;
    NSDictionary *orderData = [_orderList objectAtIndex:section];
    PayViewController *payView = [[PayViewController alloc] init];
    payView.orderID = [orderData objectForKey:@"orderid"];
    payView.orderName = @"在线购物订单支付";
    payView.orderDetail = [orderData objectForKey:@"shopname"];
    [self.navigationController pushViewController:payView animated:YES];
}

- (void)evaluate:(UIButton *)button{
    OrderDetailViewController *detailView = [[OrderDetailViewController alloc] init];
    detailView.orderid = button.tag;
    [self.navigationController pushViewController:detailView animated:YES];
}

- (void)notice:(UIButton *)button{
    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"已提醒卖家发货"];
}

//收货
- (void)takedelivery:(UIButton *)button{
    NSInteger orderid = button.tag;
    NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                             @"username":[ZWUserStatus sharedStatus].username,
                             @"orderid":@(orderid)};
    [[DSXHttpManager sharedManager] POST:@"&c=order&a=takedelivery"
                              parameters:params progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self refresh];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
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
    
    if (scrollView.contentOffset.y < -120) {
        [self refresh];
    }
}

@end
