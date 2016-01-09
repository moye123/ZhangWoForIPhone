//
//  CartCustomCell.m
//  LADZhangWo
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CartCustomCell.h"
#import "UIImageView+WebCache.h"

@implementation CartCustomCell
@synthesize infoView    = _infoView;
@synthesize editingView = _editingView;
@synthesize goodsModel  = _goodsModel;
@synthesize picView     = _picView;
@synthesize nameLabel   = _nameLabel;
@synthesize priceLabel  = _priceLabel;
@synthesize numLabel    = _numLabel;
@synthesize checkBox    = _checkBox;
@synthesize selectSate  = _selectSate;
@synthesize editButton  = _editButton;
@synthesize delegate    = _delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectSate = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELLWIDTH, 100)];
        [self addSubview:_infoView];
        
        _checkBox = [[UIButton alloc] initWithFrame:CGRectMake(12, 39, 22, 22)];
        [_checkBox setBackgroundImage:[UIImage imageNamed:@"icon-round.png"] forState:UIControlStateNormal];
        [_checkBox setBackgroundImage:[UIImage imageNamed:@"icon-roundcheckfill.png"] forState:UIControlStateSelected];
        [_checkBox addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_checkBox setUserInteractionEnabled:YES];
        [_infoView addSubview:_checkBox];
        
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 15, 70, 70)];
        _picView.layer.masksToBounds = YES;
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        [_infoView addSubview:_picView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [_picView addGestureRecognizer:tap];
        [_picView setUserInteractionEnabled:YES];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 10, 160, 30)];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        [_infoView addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 40, 100, 20)];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:14.0];
        [_infoView addSubview:_priceLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 60, 100, 20)];
        _numLabel.font = [UIFont systemFontOfSize:14.0];
        [_infoView addSubview:_numLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CELLWIDTH-60, 20, 0.8, 60)];
        lineView.backgroundColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1];
        [_infoView addSubview:lineView];
        
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(CELLWIDTH-40, 35, 20, 20)];
        [_editButton setBackgroundImage:[UIImage imageNamed:@"icon-edit-cart.png"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_editButton setUserInteractionEnabled:YES];
        [_infoView addSubview:_editButton];
        
        //编辑视图
        _editingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELLWIDTH, 100)];
        _editingView.hidden = YES;
        [self addSubview:_editingView];
        epicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 70, 70)];
        [_editingView addSubview:epicView];
        
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(CELLWIDTH-70, 15, 70, 70)];
        doneButton.backgroundColor = [UIColor colorWithRed:0.24 green:0.75 blue:0.68 alpha:1];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setUserInteractionEnabled:YES];
        [_editingView addSubview:doneButton];
        
        UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(90, 15, CELLWIDTH-170, 72)];
        editView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
        editView.layer.cornerRadius = 5.0;
        editView.layer.masksToBounds = YES;
        editView.layer.borderColor = editView.backgroundColor.CGColor;
        editView.layer.borderWidth = 0.8;
        [_editingView addSubview:editView];
        
        UIButton *nimusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [nimusButton setBackgroundColor:[UIColor whiteColor]];
        [nimusButton setTitle:@"-" forState:UIControlStateNormal];
        [nimusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nimusButton.titleLabel setFont:[UIFont systemFontOfSize:24.0]];
        [nimusButton addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
        [nimusButton setTag:101];
        [editView addSubview:nimusButton];
        
        UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(editView.frame.size.width-40, 0, 40, 30)];
        [plusButton setBackgroundColor:[UIColor whiteColor]];
        [plusButton setTitle:@"+" forState:UIControlStateNormal];
        [plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [plusButton.titleLabel setFont:[UIFont systemFontOfSize:24.0]];
        [plusButton addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
        [plusButton setTag:102];
        [editView addSubview:plusButton];
        
        enumField = [[UITextField alloc] initWithFrame:CGRectMake(41, 0, editView.frame.size.width-82, 30)];
        enumField.backgroundColor = [UIColor whiteColor];
        enumField.textAlignment = NSTextAlignmentCenter;
        enumField.text = [NSString stringWithFormat:@"%ld",(long)_goodsModel.goodsNum];
        enumField.font = [UIFont systemFontOfSize:16.0];
        enumField.enabled = NO;
        [editView addSubview:enumField];
        
        epriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, editView.frame.size.width/2-1, 41)];
        epriceLabel.backgroundColor = [UIColor whiteColor];
        epriceLabel.text = [NSString stringWithFormat:@"￥:%.2f",_goodsModel.goodsPrice];
        epriceLabel.textAlignment = NSTextAlignmentCenter;
        epriceLabel.font = [UIFont systemFontOfSize:16.0];
        [editView addSubview:epriceLabel];
        
        etotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(editView.frame.size.width/2, 31, editView.frame.size.width/2, 41)];
        etotalLabel.backgroundColor = [UIColor whiteColor];
        etotalLabel.text = [NSString stringWithFormat:@"%.2f",_goodsModel.goodsPrice*_goodsModel.goodsNum];
        etotalLabel.textAlignment = NSTextAlignmentCenter;
        etotalLabel.font = [UIFont systemFontOfSize:16.0];
        [editView addSubview:etotalLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setGoodsModel:(CartInfoModel *)goodsModel{
    _goodsModel = goodsModel;
    _selectSate = _goodsModel.selectState;
    [_picView sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImage]];
    [_nameLabel setText:goodsModel.goodsName];
    [_priceLabel setText:[NSString stringWithFormat:@"￥:%.2f", goodsModel.goodsPrice]];
    [_numLabel setText:[NSString stringWithFormat:@"x%ld",(long)goodsModel.goodsNum]];
    
    [epicView sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImage]];
    [enumField setText:[NSString stringWithFormat:@"%ld",(long)goodsModel.goodsNum]];
    [epriceLabel setText:[NSString stringWithFormat:@"￥:%.2f", goodsModel.goodsPrice]];
    [etotalLabel setText:[NSString stringWithFormat:@"￥:%.2f",goodsModel.goodsPrice*goodsModel.goodsNum]];
}

