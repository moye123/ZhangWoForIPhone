//
//  OrderCatCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface OrderCatCell : UICollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,readonly)UIImageView *imageView;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,strong)NSDictionary *data;
@end
