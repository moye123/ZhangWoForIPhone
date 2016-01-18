//
//  TechanGalleryView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TechanGalleryView.h"

@implementation TechanGalleryViewCell
@synthesize imageSize = _imageSize;
@synthesize cellData  = _cellData;
@synthesize imageView = _imageView;
@synthesize nameLabel = _nameLabel;
@synthesize priceLabel = _priceLabel;
@synthesize soldLabel = _soldLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13.0];
        _nameLabel.numberOfLines = 2;
        [self addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _priceLabel.textColor = [UIColor redColor];
        [self addSubview:_priceLabel];
        
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.font = [UIFont systemFontOfSize:10.0];
        _soldLabel.textColor = [UIColor grayColor];
        [self addSubview:_soldLabel];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setCellData:(NSDictionary *)cellData{
    _cellData = cellData;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[cellData objectForKey:@"pic"]]];
    [_nameLabel setText:[cellData objectForKey:@"name"]];
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[cellData objectForKey:@"price"] floatValue]];
    _soldLabel.text  = [NSString stringWithFormat:@"%@人付款",[cellData objectForKey:@"sold"]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_imageSize.width) {
        _imageSize.width = 100;
    }
    if (!_imageSize.height) {
        _imageSize.height = 100;
    }
    [_priceLabel sizeToFit];
    [_soldLabel sizeToFit];
    _imageView.frame  = CGRectMake(0, 0, _imageSize.width, _imageSize.height);
    _priceLabel.frame = CGRectMake(3, _imageSize.height+3, _priceLabel.frame.size.width, 20);
    _soldLabel.frame  = CGRectMake(self.frame.size.width-_soldLabel.frame.size.width-3, _imageSize.height+3, _soldLabel.frame.size.width, 20);
    
    _nameLabel.frame  = CGRectMake(4, _imageSize.height+20, self.frame.size.width-8, 40);
}

@end

@implementation TechanGalleryView
@synthesize cellSize  = _cellSize;
@synthesize imageSize = _imageSize;
@synthesize dataList  = _dataList;
@synthesize touchDelegate = _touchDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[TechanGalleryViewCell class] forCellWithReuseIdentifier:@"galleryCell"];
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellSize.width-0.001, _cellSize.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TechanGalleryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"galleryCell" forIndexPath:indexPath];
    cell.imageSize = _imageSize;
    cell.cellData  = [_dataList objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_touchDelegate respondsToSelector:@selector(techanGalleryView:didSelectedItemWithData:)]) {
        [_touchDelegate techanGalleryView:self didSelectedItemWithData:[_dataList objectAtIndex:indexPath.row]];
    }
}

@end
