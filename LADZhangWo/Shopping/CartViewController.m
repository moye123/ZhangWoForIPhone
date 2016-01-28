//
//  CartViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CartViewController.h"
#import "LoginViewController.h"
#import "GoodsDetailViewController.h"
#import "PayViewController.h"
#import "ShopDetailViewController.h"

@implementation CartViewController
@synthesize cartList  = _cartList;
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的购物车"];
    _cartList = [NSMutableArray array];
    _goodsModelArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[CartTitleCell class] forCellReuseIdentifier:@"titleCell"];
    [_tableView registerClass:[CartCustomCell class] forCellReuseIdentifier:@"goodsCell"];
    
    DSXRefreshControl *refreshControl = [[DSXRefreshControl alloc] initWithScrollView:_tableView];
    refreshControl.delegate = self;
    
    _totalNum = 0;
    _totalValue = 0.00;
    _checkAll = [self checkBox];
    [_checkAll setFrame:CGRectMake(12, 11, 22, 22)];
    [_checkAll addTarget:self action:@selector(checkAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:_checkAll];
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"bg.png"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    
    UILabel *checkallLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 40, 25)];
    checkallLabel.text = @"全选";
    checkallLabel.font = [UIFont systemFontOfSize:16.0];
    [self.navigationController.toolbar addSubview:checkallLabel];
    
    _totaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 0, 0)];
    _totaLabel.font = [UIFont systemFontOfSize:16.0];
    [self resetTotalLabel];
    [self.navigationController.toolbar addSubview:_totaLabel];
    
    _settlement = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-100, 0, 100, self.navigationController.toolbar.frame.size.height)];
    [_settlement setBackgroundColor:[UIColor colorWithHexString:@"0x63D0BD"]];
    [_settlement setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_settlement addTarget:self action:@selector(settlement) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:_settlement];
}

- (void)resetTotalLabel{
    [_totaLabel sizeToFit];
    CGRect totalFrame = _totaLabel.frame;
    totalFrame.origin.x = SWIDTH-totalFrame.size.width-110;
    [_totaLabel setFrame:totalFrame];
}

- (void)total{
    _totalNum = 0;
    _totalValue = 0;
    for (CartInfoModel *model in _goodsModelArray) {
        if (model.selectState) {
            _totalValue+= model.goodsPrice * (float)model.goodsNum;
            _totalNum++;
        }
    }

    if (_totalNum == [_cartList count] && _totalNum>0) {
        _checkAll.selected = YES;
    }else {
        _checkAll.selected = NO;
    }
    [_settlement setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)_totalNum] forState:UIControlStateNormal];
    _totaLabel.text = [NSString stringWithFormat:@"总计:￥%.2f",_totalValue];
    [self resetTotalLabel];
}

#pragma mark - 结算
- (void)settlement{
    if (_totalNum < 1) {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"请选择商品"];
        return;
    }
    NSString *goodsids  = @"";
    NSString *buynumStr = @"";
    NSString *fromStr   = @"";
    NSString *cartIdStr = @"";
    NSString *comma = @"";
    for (CartInfoModel *model in _goodsModelArray) {
        if (model.selectState) {
            goodsids  = [goodsids stringByAppendingFormat:@"%@%ld",comma,(long)model.goodsID];
            buynumStr = [buynumStr stringByAppendingFormat:@"%@%ld",comma,(long)model.goodsNum];
            fromStr   = [fromStr stringByAppendingFormat:@"%@%@",comma,model.goodsFrom];
            cartIdStr = [cartIdStr stringByAppendingFormat:@"%@%ld",comma,(long)model.cartID];
            comma = @",";
        }
    }
    //NSLog(@"%@",buynumStr);return;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
    [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
    [params setObject:goodsids forKey:@"goodsids"];
    [params setObject:buynumStr forKey:@"goodsnums"];
    [params setObject:fromStr forKey:@"goodsfroms"];
    
    [[DSXHttpManager sharedManager] POST:@"&c=order&a=create" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                NSDictionary *orderData = [responseObject objectForKey:@"data"];
                [self deleteGoods:cartIdStr];
                PayViewController *payView = [[PayViewController alloc] init];
                payView.orderID     = [orderData objectForKey:@"orderid"];
                payView.orderName   = @"在线购物支付";
                payView.orderDetail = @"购物车结算支付";
                ZWNavigationController *nav = (ZWNavigationController *)self.navigationController;
                [nav setStyle:ZWNavigationStyleGray];
                [self.navigationController pushViewController:payView animated:YES];
            }else {
                [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"订单提交失败"];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)deleteGoods:(NSString *)cartids{
    [[DSXHttpManager sharedManager] POST:@"&c=cart&a=delete"
                              parameters:@{@"cartid":cartids,@"uid":@([ZWUserStatus sharedStatus].uid)}
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = NO;
    ZWNavigationController *nav = (ZWNavigationController *)self.navigationController;
    [nav setStyle:ZWNavigationStyleDefault];
    [self refresh];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.toolbarHidden = YES;
    [super viewWillDisappear:animated];
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
    [[DSXHttpManager sharedManager] GET:@"&c=cart&a=showlist"
                             parameters:@{@"uid":@([ZWUserStatus sharedStatus].uid),@"page":@(_page)}
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                                            _moreData = [responseObject objectForKey:@"data"];
                                            [self reloadTableViewWithArray:_moreData];
                                        }
                                    }
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    NSLog(@"%@", error);
                                }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if (_isRefreshing) {
        [_cartList removeAllObjects];
        [_goodsModelArray removeAllObjects];
        [_tableView reloadData];
    }
    
    for (NSDictionary *dict in array) {
        [_cartList addObject:dict];
        CartInfoModel *goodsModel = [[CartInfoModel alloc] init];
        goodsModel.cartID     = [[dict objectForKey:@"cartid"] integerValue];
        goodsModel.goodsID    = [[dict objectForKey:@"goods_id"] integerValue];
        goodsModel.goodsImage = [dict objectForKey:@"goods_pic"];
        goodsModel.goodsName  = [dict objectForKey:@"goods_name"];
        goodsModel.goodsPrice = [[dict objectForKey:@"goods_price"] floatValue];
        goodsModel.goodsNum   = [[dict objectForKey:@"buynum"] integerValue];
        goodsModel.goodsFrom  = [dict objectForKey:@"goods_from"];
        goodsModel.shopID     = [[dict objectForKey:@"shopid"] integerValue];
        goodsModel.shopName   = [dict objectForKey:@"shopname"];
        [_goodsModelArray addObject:goodsModel];
    }
    if ([_cartList count] < 20) {
        _tableView.dsx_footerView.hidden = YES;
    }
    [_tableView reloadData];
    [_checkAll setSelected:NO];
    [self total];
}

