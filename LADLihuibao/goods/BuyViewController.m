//
//  BuyViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BuyViewController.h"

@implementation BuyViewController
@synthesize goodsid = _goodsid;
@synthesize goodsdata = _goodsdata;
@synthesize contentTableView = _contentTableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"购买"];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self.view addSubview:_contentTableView];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 100;
        }else {
            return 55;
        }
    }else {
        return 55;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyCell"];
    }else {
        
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImageView *goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
            goodsImage.layer.masksToBounds = YES;
            goodsImage.contentMode = UIViewContentModeScaleAspectFill;
            [goodsImage sd_setImageWithURL:[_goodsdata objectForKey:@"pic"]];
            [cell.contentView addSubview:goodsImage];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, SWIDTH-110, 40)];
            nameLabel.text = [_goodsdata objectForKey:@"name"];
            nameLabel.font = [UIFont systemFontOfSize:16.0];
            nameLabel.numberOfLines = 2;
            [nameLabel sizeToFit];
            [cell.contentView addSubview:nameLabel];
            
            UILabel *priceLabel = [[UILabel alloc] init];
            priceLabel.text = [NSString stringWithFormat:@"￥%@",[_goodsdata objectForKey:@"price"]];
            priceLabel.textColor = [UIColor redColor];
            priceLabel.font = [UIFont systemFontOfSize:18.0];
            [priceLabel sizeToFit];
            [priceLabel setFrame:CGRectMake(100, 90-priceLabel.frame.size.height, priceLabel.frame.size.width, priceLabel.frame.size.height)];
            [cell.contentView addSubview:priceLabel];
            
            UILabel *buyNum = [[UILabel alloc] init];
            buyNum.text = @"x1";
            buyNum.font = [UIFont systemFontOfSize:16.0];
            [buyNum sizeToFit];
            [buyNum setFrame:CGRectMake(SWIDTH-buyNum.frame.size.width-10, 90-buyNum.frame.size.height, buyNum.frame.size.width, buyNum.frame.size.height)];
            [cell.contentView addSubview:buyNum];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"购买数量";
            UIView *accessView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 80, 20)];
            UIButton *munusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [munusButton setBackgroundImage:[UIImage imageNamed:@"button-minus.png"] forState:UIControlStateNormal];
            [munusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [accessView addSubview:munusButton];
            
            UITextField *numField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 40, 20)];
            numField.enabled = NO;
            numField.text = @"1";
            numField.textAlignment = NSTextAlignmentCenter;
            [accessView addSubview:numField];
            
            UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 20, 20)];
            [plusButton setImage:[UIImage imageNamed:@"button-plus.png"] forState:UIControlStateNormal];
            [plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [accessView addSubview:plusButton];
            cell.accessoryView = accessView;
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"使用优惠券";
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"总计";
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
    if (footerView == nil) {
        footerView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    if (section == 1) {
        [footerView setFrame:CGRectMake(0, 0, SWIDTH, 100)];
        UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, SWIDTH-40, 40)];
        submitButton.layer.cornerRadius = 20.0;
        submitButton.layer.masksToBounds = YES;
        submitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [submitButton setBackgroundColor:[UIColor whiteColor]];
        [footerView addSubview:submitButton];
    }
    
    return footerView;
}

@end
