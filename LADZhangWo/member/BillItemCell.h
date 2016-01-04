//
//  BillItemCell.h
//  LADZhangWo
//
//  Created by Apple on 15/12/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface BillItemCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic,readonly)UILabel *nameLabel;
@property(nonatomic,readonly)UILabel *detailLabel;
@property(nonatomic,readonly)UILabel *amountLabel;
@property(nonatomic,readonly)UILabel *timeLabel;
@property(nonatomic,readonly)UILabel *statusLabel;
@property(nonatomic,strong)NSDictionary *billData;
@end
