//
//  CategoryCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell
@synthesize cellSize  = _cellSize;
@synthesize imageSize = _imageSize;
@synthesize cellData  = _cellData;
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize isRemoteImage = _isRemoteImage;

- (instancetype)init{
    self = [self initWithFrame:CGRectMake(0, 0, _cellSize.width, _cellSize.height)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _isRemoteImage = NO;
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setCellSize:(CGSize)cellSize{
    _cellSize = cellSize;
}

- (void)setImageSize:(CGSize)imageSize{
    _imageSize = imageSize;
}

- (void)setCellData:(NSDictionary *)cellData{
    _cellData = cellData;
    if (_isRemoteImage) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[cellData objectForKey:@"pic"]]];
    }else {
        [_imageView setImage:[UIImage imageNamed:[cellData objectForKey:@"pic"]]];
    }
    [_textLabel setText:[cellData objectForKey:@"cname"]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = CGRectMake((_cellSize.width-_imageSize.width)/2, 10, _imageSize.width, _imageSize.height);
    _textLabel.frame = CGRectMake(0, _imageSize.height+15, _cellSize.width, 20);
}

@end
