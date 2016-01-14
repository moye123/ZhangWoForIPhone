//
//  FavorItemCell.h
//  LADZhangWo
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface FavorItemCell : UITableViewCell{
@private
    CGFloat _picWidth;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic,readonly)UIImageView *picView;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,readonly)UILabel *timeLabel;
@property(nonatomic,readonly)UILabel *priceLabel;
@property(nonatomic,readonly)UILabel *locationLabel;
@property(nonatomic,strong)NSDictionary *favorData;
@property(nonatomic,strong)NSString *idType;

@end
