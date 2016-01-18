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
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_picView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.font = [UIFont systemFontOfSize:13.0];
        _summaryLabel.textColor = [UIColor grayColor];
        _summaryLabel.numberOfLines = 2;
        [self addSubview:_summaryLabel];
        
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
    
    _titleLabel.text = [newsData objectForKey:@"title"];
    _summaryLabel.text = [newsData objectForKey:@"summary"];
    
    _timeLabel.text = [newsData objectForKey:@"pubtime"];
    _viewnumLabel.text = [newsData objectForKey:@"viewnum"];
    _commentnumLabel.text = [newsData objectForKey:@"commentnum"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _picView.frame = CGRectMake(8, 8, self.frame.size.width-16, 140);
    
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(8, 155, self.frame.size.width-16, _titleLabel.frame.size.height);
    _summaryLabel.frame = CGRectMake(8, 195, self.frame.size.width-16, 40);
    
    _timeLabel.frame = CGRectMake(8, 238, 100, 20);
    
    [_commentnumLabel sizeToFit];
    _commentnumLabel.frame = CGRectMake(self.frame.size.width-_commentnumLabel.frame.size.width-10, 238, _commentnumLabel.frame.size.width, 20);
    _commentnumIcon.frame = CGRectMake(_commentnumLabel.frame.origin.x-18, 242, 14, 14);
    
    [_viewnumLabel sizeToFit];
    
    _viewnumLabel.frame = CGRectMake(_commentnumIcon.frame.origin.x-_viewnumLabel.frame.size.width-20, 238, _viewnumLabel.frame.size.width, 20);
    _viewnumIcon.frame = CGRectMake(_viewnumLabel.frame.origin.x - 20, 240, 16, 16);
    
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins  = UIEdgeInsetsZero;
}

@end
