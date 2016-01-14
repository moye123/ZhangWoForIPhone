//
//  OrderItemCell.h
//  LADZhangWo
//
//  Created by Apple on 15/12/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface OrderItemCell : UITableViewCell

@property(nonatomic,readonly)UIImageView *picView;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,readonly)UILabel *priceLabel;
@property(nonatomic,readonly)UILabel *numLabel;
@property(nonatomic,strong)NSDictionary *goodsData;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
