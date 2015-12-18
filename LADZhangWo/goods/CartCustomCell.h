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
- (void)cell:(CartCustomCell *)cell didChecked:(UIButton *)checkBox goodsModel:(CartInfoModel *)model;
- (void)cell:(CartCustomCell *)cell picViewClicked:(UIImageView *)picView goodsModel:(CartInfoModel *)model;
- (void)cell:(CartCustomCell *)cell didStartEditing:(UIButton *)editButton goodsModel:(CartInfoModel *)model;
- (void)cell:(CartCustomCell *)cell didEndEditing:(UIButton *)button goodsModel:(CartInfoModel *)model;

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
