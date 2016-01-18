//
//  GalleryView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
@class GalleryView;
@protocol GalleryViewDelegate <NSObject>
@optional
- (void)galleryView:(GalleryView *)galleryView didSelectedItemWithData:(NSDictionary *)data;

@end
@interface GalleryViewCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic)CGSize imageSize;
@property(nonatomic)NSDictionary *cellData;
@property(nonatomic,readonly)UIImageView *imageView;

@end

@interface GalleryView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,assign)CGSize cellSize;
@property(nonatomic,assign)CGSize imageSize;
@property(nonatomic)NSArray *dataList;
@property(nonatomic,assign)id<GalleryViewDelegate>touchDelegate;

@end
