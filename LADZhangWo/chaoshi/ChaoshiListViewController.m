//
//  ChaoshiListViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChaoshiListViewController.h"
#import "ChaoshiDetailViewController.h"
#import "MyFavoriteViewController.h"
#import "MyMessageViewController.h"

@implementation ChaoshiListViewController
@synthesize catid     = _catid;
@synthesize shopid    = _shopid;
@synthesize goodsList = _goodsList;
@synthesize menuView  = _menuView;
@synthesize collectionView = _collectionView;
@synthesize toolbar = _toolbar;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [_collectionView registerClass:[ChaoshiGoodsItemCell class] forCellWithReuseIdentifier:@"goodsCell"];
    [self.view addSubview:_collectionView];
    
    DSXRefreshControl *refreshControl = [[DSXRefreshControl alloc] initWithScrollView:_collectionView];
    refreshControl.delegate = self;
    
    _tipsView = [[UILabel alloc] init];
    _tipsView.text = @"该类目下还没有商品";
    _tipsView.textColor = [UIColor grayColor];
    _tipsView.font = [UIFont systemFontOfSize:16.0];
    _tipsView.hidden = YES;
    [_tipsView sizeToFit];
    [_tipsView setCenter:CGPointMake(self.view.center.x, 150)];
    [_collectionView addSubview:_tipsView];
    
    _goodsList = [[NSMutableArray alloc] init];
    [self refresh];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, TOPHEIGHT, SWIDTH, 50)];
    _toolbar.backgroundColor = [UIColor whiteColor];
    //[self.navigationController.view addSubview:_toolbar];
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

#pragma mark - loaddata
- (void)refresh{
    _page = 1;
    _isRefreshing = YES;
    [self downloadData];
}

- (void)loadMore{
    _page++;
    _isRefreshing = NO;
    [self downloadData];
}

- (void)downloadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_catid) {
        [params setObject:@(_catid) forKey:@"catid"];
    }
    if (_shopid) {
        [params setObject:@(_shopid) forKey:@"shopid"];
    }
    if (_page) {
        [params setObject:@(_page) forKey:@"page"];
    }
    [[DSXHttpManager sharedManager] GET:@"&c=chaoshi&a=showlist" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                NSArray *array = [responseObject objectForKey:@"data"];
                [self reloadCollectionViewWithArray:array];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)reloadCollectionViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            [_goodsList removeAllObjects];
            [self.collectionView reloadData];
        }
        for (NSDictionary *goods in array) {
            [_goodsList addObject:goods];
        }
        [self.collectionView reloadData];
    }
    if ([_goodsList count] == 0) {
        _tipsView.hidden = NO;
    }else {
        _tipsView.hidden = YES;
    }
}

#pragma mark - dsxrefresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    [self refresh];
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    [self loadMore];
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_goodsList count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SWIDTH-30)/2, (SWIDTH-30)/2+60);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *goodsData = [_goodsList objectAtIndex:indexPath.row];
    ChaoshiGoodsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
    cell.data = goodsData;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *goods = [_goodsList objectAtIndex:indexPath.row];
    ChaoshiDetailViewController *detailView = [[ChaoshiDetailViewController alloc] init];
    detailView.title = [goods objectForKey:@"name"];
    detailView.goodsid = [[goods objectForKey:@"id"] integerValue];
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}

@end
