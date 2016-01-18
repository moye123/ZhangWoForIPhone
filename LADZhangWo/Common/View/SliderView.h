//
//  SliderView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@class SliderView;
@protocol SliderViewDelegate <NSObject>
@optional
- (void)sliderView:(SliderView *)sliderView didSelectedItemWithData:(NSDictionary *)data;

@end

@interface SliderViewCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic)CGSize imageSize;
@property(nonatomic)NSDictionary *cellData;
@property(nonatomic,readonly)UIImageView *imageView;

@end

@interface SliderView : UIScrollView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,assign)CGSize cellSize;
@property(nonatomic,assign)CGSize imageSize;
@property(nonatomic,strong)NSArray *dataList;
@property(nonatomic,readonly)UICollectionView *collectionView;
@property(nonatomic,readonly)UIPageControl *pageControl;
@property(nonatomic,assign)id<SliderViewDelegate>touchDelegate;
@end
