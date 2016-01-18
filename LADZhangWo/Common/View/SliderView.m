//
//  SliderView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SliderView.h"

@implementation SliderViewCell
@synthesize imageSize = _imageSize;
@synthesize cellData  = _cellData;
@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setCellData:(NSDictionary *)cellData{
    _cellData = cellData;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[cellData objectForKey:@"pic"]]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_imageSize.width || !_imageSize.height) {
        _imageSize.width  = self.frame.size.width;
        _imageSize.height = self.frame.size.height;
    }
    CGRect frame;
    frame.origin.x = (self.frame.size.width - _imageSize.width)/2;
    frame.origin.y = (self.frame.size.height - _imageSize.height)/2;
    frame.size.width  = _imageSize.width;
    frame.size.height = _imageSize.height;
    _imageView.frame = frame;
}

@end

@implementation SliderView
@synthesize cellSize  = _cellSize;
@synthesize imageSize = _imageSize;
@synthesize dataList  = _dataList;
@synthesize collectionView = _collectionView;
@synthesize pageControl    = _pageControl;
@synthesize touchDelegate  = _touchDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[SliderViewCell class] forCellWithReuseIdentifier:@"sliderCell"];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [_collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataList count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.00001;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellSize.width-0.001, _cellSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SliderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sliderCell" forIndexPath:indexPath];
    cell.imageSize = _imageSize;
    cell.cellData  = [_dataList objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_touchDelegate respondsToSelector:@selector(sliderView:didSelectedItemWithData:)]) {
        [_touchDelegate sliderView:self didSelectedItemWithData:[_dataList objectAtIndex:indexPath.row]];
    }
}

@end
