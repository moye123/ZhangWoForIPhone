//
//  GoodsItemCell.h
//  LADZhangWo
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface GoodsItemCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic,readonly)UIView *backView;
@property(nonatomic,readonly)UIImageView *picView;
@property(nonatomic,readonly)DSXStarView *starView;
@property(nonatomic,readonly)UILabel *nameLabel;
@property(nonatomic,readonly)UILabel *soldLabel;
@property(nonatomic,readonly)UILabel *priceLabel;
@property(nonatomic,readonly)UILabel *shopLabel;
@property(nonatomic,readonly)UILabel *locationLabel;
@property(nonatomic,strong)NSDictionary *goodsData;

@end
