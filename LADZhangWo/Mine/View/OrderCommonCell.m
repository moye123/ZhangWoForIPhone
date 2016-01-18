//
//  OrderCommonCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OrderCommonCell.h"

@implementation OrderCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins  = UIEdgeInsetsZero;
}

@end
