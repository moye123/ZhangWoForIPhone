//
//  CategoryView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryCell.h"
@class CategoryView;
@protocol CategoryViewDelegate <NSObject>
@optional
- (void)categoryView:(CategoryView *)categoryView didSelectedItemAt:(NSIndexPath *)indexPath data:(NSDictionary *)data;
@end

@interface CategoryView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    CGFloat _cellWidth;
}

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic)NSArray *categoryData;
@property(nonatomic)CGSize cellSize;
@property(nonatomic)CGSize imageSize;
@property(nonatomic)BOOL isRemoteImage;
@property(nonatomic,assign)id<CategoryViewDelegate>touchDelegate;

@end
