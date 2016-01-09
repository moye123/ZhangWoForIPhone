//
//  CartCustomCell.h
//  LADZhangWo
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#define CELLWIDTH [UIScreen mainScreen].bounds.size.width
#import <UIKit/UIKit.h>
#import "CartInfoModel.h"
@class CartCustomCell;
@protocol CartCustomCellDelegate <NSObject>

@optional
- (void)customCell:(CartCustomCell *)cell didClickedItemAtCheckBox:(UIButton *)checkBox model:(CartInfoModel *)model;
- (void)customCell:(CartCustomCell *)cell didClickedItemAtImageView:(UIImageView *)imageView model:(CartInfoModel *)model;
- (void)customCell:(CartCustomCell *)cell didClickedItemAtEditButton:(UIButton *)editButton model:(CartInfoModel *)model;
- (void)customCell:(CartCustomCell *)cell didStartEditing:(UIButton *)editButton goodsModel:(CartInfoModel *)model;
- (void)customCell:(CartCustomCell *)cell didEndEditing:(UIButton *)button goodsModel:(CartInfoModel *)model;

@end

@interface CartCustomCell : UITableViewCell{
    UIImageView *epicView;
    UITextField *enumField;
    UILabel *epriceLabel;
    UILabel *etotalLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic)CartInfoModel *goodsModel;
@property(nonatomic,readonly)UIView *infoView;
@property(nonatomic,readonly)UIView *editingView;
@property(nonatomic,readonly)UIImageView *picView;
@property(nonatomic,readonly)UILabel *nameLabel;
@property(nonatomic,readonly)UILabel *priceLabel;
@property(nonatomic,readonly)UILabel *numLabel;
@property(nonatomic,readonly)UIButton *checkBox;
@property(nonatomic,readonly)UIButton *editButton;
@property(nonatomic)BOOL selectSate;
@property(nonatomic,assign)id<CartCustomCellDelegate>delegate;
@end
