//
//  BlankCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BlankCell.h"

@implementation BlankCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins  = UIEdgeInsetsZero;
}

@end
