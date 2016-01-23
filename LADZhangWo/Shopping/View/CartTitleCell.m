//
//  CartTitleCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CartTitleCell.h"

@implementation CartTitleCell
@synthesize isChecked = _isChecked;
@synthesize checkBox  = _checkBox;
@synthesize title     = _title;
@synthesize delegate  = _delegate;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        _checkBox = [[UIButton alloc] init];
        [_checkBox setBackgroundImage:[UIImage imageNamed:@"icon-round.png"] forState:UIControlStateNormal];
        [_checkBox setBackgroundImage:[UIImage imageNamed:@"icon-roundcheckfill.png"] forState:UIControlStateSelected];
        [_checkBox addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_checkBox setUserInteractionEnabled:YES];
        [self addSubview:_checkBox];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTap:)];
        [self.textLabel addGestureRecognizer:tap];
        [self.textLabel setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)setIsChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    _checkBox.selected = _isChecked;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.textLabel.text = title;
}

- (void)btnClicked:(UIButton *)button{
    button.selected = !button.selected;
    if ([_delegate respondsToSelector:@selector(titleCell:didClickedAtCheckBox:)]) {
        [_delegate titleCell:self didClickedAtCheckBox:button];
    }
}

- (void)titleTap:(UITapGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(titleCell:didClickedAtTitleView:)]) {
        [_delegate titleCell:self didClickedAtTitleView:self.textLabel];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.checkBox.frame = CGRectMake(12, 11, 22, 22);
    self.textLabel.frame = CGRectMake(45, 0, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
