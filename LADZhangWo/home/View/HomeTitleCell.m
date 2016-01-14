//
//  HomeTitleCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HomeTitleCell.h"

@implementation HomeTitleCell
@synthesize title  = _title;
@synthesize detail = _detail;
@synthesize image  = _image;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        self.imageView.image = [UIImage imageNamed:@"icon-hot.png"];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.textLabel.text = title;
}

- (void)setDetail:(NSString *)detail{
    _detail = detail;
    self.detailTextLabel.text = detail;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10, 20, 20);
    self.textLabel.frame = CGRectMake(35, 12, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
}

@end
