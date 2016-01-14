//
//  NoticeViewCell.h
//  LADZhangWo
//
//  Created by Apple on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface NoticeViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic,readonly)UIImageView *picView;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,readonly)UILabel *timeLabel;
@property(nonatomic,readonly)UILabel *messageLabel;
@property(nonatomic)NSDictionary *noticeData;

@end
