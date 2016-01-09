//
//  CategoryView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CategoryView.h"

@implementation CategoryView
@synthesize categoryData = _categoryData;
@synthesize cellSize     = _cellSize;
@synthesize imageSize    = _imageSize;
@synthesize isRemoteImage = _isRemoteImage;
@synthesize touchDelegate = _touchDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"communityCateCell"];
        _isRemoteImage = NO;
    }
    return self;
}

- (void)setCategoryData:(NSArray *)categoryData{
    _categoryData = categoryData;
    [self reloadData];
}

#pragma mark - uicollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_categoryData count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellSize.width-0.001, _cellSize.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0001;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cellData = [_categoryData objectAtIndex:indexPath.row];
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"communityCateCell" forIndexPath:indexPath];
    cell.cellSize  = _cellSize;
    cell.imageSize = _imageSize;
    cell.isRemoteImage = _isRemoteImage;
    [cell setCellData:cellData];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_touchDelegate respondsToSelector:@selector(categoryView:didSelectedItemAt:data:)]) {
        [_touchDelegate categoryView:self didSelectedItemAt:indexPath data:[_categoryData objectAtIndex:indexPath.row]];
    }
}

@end
