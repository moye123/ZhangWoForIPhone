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
@synthesize menuView       = _menuView;
@synthesize tableView      = _tableView;
@synthesize collectionView = _collectionView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"生活超市"];
    self.view.backgroundColor = [UIColor backColor];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"六盘水" style:UIBarButtonItemStylePlain target:self action:nil];
    
    CGRect frame = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[ChaoshiIndexCell class] forCellReuseIdentifier:@"tableCell"];
    [self.view addSubview:_tableView];
    
    _slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SWIDTH/2)];
    _slideView.groupid = 20;
    _slideView.num = 3;
    _slideView.delegate = self;
    [_slideView loaddata];
    [_tableView setTableHeaderView:_slideView];
    
    _menuView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, _tableView.frame.size.height)];
    _menuView.delegate = self;
    _menuView.dataSource = self;
    _menuView.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
    _menuView.tableFooterView = [[UIView alloc] init];
    _menuView.showsVerticalScrollIndicator = NO;
    _menuView.showsHorizontalScrollIndicator = NO;
    [_menuView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menuCell"];
    
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
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"categoryCell"];
    [_collectionView registerClass:[ChaoshiReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
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

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - slider view delegate
- (void)DSXSliderView:(DSXSliderView *)sliderView didSelectedItemWithData:(NSDictionary *)data{
    [[ShowAdModel sharedModel] showAdWithData:data fromViewController:self.navigationController];
}

#pragma mark - tableview delegate;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return 1;
    }else {
        return [_menuList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        return _tableView.frame.size.height - _slideView.frame.size.height;
    }else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView == tableView) {
        ChaoshiIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.menuView = _menuView;
        cell.collectionView = _collectionView;
        return cell;
    }else {
        NSDictionary *menuData = [_menuList objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
        cell.textLabel.text = [menuData objectForKey:@"cname"];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
        return cell;
    }
}

#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_categoryList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[_categoryList objectAtIndex:section] objectForKey:@"childs"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SWIDTH-100)/3, 90);
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
    [self.navigationController pushViewController:listView animated:YES];
}

@end
