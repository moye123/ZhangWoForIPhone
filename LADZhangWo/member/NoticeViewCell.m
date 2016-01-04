//
//  NoticeViewCell.m
//  LADZhangWo
//
//  Created by Apple on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NoticeViewCell.h"

@implementation NoticeViewCell
@synthesize picView = _picView;
@synthesize titleLabel = _titleLabel;
@synthesize timeLabel = _timeLabel;
@synthesize messageLabel = _messageLabel;
@synthesize noticeData = _noticeData;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        _picView.layer.cornerRadius = 3.0;
        _picView.layer.masksToBounds = YES;
        [self addSubview:_picView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 150, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, self.frame.size.width-80, 30)];
        _messageLabel.font = [UIFont systemFontOfSize:14.0];
        _messageLabel.textColor = [UIColor grayColor];
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)setNoticeData:(NSDictionary *)noticeData{
    _noticeData = noticeData;
    if (noticeData) {
        [_picView sd_setImageWithURL:[NSURL URLWithString:[noticeData objectForKey:@"userpic"]]];
        [_titleLabel setText:[noticeData objectForKey:@"title"]];
        [_timeLabel setText:[noticeData objectForKey:@"dateline"]];
        [_timeLabel sizeToFit];
        [_timeLabel setFrame:CGRectMake(SWIDTH-_timeLabel.frame.size.width-10, 10, _timeLabel.frame.size.width, _timeLabel.frame.size.height)];
        [_messageLabel setText:[noticeData objectForKey:@"message"]];
    }
}

@end
