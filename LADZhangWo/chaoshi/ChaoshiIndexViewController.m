//
//  ChaoshiIndexViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChaoshiIndexViewController.h"
#import "ChaoshiCatViewController.h"

@implementation ChaoshiIndexViewController
@synthesize chaoshiList = _chaoshiList;

- (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _afmanager = [AFHTTPRequestOperationManager manager];
        _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _cellWith = (SWIDTH/3)-1;
        _cellHeight = 120;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"生活超市"];
    self.view.backgroundColor = [UIColor backColor];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"六盘水" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor backColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"chaoshiCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"slideView"];
    [self downloadData];
    
    //轮播广告
    _slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 150)];
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_afmanager GET:[SITEAPI stringByAppendingString:@"&mod=travel&ac=showlist&pagesize=3"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            NSMutableArray *imageViews = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in array) {
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[dict objectForKey:@"pic"] placeholderImage:[UIImage imageNamed:@"placeholder600x300.png"]];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                [imageViews addObject:imageView];
            }
            _slideView.imageViews = imageViews;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)downloadData{
    [_afmanager GET:[SITEAPI stringByAppendingString:@"&mod=chaoshi&ac=showshop"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            _chaoshiList = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_chaoshiList count];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"chaoshiCell" forIndexPath:indexPath];
    if (cell) {
        for (UIView *subview in cell.subviews) {
            [subview removeFromSuperview];
        }
        NSDictionary *chaoshi = [_chaoshiList objectAtIndex:indexPath.row];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_cellWith-70)/2, 10, 70, 70)];
        imageView.layer.cornerRadius = 35.0;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 0.6;
        imageView.layer.borderColor = [UIColor grayColor].CGColor;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[chaoshi objectForKey:@"pic"]]];
        [cell addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, _cellWith, 20)];
        titleLabel.text = [chaoshi objectForKey:@"shopname"];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:titleLabel];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SWIDTH, 150);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseableView;
    if (kind == UICollectionElementKindSectionHeader) {
        reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"slideView" forIndexPath:indexPath];
        if (reuseableView) {
            for (UIView *subview in reuseableView.subviews) {
                [subview removeFromSuperview];
            }
            [reuseableView addSubview:_slideView];
        }
    }
    return reuseableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *chaoshi = [_chaoshiList objectAtIndex:indexPath.row];
    ChaoshiCatViewController *catView = [[ChaoshiCatViewController alloc] init];
    catView.title = [chaoshi objectForKey:@"shopname"];
    catView.shopid = [[chaoshi objectForKey:@"shopid"] integerValue];
    [self.navigationController pushViewController:catView animated:YES];
}


@end