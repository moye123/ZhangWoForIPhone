//
//  ChaoshiGoodsItemCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface ChaoshiGoodsItemCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,readonly)UIImageView *imageView;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,readonly)UILabel *priceLabel;
@property(nonatomic,readonly)UILabel *soldLabel;
@property(nonatomic,readonly)UILabel *shopLabel;
@property(nonatomic,readonly)UILabel *shopTextLabel;
@property(nonatomic)NSDictionary *data;

@end