- (void)setSelectSate:(BOOL)selectSate{
    _selectSate = selectSate;
    _checkBox.selected = selectSate;
}

- (void)checkBoxClicked:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    _selectSate = sender.isSelected;
    _goodsModel.selectState = sender.isSelected;;
    if ([_delegate respondsToSelector:@selector(customCell:didClickedItemAtCheckBox:model:)]) {
        [_delegate customCell:self didClickedItemAtCheckBox:sender model:_goodsModel];
    }
}

- (void)imageClicked:(UITapGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(customCell:didClickedItemAtImageView:model:)]) {
        [_delegate customCell:self didClickedItemAtImageView:(UIImageView *)tap.view model:_goodsModel];
    }
}

- (void)editBtnClicked:(UIButton *)sender{
    _infoView.hidden = YES;
    _editingView.hidden = NO;
    if ([_delegate respondsToSelector:@selector(customCell:didStartEditing:goodsModel:)]) {
        [_delegate customCell:self didStartEditing:sender goodsModel:_goodsModel];
    }
}

- (void)changeNum:(UIButton *)sender{
    if (!_goodsModel.goodsNum) {
        _goodsModel.goodsNum = 1;
    }
    if (sender.tag == 101) {
        _goodsModel.goodsNum--;
    }else {
        _goodsModel.goodsNum++;
    }
    if (_goodsModel.goodsNum < 1) {
        _goodsModel.goodsNum = 1;
    }
    [self setGoodsModel:_goodsModel];
}

- (void)endEdit:(UIButton *)sender{
    _editingView.hidden = YES;
    _infoView.hidden = NO;
    [self setGoodsModel:_goodsModel];
    if ([_delegate respondsToSelector:@selector(customCell:didEndEditing:goodsModel:)]) {
        [_delegate customCell:self didEndEditing:sender goodsModel:_goodsModel];
    }
}

@end
