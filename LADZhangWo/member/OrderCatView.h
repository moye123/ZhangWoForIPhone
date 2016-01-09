//
//  OrderCatView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCatCell.h"
@class OrderCatView;
@protocol OrderCatViewDelegate <NSObject>
@optional
- (void)orderCatView:(OrderCatView *)catView didSelectedAtItem:(NSDictionary *)data;

@end
@interface OrderCatView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSArray *_categoryList;
    CGFloat _cellWidth;
}
@property(nonatomic,assign)id<OrderCatViewDelegate>touchDelegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

@end