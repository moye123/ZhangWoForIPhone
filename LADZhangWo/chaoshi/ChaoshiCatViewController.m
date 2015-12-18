//
//  ChaoshiViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChaoshiCatViewController.h"
#import "ChaoshiListViewController.h"
#import "NewsDetailViewController.h"
#import "TravelDetailViewController.h"
#import "ShopDetailViewController.h"
#import "GoodsDetailViewController.h"

@implementation ChaoshiCatViewController
@synthesize shopid = _shopid;
@synthesize categoryList = _categoryList;

- (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _itemWith = SWIDTH/4-1;
        _categoryList = [NSMutableArray array];
        _afmanager = [AFHTTPRequestOperationManager manager];
        _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_afmanager GET:[SITEAPI stringByAppendingString:@"&mod=chaoshi&ac=showcategory"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([array isKindOfClass:[NSArray class]]) {
                _categoryList = array;
                [self.collectionView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"生活超市"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"0xffffff"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"chaoshiCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    _slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 160)];
    _slideView.groupid = 8;
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
    return [_categoryList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[_categoryList[section] objectForKey:@"childs"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_itemWith, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"chaoshiCell" forIndexPath:indexPath];
    if (cell) {
        for (UIView *subview in cell.subviews) {
            [subview removeFromSuperview];
        }
    }
    NSDictionary *category = [[[_categoryList objectAtIndex:indexPath.section] objectForKey:@"childs"] objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_itemWith-80)/2, 0, 80, 80)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[category objectForKey:@"pic"]]];
    [cell addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, _itemWith, 20)];
    titleLabel.text = [category objectForKey:@"cname"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:DSXFontStyleDemilight size:16.0];
    [cell addSubview:titleLabel];
    
    cell.backgroundColor = [UIColor backColor];
    cell.tag = [[category objectForKey:@"catid"] integerValue];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SWIDTH, 205);
    }else {
        return CGSizeMake(SWIDTH, 45);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        reuseableView.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
        for (UIView *subview in reuseableView.subviews) {
            [subview removeFromSuperview];
        }
        //图标
        NSString *pic = [[_categoryList objectAtIndex:indexPath.section] objectForKey:@"pic"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:pic]];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SWIDTH, 45)];
        titleLabel.text = [[_categoryList objectAtIndex:indexPath.section] objectForKey:@"cname"];
        titleLabel.textColor = [UIColor colorWithHexString:@"0x3DC0AD"];
        
        if (indexPath.section == 0) {
            [reuseableView addSubview:_slideView];
            [imageView setFrame:CGRectMake(10, 172, 20, 20)];
            [titleLabel setFrame:CGRectMake(40, 160, SWIDTH, 45)];
        }
        [reuseableView addSubview:imageView];
        [reuseableView addSubview:titleLabel];
    }
    return reuseableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *category = [[[_categoryList objectAtIndex:indexPath.section] objectForKey:@"childs"] objectAtIndex:indexPath.row];
    ChaoshiListViewController *listView = [[ChaoshiListViewController alloc] init];
    listView.catid = [[category objectForKey:@"catid"] integerValue];
    listView.title = [category objectForKey:@"cname"];
    if(_shopid) listView.shopid = _shopid;
    [self.navigationController pushViewController:listView animated:YES];
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
