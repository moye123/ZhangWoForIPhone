//
//  ServiceItemCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface ServiceItemCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic)NSDictionary *serviceData;
@property(nonatomic,assign)CGFloat imageWidth;
@property(nonatomic,readonly)DSXStarView *startView;
@property(nonatomic,readonly)UILabel *contactLabel;
@property(nonatomic,readonly)UILabel *addressLabel;
@property(nonatomic,readonly)UILabel *distanceLabel;

@end
