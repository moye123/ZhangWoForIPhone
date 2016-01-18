//
//  TravelSliderView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@class TravelSliderView;
@protocol TravelSliderViewDelegate <NSObject>
@optional
- (void)travelView:(TravelSliderView *)travelView didSelectedItemWithData:(NSDictionary *)data;

@end

@interface TravelSliderCell : UICollectionViewCell{
    @private
    UIImageView *_locationView;
    UIView *_lineView;
}
- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic)NSDictionary *travelData;

@property(nonatomic,readonly)UIImageView *imageView;
@property(nonatomic,readonly)UIImageView *ticketView;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,readonly)UILabel *detailLabel;

@end

@interface TravelSliderView : UIScrollView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic)NSArray *dataList;
@property(nonatomic)CGSize cellSize;
@property(nonatomic)CGSize imageSize;
@property(nonatomic,readonly)UICollectionView *collectionView;
@property(nonatomic,assign)id<TravelSliderViewDelegate>touchDelegate;

@end
