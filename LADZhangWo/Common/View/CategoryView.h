//
//  CategoryView.h
//  XiangBaLao
//
//  Created by Apple on 16/1/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
@class CategoryView;
@protocol CategoryViewDelegate <NSObject>
@optional
- (void)categoryView:(CategoryView *)categoryView didSelectedAtItemWithData:(NSDictionary *)data;

@end

@interface CategoryCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic)CGSize imageSize;
@property(nonatomic)NSDictionary *data;
@property(nonatomic,readonly)UIImageView *imageView;
@property(nonatomic,readonly)UILabel *textLabel;
@end

@interface CategoryView : UIScrollView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    @private
    CGFloat _cellWidth;
}

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic)CGSize cellSize;
@property(nonatomic)CGSize imageSize;
@property(nonatomic)NSArray *dataList;
@property(nonatomic,readonly)UICollectionView *collectionView;
@property(nonatomic)id<CategoryViewDelegate>touchDelegate;

@end
