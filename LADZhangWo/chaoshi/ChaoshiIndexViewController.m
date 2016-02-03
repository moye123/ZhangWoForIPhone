//
//  ChaoshiIndexViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChaoshiIndexViewController.h"
#import "ChaoshiCatViewController.h"
#import "ChaoshiListViewController.h"

@implementation ChaoshiIndexViewController
@synthesize menuList       = _menuList;
@synthesize categoryList   = _categoryList;
@synthesize scrollView     = _scrollView;
@synthesize menuView       = _menuView;
@synthesize collectionView = _collectionView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"生活超市"];
    self.view.backgroundColor = [UIColor backColor];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"六盘水" style:UIBarButtonItemStylePlain target:self action:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    _slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SWIDTH/2)];
    _slideView.groupid = 20;
    _slideView.num = 3;
    _slideView.delegate = self;
    [_slideView loaddata];
    [_scrollView addSubview:_slideView];
    
    _menuView = [[UITableView alloc] initWithFrame:CGRectMake(0, _slideView.height, 100, SHEIGHT)];
    _menuView.delegate = self;
    _menuView.dataSource = self;
    _menuView.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
    _menuView.tableFooterView = [[UIView alloc] init];
    _menuView.showsVerticalScrollIndicator = NO;
    _menuView.showsHorizontalScrollIndicator = NO;
    _menuView.scrollEnabled = NO;
    [_menuView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menuCell"];
    [_scrollView addSubview:_menuView];
    
    //下载左侧菜单数据
    [[DSXHttpManager sharedManager] GET:@"&c=chaoshi&a=showcategorybyfid&fid=0" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                _menuList = [responseObject objectForKey:@"data"];
                [_menuView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_menuView.width+10, _slideView.height, SWIDTH-_menuView.width-10, _menuView.height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"categoryCell"];
    [_collectionView registerClass:[ChaoshiReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    //[_collectionView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [_collectionView addObserver:self forKeyPath:@"contentSize"
                         options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                         context:nil];
    [_scrollView addSubview:_collectionView];
    
    //下载右侧菜单数据
    [[DSXHttpManager sharedManager] GET:@"&c=chaoshi&a=showcategory" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                _categoryList = [responseObject objectForKey:@"data"];
                [_collectionView reloadData];
                //NSLog(@"%@",_categoryList);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[_collectionView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //CGFloat contentHeight = _slideView.height + _collectionView.contentSize.height;
    //_scrollView.contentSize = CGSizeMake(0, contentHeight);
    //_menuView.height = _collectionView.contentSize.height;
    //_collectionView.height = _collectionView.contentSize.height;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat contentHeight = _slideView.height + _collectionView.contentSize.height;
        _scrollView.contentSize = CGSizeMake(0, contentHeight);
        _menuView.height = _collectionView.contentSize.height;
        _collectionView.height = _collectionView.contentSize.height;
    }
}

- (void)dealloc{
    //[super dealloc];
    [_collectionView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - slider view delegate
- (void)DSXSliderView:(DSXSliderView *)sliderView didSelectedItemWithData:(NSDictionary *)data{
    [[ShowAdModel sharedModel] pushWithData:data fromViewController:self.navigationController];
}

#pragma mark - tableview delegate;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_menuList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *menuData = [_menuList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    cell.textLabel.text = [menuData objectForKey:@"cname"];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSDictionary *data = [_menuList objectAtIndex:indexPath.row];
    ChaoshiListViewController *listView = [[ChaoshiListViewController alloc] init];
    listView.catid = [[data objectForKey:@"catid"] integerValue];
    listView.title = [data objectForKey:@"cname"];
    listView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listView animated:YES];
}

#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_categoryList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[_categoryList objectAtIndex:section] objectForKey:@"childs"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.width-11)/3, 90);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SWIDTH, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [[[_categoryList objectAtIndex:indexPath.section] objectForKey:@"childs"] objectAtIndex:indexPath.row];
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
    cell.imageSize = CGSizeMake(50, 50);
    cell.data = data;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        NSDictionary *data = [_categoryList objectAtIndex:indexPath.section];
        ChaoshiReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        headerView.text = [data objectForKey:@"cname"];
        return headerView;
    }else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [[[_categoryList objectAtIndex:indexPath.section] objectForKey:@"childs"] objectAtIndex:indexPath.row];
    ChaoshiListViewController *listView = [[ChaoshiListViewController alloc] init];
    listView.catid = [[data objectForKey:@"catid"] integerValue];
    listView.title = [data objectForKey:@"cname"];
    listView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listView animated:YES];
}

@end
