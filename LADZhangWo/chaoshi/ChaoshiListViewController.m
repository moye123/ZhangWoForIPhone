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
@synthesize catid = _catid;
@synthesize shopid = _shopid;
@synthesize goodsList = _goodsList;

- (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _page = 1;
        _cellWith = (SWIDTH-10)/2 - 0.01;
        _cellHeight = 210;
        _goodsList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"goodsCell"];
    [self downloadData];
    
    _refreshControl = [[ZWRefreshControl alloc] init];
    _pullUpView = [[ZWPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    
    _tipsView = [[UILabel alloc] init];
    _tipsView.text = @"该类目下还没有商品";
    _tipsView.textColor = [UIColor grayColor];
    _tipsView.font = [UIFont systemFontOfSize:16.0];
    _tipsView.hidden = YES;
    [_tipsView sizeToFit];
    [_tipsView setCenter:CGPointMake(self.view.center.x, 150)];
    [self.view addSubview:_tipsView];
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
    [[AFHTTPRequestOperationManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=chaoshi&a=showlist"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [self reloadCollectionViewWithArray:responseObject];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
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
        if ([_refreshControl isRefreshing]) {
            [_refreshControl endRefreshing];
        }
    }
    if ([_goodsList count] == 0) {
        _tipsView.hidden = NO;
    }else {
        _tipsView.hidden = YES;
    }
    if ([array count] < 20) {
        _pullUpView.hidden = YES;
    }else {
        _pullUpView.hidden = NO;
    }
    [_pullUpView endLoading];
}

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

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_goodsList count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellWith, _cellHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
    if (cell) {
        for (UIView *subview in cell.subviews) {
            [subview removeFromSuperview];
        }
        NSDictionary *goods = [_goodsList objectAtIndex:indexPath.row];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cellWith, _cellHeight)];
        contentView.backgroundColor = [UIColor backColor];
        [cell addSubview:contentView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _cellWith, 130)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[goods objectForKey:@"pic"]]];
        [contentView addSubview:imageView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 130, _cellWith, 0.8)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
        [contentView addSubview:line];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, _cellWith-20, 40)];
        nameLabel.text = [goods objectForKey:@"name"];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.numberOfLines = 2;
        //[nameLabel sizeThatFits:CGSizeMake(_cellWith-20, 40)];
        [nameLabel sizeToFit];
        [contentView addSubview:nameLabel];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.text = [NSString stringWithFormat:@"￥%@",[goods objectForKey:@"price"]];
        priceLabel.font = [UIFont systemFontOfSize:18.0];
        priceLabel.textColor = [UIColor colorWithHexString:@"0x3DC0AD"];
        [priceLabel sizeToFit];
        [priceLabel setFrame:CGRectMake(_cellWith-priceLabel.frame.size.width-10, _cellHeight-priceLabel.frame.size.height-10, priceLabel.frame.size.width, priceLabel.frame.size.height)];
        [contentView addSubview:priceLabel];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