- (UIButton *)checkBox{
    UIButton *checkBox = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 22, 22)];
    [checkBox setBackgroundImage:[UIImage imageNamed:@"icon-round.png"] forState:UIControlStateNormal];
    [checkBox setBackgroundImage:[UIImage imageNamed:@"icon-roundcheckfill.png"] forState:UIControlStateSelected];
    return checkBox;
}

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    [self refresh];
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    [self loadMore];
}

- (void)didEndLoading:(DSXRefreshView *)refreshView{
    if ([_moreData count] < 20) {
        _tableView.dsx_footerView.loadingState = DSXLoadingStateNoMoreData;
    }
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
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CartInfoModel *model = [_goodsModelArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        CartTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = model.shopName;
        cell.isChecked = model.selectState;
        cell.delegate = self;
        cell.textLabel.tag = model.shopID;
        return cell;
    }else {
        CartCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setBackgroundColor:[UIColor colorWithHexString:@"0xf8f8f8"]];
        [cell setGoodsModel:model];
        [cell setSelectSate:model.selectState];
        [cell setTag:indexPath.section];
        [cell.picView setTag:model.goodsID];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        /*
        NSDictionary *cartData = [_cartList objectAtIndex:indexPath.section];
        ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
        shopView.shopid = [[cartData objectForKey:@"shopid"] integerValue];
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:shopView];
        [nav setStyle:ZWNavigationStyleGray];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
         */
    }
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

        NSDictionary *params = @{@"cartid":[cart objectForKey:@"cartid"],
                                 @"uid":@([ZWUserStatus sharedStatus].uid)};
        [[DSXHttpManager sharedManager] GET:@"&c=cart&a=delete" parameters:params progress:nil
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                    [_cartList removeObjectAtIndex:indexPath.section];
                    [_goodsModelArray removeObjectAtIndex:indexPath.section];
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                             withRowAnimation:UITableViewRowAnimationFade];
                }
            }else {
                [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"删除失败"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }
}

#pragma mark - titleCell delegate
- (void)titleCell:(CartTitleCell *)cell didClickedAtCheckBox:(UIButton *)checkBox{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    CartInfoModel *model = [_goodsModelArray objectAtIndex:indexPath.section];
    model.selectState = checkBox.isSelected;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    [self total];
}

- (void)titleCell:(CartTitleCell *)cell didClickedAtTitleView:(UILabel *)titleView{
    ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
    shopView.shopid = titleView.tag;
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:shopView];
    [nav setStyle:ZWNavigationStyleGray];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark - customCell delegate
- (void)customCell:(CartCustomCell *)cell didClickedItemAtCheckBox:(UIButton *)checkBox model:(CartInfoModel *)model{
    model.selectState = checkBox.isSelected;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    [self total];
}

- (void)customCell:(CartCustomCell *)cell didClickedItemAtImageView:(UIImageView *)imageView model:(CartInfoModel *)model{
    GoodsDetailViewController *detailView = [[GoodsDetailViewController alloc] init];
    detailView.goodsid = model.goodsID;
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:detailView];
    [nav setStyle:ZWNavigationStyleGray];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)customCell:(CartCustomCell *)cell didStartEditing:(UIButton *)editButton goodsModel:(CartInfoModel *)model{
    
}

- (void)customCell:(CartCustomCell *)cell didEndEditing:(UIButton *)button goodsModel:(CartInfoModel *)model{
    [self total];
    NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                             @"cartid":@(model.cartID),
                             @"buynum":@(model.goodsNum)};
    [[DSXHttpManager sharedManager] POST:@"&c=cart&a=modify"
                              parameters:params progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - checkAll
- (void)checkAll:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    for (int i=0; i<[_cartList count]; i++) {
        CartInfoModel *model = [_goodsModelArray objectAtIndex:i];
        model.selectState = sender.isSelected;
    }
    [_tableView reloadData];
    [self total];
}

@end
