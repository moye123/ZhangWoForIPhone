//
//  ServiceViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ServiceViewController.h"
#import "NewsDetailViewController.h"
#import "TravelDetailViewController.h"
#import "ShopDetailViewController.h"
#import "GoodsDetailViewController.h"

@implementation ServiceViewController
@synthesize serviceList = _serviceList;

- (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _afmanager = [AFHTTPRequestOperationManager manager];
        _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _cellWidth = SWIDTH/4 - 0.5;
        _cellHeight = 90;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"生活服务"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor backColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"serviceCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"slideView"];
    
    [_afmanager GET:[SITEAPI stringByAppendingString:@"&mod=service&ac=showlist"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            _serviceList = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    //轮播广告
    _slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 180)];
    _slideView.groupid = 9;
    _slideView.num = 3;
    _slideView.delegate = self;
    [_slideView loaddata];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_serviceList count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellWidth, _cellHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"serviceCell" forIndexPath:indexPath];
    if (cell) {
        //cell.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
        for (UIView *subview in cell.subviews) {
            [subview removeFromSuperview];
        }
        NSDictionary *service = [_serviceList objectAtIndex:indexPath.row];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cellWidth, _cellHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:contentView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_cellWidth-35)/2, 15, 35, 35)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[service objectForKey:@"pic"]]];
        [cell addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, _cellWidth, 20)];
        nameLabel.text = [service objectForKey:@"name"];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:nameLabel];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SWIDTH, 180);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseableView;
    if (kind == UICollectionElementKindSectionHeader) {
        reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"slideView" forIndexPath:indexPath];
        for (UIView *subview in reuseableView.subviews) {
            [subview removeFromSuperview];
        }
        [reuseableView addSubview:_slideView];
    }
    return reuseableView;
}

#pragma mark - dsxslideview delegate
- (void)slideView:(DSXSliderView *)slideView touchedImageWithDataID:(NSInteger)dataID idType:(NSString *)idType{
    if ([idType isEqualToString:@"goodsid"]) {
        GoodsDetailViewController *goodsView = [[GoodsDetailViewController alloc] init];
        goodsView.goodsid = dataID;
        [self.navigationController pushViewController:goodsView animated:YES];
    }
    
    if ([idType isEqualToString:@"aid"]) {
        NewsDetailViewController *newsView = [[NewsDetailViewController alloc] init];
        newsView.newsID = dataID;
        [self.navigationController pushViewController:newsView animated:YES];
    }
    
    if ([idType isEqualToString:@"shopid"]) {
        ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
        shopView.shopid = dataID;
        [self.navigationController pushViewController:shopView animated:YES];
    }
    
    if ([idType isEqualToString:@"travelid"]) {
        TravelDetailViewController *travelView = [[TravelDetailViewController alloc] init];
        travelView.travelID = dataID;
        [self.navigationController pushViewController:travelView animated:YES];
    }
}

@end
