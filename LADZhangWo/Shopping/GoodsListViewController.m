//
//  GoodsListViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsDetailViewController.h"
#import "MyFavoriteViewController.h"
#import "MyMessageViewController.h"

@implementation GoodsListViewController
@synthesize catid = _catid;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    self.tableView.originY = 51;
    self.tableView.height-= 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[GoodsItemCell class] forCellReuseIdentifier:@"goodsCell"];
    
    NSString *key = [NSString stringWithFormat:@"googsList_%ld",(long)_catid];
    [self reloadTableViewWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
    [self loadDataSource];
    
    //筛选栏
    _chooseBar = [[ChooseToolbar alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50) fid:_catid];
    _chooseBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _chooseBar.clipsToBounds = NO;
    _chooseBar.filterDelegate = self;
    [self.view addSubview:_chooseBar];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
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

#pragma mark - choosebar delegate
- (void)chooseBar:(ChooseToolbar *)choosebar filterByCatID:(NSInteger)catid{
    _catid = catid;
    [self loadDataSource];
}

- (void)chooseBar:(ChooseToolbar *)choosebar sortBySold:(BOOL)asc{
    if ([_sortBy isEqualToString:@"sold"]) {
        _sortBy = @"distance";
        _asc = @"0";
    }else {
        _sortBy = @"sold";
        _asc = @"0";
    }
    [self loadDataSource];
}

- (void)chooseBar:(ChooseToolbar *)choosebar sortByPrice:(BOOL)asc{
    _sortBy = @"price";
    _asc = asc ? @"1" : @"0";
    [self loadDataSource];
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
    self.isRefreshing = YES;
    [self loadDataSource];
}

#pragma mark - loadDataSource
- (void)loadDataSource{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(_catid) forKey:@"catid"];
    [params setObject:@(self.currentPage) forKey:@"page"];
    if ([_sortBy length] > 0) {
        [params setObject:_sortBy forKey:@"orderby"];
    }
    if ([_asc length] > 0) {
        [params setObject:_asc forKey:@"asc"];
    }
    [[DSXHttpManager sharedManager] GET:@"&c=goods&a=showlist" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                self.moreData = [responseObject objectForKey:@"data"];
                if (self.isRefreshing) {
                    NSString *key = [NSString stringWithFormat:@"googsList_%ld",(long)_catid];
                    [[NSUserDefaults standardUserDefaults] setObject:self.moreData forKey:key];
                }
                [self reloadTableViewWithArray:self.moreData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (self.isRefreshing) {
            [self.dataList removeAllObjects];
            [self.tableView reloadData];
        }
        
        for (NSDictionary *dict in self.moreData) {
            [self.dataList addObject:dict];
        }
        [self.tableView reloadData];
        [self endLoad];
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SWIDTH*0.33+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *goodsData = [self.dataList objectAtIndex:indexPath.row];
    GoodsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
    cell.goodsData  = goodsData;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSDictionary *goodsData = [self.dataList objectAtIndex:indexPath.row];
    GoodsDetailViewController *detailController = [[GoodsDetailViewController alloc] init];
    detailController.hidesBottomBarWhenPushed = YES;
    detailController.goodsid = [[goodsData objectForKey:@"id"] integerValue];
    detailController.title = [goodsData objectForKey:@"name"];
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
