//
//  BillItemCell.m
//  LADZhangWo
//
//  Created by Apple on 15/12/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BillItemCell.h"

@implementation BillItemCell
@synthesize nameLabel   = _nameLabel;
@synthesize detailLabel = _detailLabel;
@synthesize amountLabel = _amountLabel;
@synthesize timeLabel   = _timeLabel;
@synthesize billData    = _billData;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView removeFromSuperview];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-100, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_nameLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, SWIDTH-120, 20)];
        _detailLabel.font = [UIFont systemFontOfSize:14.0];
        _detailLabel.textColor = [UIColor grayColor];
        [self addSubview:_detailLabel];
        
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self addSubview:_amountLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 61, 60, 20)];
        _statusLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_statusLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)setBillData:(NSDictionary *)billData{
    _billData = billData;
    [_nameLabel setText:[billData objectForKey:@"billname"]];
    [_detailLabel setText:[billData objectForKey:@"detail"]];
    if ([[billData objectForKey:@"type"] isEqualToString:@"cost"]) {
        _amountLabel.text = [NSString stringWithFormat:@"-%.2f",[[billData objectForKey:@"amount"] floatValue]];
        _amountLabel.textColor = [UIColor redColor];
    }else {
        _amountLabel.text = [NSString stringWithFormat:@"+%.2f",[[billData objectForKey:@"amount"] floatValue]];
        _amountLabel.textColor = [UIColor blackColor];
    }
    if ([[billData objectForKey:@"status"] isEqualToString:@"0"]) {
        _statusLabel.text = @"交易成功";
        _statusLabel.textColor = [UIColor colorWithHexString:@"0x336600"];
    }else {
        _statusLabel.text = @"交易失败";
        _statusLabel.textColor = [UIColor redColor];
    }
    [_timeLabel setText:[billData objectForKey:@"dateline"]];
    
    [_amountLabel sizeToFit];
    _amountLabel.frame = CGRectMake(SWIDTH-_amountLabel.frame.size.width-10, 10, _amountLabel.frame.size.width, _amountLabel.frame.size.height);
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(SWIDTH-_timeLabel.frame.size.width-10, 80-_timeLabel.frame.size.height, _timeLabel.frame.size.width, _timeLabel.frame.size.height);
}

@end
