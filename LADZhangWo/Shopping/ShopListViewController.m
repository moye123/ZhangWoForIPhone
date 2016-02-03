//
//  ShopListViewController.m
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopDetailViewController.h"
#import "MyMessageViewController.h"
#import "MyFavoriteViewController.h"

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    [self setTitle:@"附近商家"];
    
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    //实现代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ShopItemCell class] forCellReuseIdentifier:@"shopCell"];

    [self didStartRefreshing:nil];
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

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    [super didStartRefreshing:refreshView];
    self.currentPage = 1;
    self.isRefreshing = YES;
    [self loadDataSource];
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    [super didStartRefreshing:refreshView];
    self.currentPage++;
    self.isRefreshing = NO;
    [self loadDataSource];
}

#pragma mark - loadDataSource

- (void)loadDataSource{
    [[DSXHttpManager sharedManager] GET:@"&c=shop&a=showlist" parameters:@{@"page":@(self.currentPage)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                self.moreData = [responseObject objectForKey:@"data"];
                if ([self.moreData count] > 0) {
                    if (self.isRefreshing) {
                        self.isRefreshing = NO;
                        [self.dataList removeAllObjects];
                        [self.tableView reloadData];
                    }
                    
                    for (NSDictionary *dict in self.moreData) {
                        [self.dataList addObject:dict];
                    }
                    [self.tableView reloadData];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *shopData = [self.dataList objectAtIndex:indexPath.row];
    ShopItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell" forIndexPath:indexPath];
    cell.shopData = shopData;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *shopData = [self.dataList objectAtIndex:(indexPath.row-1)];
    ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
    shopView.shopid = [[shopData objectForKey:@"shopid"] integerValue];
    [self.navigationController pushViewController:shopView animated:YES];
}

@end
