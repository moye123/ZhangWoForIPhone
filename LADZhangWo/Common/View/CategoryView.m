//
//  CategoryView.m
//  XiangBaLao
//
//  Created by Apple on 16/1/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CategoryView.h"

@implementation CategoryCell
@synthesize data = _data;
@synthesize imageSize = _imageSize;
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 20;
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    NSString *pic = [data objectForKey:@"pic"];
    _textLabel.text  = [data objectForKey:@"cname"];
    if ([pic isURL]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:pic]];
    }else {
        _imageView.image = [UIImage imageNamed:pic];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_imageSize.width) {
        _imageSize.width = 50;
    }
    if (!_imageSize.height) {
        _imageSize.height = 50;
    }
    _imageView.frame = CGRectMake((self.frame.size.width-_imageSize.width)/2, 10, _imageSize.width, _imageSize.height);
    _textLabel.frame = CGRectMake(0, _imageSize.height+15, self.frame.size.width, 20);
}

@end

@implementation CategoryView
@synthesize dataList  = _dataList;
@synthesize cellSize  = _cellSize;
@synthesize imageSize = _imageSize;
@synthesize collectionView = _collectionView;
@synthesize touchDelegate  = _touchDelegate;
- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithFrame:frame]) {
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"categoryCell"];
        [self addSubview:_collectionView];
        
        _cellSize  = CGSizeMake(100, 100);
        _imageSize = CGSizeMake(50, 50);
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [_collectionView reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat frameWidth;
    if (self.contentSize.width) {
        frameWidth = self.contentSize.width;
    }else {
        frameWidth = self.frame.size.width;
    }
    _collectionView.frame = CGRectMake(0, 0, frameWidth, self.frame.size.height);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellSize.width-1, _cellSize.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.6;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [_dataList objectAtIndex:indexPath.row];
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
    cell.imageSize = _imageSize;
    cell.data = data;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [_dataList objectAtIndex:indexPath.row];
    if ([_touchDelegate respondsToSelector:@selector(categoryView:didSelectedAtItemWithData:)]) {
        [_touchDelegate categoryView:self didSelectedAtItemWithData:data];
    }
}

@end
