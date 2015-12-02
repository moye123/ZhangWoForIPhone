//
//  HomeCategoryView.h
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "CategoryCollectionViewCell.h"

@protocol showCategoryDelegate <NSObject>

@optional
- (void)showCategoryWithTag:(NSString *)tag;

@end
@interface HomeCategoryView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSArray *categoryList;
@property(nonatomic,retain)UICollectionView *collectionView;
@property(nonatomic,assign)id<showCategoryDelegate>categoryDelegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
