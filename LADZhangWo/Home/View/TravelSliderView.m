//
//  TravelSliderView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TravelSliderView.h"

@implementation TravelSliderCell
@synthesize imageView   = _imageView;
@synthesize ticketView  = _ticketView;
@synthesize titleLabel  = _titleLabel;
@synthesize detailLabel = _detailLabel;
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView];
        
        _ticketView = [[UIImageView alloc] init];
        _ticketView.image = [UIImage imageNamed:@"icon-free.png"];
        _ticketView.layer.masksToBounds = YES;
        _ticketView.layer.cornerRadius = 30;
        [self addSubview:_ticketView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor redColor];
        [self addSubview:_titleLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineView];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 3;
        _detailLabel.font = [UIFont systemFontOfSize:13.0];
        _detailLabel.textColor = [UIColor grayColor];
        [self addSubview:_detailLabel];
    }
    return self;
}

- (void)setTravelData:(NSDictionary *)travelData{
    _travelData = travelData;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[travelData objectForKey:@"pic"]]];
    
    _titleLabel.text = [travelData objectForKey:@"title"];
    _detailLabel.text = [travelData objectForKey:@"description"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-100);
    _ticketView.frame  = CGRectMake(self.frame.size.width-80, _imageView.frame.size.height-30, 60, 60);
    _titleLabel.frame  = CGRectMake(20, _imageView.frame.size.height, self.frame.size.width-100, 35);
    _lineView.frame    = CGRectMake(20, _imageView.frame.size.height+34, self.frame.size.width-100, 0.6);
    _detailLabel.frame = CGRectMake(20, _imageView.frame.size.height+30, self.frame.size.width-80, 70);
}

@end

@implementation TravelSliderView
@synthesize dataList  = _dataList;
@synthesize cellSize  = _cellSize;
@synthesize imageSize = _imageSize;
@synthesize collectionView = _collectionView;
@synthesize touchDelegate  = _touchDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[TravelSliderCell class] forCellWithReuseIdentifier:@"travelCell"];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [_collectionView reloadData];
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0001;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *travelData = [_dataList objectAtIndex:indexPath.row];
    TravelSliderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"travelCell" forIndexPath:indexPath];
    cell.travelData = travelData;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_touchDelegate respondsToSelector:@selector(travelView:didSelectedItemWithData:)]) {
        [_touchDelegate travelView:self didSelectedItemWithData:[_dataList objectAtIndex:indexPath.row]];
    }
}

@end
