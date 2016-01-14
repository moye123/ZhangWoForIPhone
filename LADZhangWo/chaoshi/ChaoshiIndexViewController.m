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
        _cellWith = (SWIDTH/3)-1;
        _cellHeight = 120;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"生活超市"];
    self.view.backgroundColor = [UIColor backColor];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"六盘水" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor backColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"chaoshiCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"slideView"];
    [self downloadData];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)downloadData{
    [[AFHTTPSessionManager sharedManager] GET:[SITEAPI stringByAppendingString:@"&c=chaoshi&a=showshop"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _chaoshiList = [NSMutableArray arrayWithArray:responseObject];
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
