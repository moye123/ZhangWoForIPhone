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
@synthesize toolbar = _toolbar;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的购物车"];
    _goodsModelArray = [NSMutableArray array];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.tableView registerClass:[CartTitleCell class] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerClass:[CartCustomCell class] forCellReuseIdentifier:@"goodsCell"];
    
    _totalNum = 0;
    _totalValue = 0.00;
    _toolbar = self.navigationController.toolbar;
    //_toolbar.delegate = self;
    
    _checkAll = [self checkBox];
    [_checkAll setFrame:CGRectMake(12, 11, 22, 22)];
    [_checkAll addTarget:self action:@selector(checkAll:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:_checkAll];
    [_toolbar setBackgroundImage:[UIImage imageNamed:@"bg.png"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    
    UILabel *checkallLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 40, 25)];
    checkallLabel.text = @"全选";
    checkallLabel.font = [UIFont systemFontOfSize:16.0];
    [_toolbar addSubview:checkallLabel];
    
    _totaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 0, 0)];
    _totaLabel.font = [UIFont systemFontOfSize:16.0];
    [self resetTotalLabel];
    [_toolbar addSubview:_totaLabel];
    
    _settlement = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-100, 0, 100, _toolbar.height)];
    [_settlement setBackgroundColor:[UIColor colorWithHexString:@"0x63D0BD"]];
    [_settlement setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_settlement addTarget:self action:@selector(settlement) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:_settlement];
    [self.view addSubview:_toolbar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    ZWNavigationController *nav = (ZWNavigationController *)self.navigationController;
    [nav setStyle:ZWNavigationStyleDefault];
    [self didStartRefreshing:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - toolbar delegate
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionBottom;
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

    if (_totalNum == [self.dataList count] && _totalNum>0) {
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

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    [super didStartRefreshing:refreshView];
    self.currentPage = 1;
    self.isRefreshing = YES;
    [self loadDataSource];
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    [super didStartLoading:refreshView];
    self.currentPage++;
    self.isRefreshing = NO;
    [self loadDataSource];
}

#pragma mark - loadDataSource
- (void)loadDataSource{
    [[DSXHttpManager sharedManager] GET:@"&c=cart&a=showlist"
                             parameters:@{@"uid":@([ZWUserStatus sharedStatus].uid),@"page":@(self.currentPage)}
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                                            self.moreData = [responseObject objectForKey:@"data"];
                                            [self reloadTableViewWithArray:self.moreData];
                                        }
                                    }
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    NSLog(@"%@", error);
                                }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.dataList removeAllObjects];
        [_goodsModelArray removeAllObjects];
        [self.tableView reloadData];
    }
    
    for (NSDictionary *dict in array) {
        [self.dataList addObject:dict];
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
    [self.tableView reloadData];
    [_checkAll setSelected:NO];
    [self total];
}

- (UIButton *)checkBox{
    UIButton *checkBox = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 22, 22)];
    [checkBox setBackgroundImage:[UIImage imageNamed:@"icon-round.png"] forState:UIControlStateNormal];
    [checkBox setBackgroundImage:[UIImage imageNamed:@"icon-roundcheckfill.png"] forState:UIControlStateSelected];
    return checkBox;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataList count];
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
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return YES;
    }else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cart = [self.dataList objectAtIndex:indexPath.section];
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSDictionary *params = @{@"cartid":[cart objectForKey:@"cartid"],
                                 @"uid":@([ZWUserStatus sharedStatus].uid)};
        [[DSXHttpManager sharedManager] GET:@"&c=cart&a=delete" parameters:params progress:nil
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                    [self.dataList removeObjectAtIndex:indexPath.section];
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CartInfoModel *model = [_goodsModelArray objectAtIndex:indexPath.section];
    model.selectState = checkBox.isSelected;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
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
    for (int i=0; i<[self.dataList count]; i++) {
        CartInfoModel *model = [_goodsModelArray objectAtIndex:i];
        model.selectState = sender.isSelected;
    }
    [self.tableView reloadData];
    [self total];
}

@end
