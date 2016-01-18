//
//  NewsItemCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface NewsItemCell : UITableViewCell{
    @private
    UIImageView *_viewnumIcon;
    UIImageView *_commentnumIcon;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic)NSDictionary *newsData;
@property(nonatomic,readonly)UIImageView *picView;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,readonly)UILabel *summaryLabel;
@property(nonatomic,readonly)UILabel *timeLabel;
@property(nonatomic,readonly)UILabel *viewnumLabel;
@property(nonatomic,readonly)UILabel *commentnumLabel;

@end
