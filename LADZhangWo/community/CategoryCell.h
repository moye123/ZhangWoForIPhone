//
//  CategoryCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
@interface CategoryCell : UICollectionViewCell

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,assign)CGSize cellSize;
@property(nonatomic,assign)CGSize imageSize;
@property(nonatomic,strong)NSDictionary *cellData;
@property(nonatomic,readonly)UIImageView *imageView;
@property(nonatomic,readonly)UILabel *textLabel;
@property(nonatomic)BOOL isRemoteImage;

@end
