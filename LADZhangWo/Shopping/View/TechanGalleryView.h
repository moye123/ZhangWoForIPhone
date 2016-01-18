//
//  TechanGalleryView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class TechanGalleryView;
@protocol TechanGalleryViewDelegate <NSObject>
@optional
- (void)techanGalleryView:(TechanGalleryView *)galleryView didSelectedItemWithData:(NSDictionary *)data;

@end

@interface TechanGalleryViewCell : UICollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic)CGSize imageSize;
@property(nonatomic)NSDictionary *cellData;
@property(nonatomic,readonly)UIImageView *imageView;
@property(nonatomic,readonly)UILabel *nameLabel;
@property(nonatomic,readonly)UILabel *priceLabel;
@property(nonatomic,readonly)UILabel *soldLabel;
@end

@interface TechanGalleryView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic)CGSize cellSize;
@property(nonatomic)CGSize imageSize;
@property(nonatomic)NSArray *dataList;
@property(nonatomic,assign)id<TechanGalleryViewDelegate>touchDelegate;

@end
