//
//  GalleryView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GalleryView.h"

@implementation GalleryViewCell
@synthesize imageSize = _imageSize;
@synthesize cellData  = _cellData;
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
    //NSLog(@"%@",cellData);
    NSString *picURL = [cellData objectForKey:@"pic"];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:picURL]];
    /*
    if ([DSXValidate validateURL:picURL]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:picURL]];
    }else {
        _imageView.image = [UIImage imageNamed:picURL];
    }
     */
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_imageSize.width) {
        _imageSize.width = 100;
    }
    if (!_imageSize.height) {
        _imageSize.height = 100;
    }
    CGRect frame;
    frame.origin.x = (self.frame.size.width - _imageSize.width)/2;
    frame.origin.y = (self.frame.size.height - _imageSize.height)/2;
    frame.size.width  = _imageSize.width;
    frame.size.height = _imageSize.height;
    _imageView.frame  = frame;
}

@end

@implementation GalleryView
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
        [self registerClass:[GalleryViewCell class] forCellWithReuseIdentifier:@"viewCell"];
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0001;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellSize.width-0.001, _cellSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GalleryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"viewCell" forIndexPath:indexPath];
    cell.imageSize = _imageSize;
    cell.cellData = [_dataList objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_touchDelegate respondsToSelector:@selector(galleryView:didSelectedItemWithData:)]) {
        [_touchDelegate galleryView:self didSelectedItemWithData:[_dataList objectAtIndex:indexPath.row]];
    }
}


@end
