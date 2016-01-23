//
//  NewsItemCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NewsItemCell.h"

@implementation NewsItemCell
@synthesize newsData = _newsData;
@synthesize picView      = _picView;
@synthesize titleLabel   = _titleLabel;
@synthesize summaryLabel = _summaryLabel;
@synthesize timeLabel    = _timeLabel;
@synthesize viewnumLabel = _viewnumLabel;
@synthesize commentnumLabel = _commentnumLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        [self.contentView removeFromSuperview];
        
        _picView = [[UIImageView alloc] init];
        _picView.layer.masksToBounds = YES;
        _picView.layer.cornerRadius = 2.0;
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.backgroundColor = [UIColor grayColor];
        [self addSubview:_picView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.font = [UIFont systemFontOfSize:13.0];
        _summaryLabel.textColor = [UIColor grayColor];
        _summaryLabel.numberOfLines = 2;
        //[self addSubview:_summaryLabel];
        
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.textColor = [UIColor grayColor];
        _fromLabel.font =[UIFont systemFontOfSize:12.0];
        [self addSubview:_fromLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        _viewnumLabel = [[UILabel alloc] init];
        _viewnumLabel.font = [UIFont systemFontOfSize:12.0];
        _viewnumLabel.textColor = [UIColor grayColor];
        [self addSubview:_viewnumLabel];
        
        _commentnumLabel = [[UILabel alloc] init];
        _commentnumLabel.font = [UIFont systemFontOfSize:12.0];
        _commentnumLabel.textColor = [UIColor grayColor];
        [self addSubview:_commentnumLabel];
        
        _viewnumIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-browse.png"]];
        [self addSubview:_viewnumIcon];
        
        _commentnumIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-comments.png"]];
        [self addSubview:_commentnumIcon];
    }
    return self;
}

- (void)setNewsData:(NSDictionary *)newsData{
    _newsData = newsData;
    [_picView sd_setImageWithURL:[NSURL URLWithString:[newsData objectForKey:@"pic"]]];
    
    _titleLabel.text   = [newsData objectForKey:@"title"];
    _summaryLabel.text = [newsData objectForKey:@"summary"];
    _fromLabel.text = [newsData objectForKey:@"from"];
    _timeLabel.text = [newsData objectForKey:@"pubtime"];
    _viewnumLabel.text = [newsData objectForKey:@"viewnum"];
    _commentnumLabel.text = [newsData objectForKey:@"commentnum"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame;
    frame.origin.x = 10;
    frame.origin.y = 10;
    frame.size.width = self.frame.size.height - 20;
    frame.size.height = self.frame.size.height - 20;
    _picView.frame = frame;
    
    [_titleLabel sizeToFit];
    frame.origin.x = _picView.frame.size.width + 20;
    frame.origin.y = 10;
    frame.size.width = self.frame.size.width - _picView.frame.size.width - 30;
    frame.size.height = _titleLabel.frame.size.height;
    _titleLabel.frame = frame;
    //_summaryLabel.frame = CGRectMake(8, 195, self.frame.size.width-16, 40);
    
    [_fromLabel sizeToFit];
    frame.origin.x = _picView.frame.size.width + 20;
    frame.origin.y = _titleLabel.frame.size.height + 13;
    frame.size.width = _fromLabel.size.width;
    frame.size.height = 20;
    _fromLabel.frame = frame;
    
    [_timeLabel sizeToFit];
    frame.origin.x = _picView.frame.size.width + 20;
    frame.origin.y = _picView.frame.size.height - 8;
    frame.size.width = _timeLabel.size.width;
    frame.size.height = 20;
    _timeLabel.frame = frame;
    
    [_commentnumLabel sizeToFit];
    frame.origin.x = self.frame.size.width-_commentnumLabel.frame.size.width-10;
    frame.origin.y = _picView.frame.size.height - 8;
    frame.size.width = _commentnumLabel.frame.size.width;
    frame.size.height = 20;
    _commentnumLabel.frame = frame;
    _commentnumIcon.frame = CGRectMake(_commentnumLabel.frame.origin.x-18, _commentnumLabel.frame.origin.y+2, 14, 14);
    
    [_viewnumLabel sizeToFit];
    frame.origin.x = _commentnumIcon.frame.origin.x-_viewnumLabel.frame.size.width-20;
    frame.origin.y = _picView.frame.size.height - 8;
    frame.size.width = _viewnumLabel.frame.size.width;
    frame.size.height = 20;
    _viewnumLabel.frame = frame;
    _viewnumIcon.frame = CGRectMake(_viewnumLabel.frame.origin.x - 20, frame.origin.y, 16, 16);
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
