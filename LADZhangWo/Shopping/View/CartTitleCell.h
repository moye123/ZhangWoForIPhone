//
//  CartTitleCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CartTitleCell;
@protocol CartTitleCellDelegate <NSObject>
@optional
- (void)titleCell:(CartTitleCell *)cell didClickedAtCheckBox:(UIButton *)checkBox;
- (void)titleCell:(CartTitleCell *)cell didClickedAtTitleView:(UILabel *)titleView;
@end
@interface CartTitleCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,readonly)UIButton *checkBox;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)id<CartTitleCellDelegate>delegate;
@end
