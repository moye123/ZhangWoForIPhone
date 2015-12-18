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

@implementation CartViewController
@synthesize cartList = _cartList;
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    _cartList = [NSMutableArray array];
    _shopBoxs = [NSMutableArray array];
    _goodsModelArray = [NSMutableArray array];
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    CGRect frame = self.view.bounds;
    frame.size.height = frame.size.height - 60;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _refreshControl = [[ZWRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.refreshControl = _refreshControl;
    tableViewController.tableView = _tableView;
    
    _pullUpView = [[ZWPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    _tableView.tableFooterView = _pullUpView;
    [self refresh];
    
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
    totalFrame.origin.x = SWIDTH-110-totalFrame.size.width;
    [_totaLabel setFrame:totalFrame];
}

- (void)total{
    _totalValue = 0.00;
    _totalNum = 0;
    for (CartInfoModel *model in _goodsModelArray) {
        if (model.selectState) {
            _totalValue+= model.goodsPrice*model.goodsNum;
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

- (void)settlement{
    if (_totalNum < 1) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"请选择商品"];
        return;
    }
    NSString *goodsids = @"0";
    NSString *buynumStr = @"0";
    for (CartInfoModel *model in _goodsModelArray) {
        if (model.selectState) {
            goodsids = [goodsids stringByAppendingFormat:@",%ld",(long)model.goodsID];
            buynumStr = [buynumStr stringByAppendingFormat:@",%ld",(long)model.goodsNum];
        }
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
    [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
    [params setObject:goodsids forKey:@"goodsids"];
    [params setObject:buynumStr forKey:@"buynums"];
    [_afmanager POST:[SITEAPI stringByAppendingString:@"&mod=order&ac=cartorder"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([returns isKindOfClass:[NSDictionary class]]) {
            PayViewController *payView = [[PayViewController alloc] init];
            payView.orderid = [[returns objectForKey:@"orderid"] integerValue];
            payView.orderno = [returns objectForKey:@"orderno"];
            payView.total = _totalValue;
            payView.orderTitle = payView.orderno;
            ZWNavigationController *nav = (ZWNavigationController *)self.navigationController;
            [nav setStyle:ZWNavigationStyleGray];
            [self.navigationController pushViewController:payView animated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = NO;
    ZWNavigationController *nav = (ZWNavigationController *)self.navigationController;
    [nav setStyle:ZWNavigationStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.toolbarHidden = YES;
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
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=cart&ac=showlist&uid=%ld&page=%d",(long)[[ZWUserStatus sharedStatus] uid],_page] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
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
        [_shopBoxs removeAllObjects];
        [_goodsModelArray removeAllObjects];
        for (int i=0; i<[_cartList count]; i++) {
            UIButton *shopBox = [self checkBox];
            [_shopBoxs addObject:shopBox];
            NSDictionary *goodsDict = _cartList[i];
            CartInfoModel *goodsModel = [[CartInfoModel alloc] init];
            goodsModel.cartID = [[goodsDict objectForKey:@"cartid"] integerValue];
            goodsModel.goodsID = [[goodsDict objectForKey:@"goods_id"] integerValue];
            goodsModel.goodsImage = [goodsDict objectForKey:@"goods_pic"];
            goodsModel.goodsName  = [goodsDict objectForKey:@"goods_name"];
            goodsModel.goodsPrice = [[goodsDict objectForKey:@"goods_price"] floatValue];
            goodsModel.shopName = [goodsDict objectForKey:@"shopname"];
            goodsModel.goodsNum = [[goodsDict objectForKey:@"buynum"] integerValue];
            [_goodsModelArray addObject:goodsModel];
        }
        [_tableView reloadData];
        [_checkAll setSelected:NO];
    }
    if ([array count] < 20) {
        _pullUpView.hidden = YES;
    }else{
        _pullUpView.hidden = NO;
    }
    [_pullUpView endLoading];
    
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopCell"];
        }else {
            for (UIView *subview in cell.subviews) {
                [subview removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIButton *checkBox = _shopBoxs[indexPath.section];
        [checkBox setSelected:model.selectState];
        [checkBox addTarget:self action:@selector(checkShop:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:checkBox];
        
        UILabel *shopname = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, SWIDTH-90, 45)];
        shopname.textColor = [UIColor colorWithHexString:@"0x555555"];
        if ([model.shopName isEqualToString:@""]) {
            shopname.text = @"店铺名称";
        }else {
            
            shopname.text = model.shopName;
        }
        [cell addSubview:shopname];
        return cell;
    }else {
        CartCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell"];
        if (cell == nil) {
            cell = [[CartCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodsCell"];
            cell.delegate = self;
        }
        [cell setBackgroundColor:[UIColor colorWithHexString:@"0xf8f8f8"]];
        [cell setGoodsModel:model];
        [cell setSelectSate:model.selectState];
        [cell setTag:indexPath.section];
        [cell.picView setTag:model.goodsID];
        return cell;
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
        [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=cart&ac=delete&cartid=%@&uid=%ld",[cart objectForKey:@"cartid"],(long)[ZWUserStatus sharedStatus].uid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([returns isKindOfClass:[NSDictionary class]]) {
                if ([[returns objectForKey:@"affects"] integerValue] > 0) {
                    [_cartList removeObjectAtIndex:indexPath.section];
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }
}

#pragma mark - cell delegate
- (void)cell:(CartCustomCell *)cell didChecked:(UIButton *)checkBox goodsModel:(CartInfoModel *)model{
    UIButton *shopBox = [_shopBoxs objectAtIndex:cell.tag];
    shopBox.selected = cell.selectSate;
    [self total];
}

- (void)cell:(CartCustomCell *)cell didStartEditing:(UIButton *)editButton goodsModel:(CartInfoModel *)model{
    
}

- (void)cell:(CartCustomCell *)cell didEndEditing:(UIButton *)button goodsModel:(CartInfoModel *)model{
    [self total];
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=cart&ac=modify&uid=%ld&cartid=%ld&buynum=%ld",(long)[[ZWUserStatus sharedStatus] uid],(long)model.cartID,(long)model.goodsNum] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([returns isKindOfClass:[NSDictionary class]]) {
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)cell:(CartCustomCell *)cell picViewClicked:(UIImageView *)picView goodsModel:(CartInfoModel *)model{
    GoodsDetailViewController *detailView = [[GoodsDetailViewController alloc] init];
    detailView.goodsid = model.goodsID;
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:detailView];
    [nav setStyle:ZWNavigationStyleGray];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)cell:(CartCustomCell *)cell checkBoxClicked:(UIButton *)checkBox{
    cell.selectSate = checkBox.selected;
    CartInfoModel *model = [_goodsModelArray objectAtIndex:cell.tag];
    model.selectState = cell.selectSate;
    UIButton *shopBox = [_shopBoxs objectAtIndex:cell.tag];
    shopBox.selected = cell.selectSate;
    [self total];
}

#pragma mark ---
- (void)checkAll:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    for (int i=0; i<[_cartList count]; i++) {
        CartInfoModel *model = [_goodsModelArray objectAtIndex:i];
        model.selectState = sender.isSelected;
    }
    [_tableView reloadData];
    [self total];
}

- (void)checkShop:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    NSInteger index = [_shopBoxs indexOfObject:sender];
    CartCustomCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:index]];
    cell.selectSate = sender.isSelected;
    CartInfoModel *model = [_goodsModelArray objectAtIndex:index];
    model.selectState = sender.isSelected;
    [self total];
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
}

@end
