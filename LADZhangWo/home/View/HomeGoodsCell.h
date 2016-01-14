//
//  HomeGoodsCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface HomeGoodsCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic,readonly)UIView *backView;
@property(nonatomic,readonly)UIImageView *picView;
@property(nonatomic,readonly)DSXStarView *starView;
@property(nonatomic,readonly)UILabel *nameLabel;
@property(nonatomic,readonly)UILabel *soldLabel;
@property(nonatomic,readonly)UILabel *priceLabel;
@property(nonatomic,readonly)UILabel *locationLabel;
@property(nonatomic,strong)NSDictionary *goodsData;
@property(nonatomic,assign)CGFloat imageWidth;
@end
