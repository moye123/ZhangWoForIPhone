//
//  BuyViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BuyViewController.h"
#import "PayViewController.h"

@implementation BuyViewController
@synthesize goodsid = _goodsid;
@synthesize goodsdata = _goodsdata;
@synthesize contentTableView = _contentTableView;
@synthesize userStatus;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"购买"];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    self.userStatus = [LHBUserStatus status];
    
    _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self.view addSubview:_contentTableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 90)];
    _contentTableView.tableFooterView = footerView;
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, SWIDTH-40, 40)];
    _submitButton.layer.cornerRadius = 20.0;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:[UIColor whiteColor]];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"button-buy-selected.png"] forState:UIControlStateHighlighted];
    [_submitButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_submitButton];
    
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
            
            //购买数量显示标签
            _buyNum = [[UILabel alloc] init];
            _buyNum.text = @"x1";
            _buyNum.font = [UIFont systemFontOfSize:16.0];
            [_buyNum setFrame:CGRectMake(SWIDTH-40, 72, 60, 20)];
            [cell.contentView addSubview:_buyNum];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"购买数量";
            UIView *accessView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 84, 22)];
            UIButton *munusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
            [munusButton setBackgroundImage:[UIImage imageNamed:@"button-minus.png"] forState:UIControlStateNormal];
            [munusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [munusButton setBackgroundColor:[UIColor colorWithHexString:@"0xcccccc"]];
            [munusButton setTag:101];
            [munusButton addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
            [accessView addSubview:munusButton];
            
            _numField = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, 40, 22)];
            _numField.enabled = NO;
            _numField.text = @"1";
            _numField.textAlignment = NSTextAlignmentCenter;
            [accessView addSubview:_numField];
            
            UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(62, 0, 22, 22)];
            [plusButton setImage:[UIImage imageNamed:@"button-plus.png"] forState:UIControlStateNormal];
            [plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [plusButton setBackgroundColor:[UIColor colorWithHexString:@"0xcccccc"]];
            [plusButton setTag:102];
            [plusButton addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
            [accessView addSubview:plusButton];
            cell.accessoryView = accessView;
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"使用优惠券";
            _useCoupons = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
            [_useCoupons setBackgroundImage:[UIImage imageNamed:@"icon-select.png"] forState:UIControlStateNormal];
            [_useCoupons setBackgroundImage:[UIImage imageNamed:@"icon-selectfill.png"] forState:UIControlStateSelected];
            [_useCoupons addTarget:self action:@selector(toggleSelect:) forControlEvents:UIControlEventTouchUpInside];
            [_useCoupons setUserInteractionEnabled:YES];
            cell.accessoryView = _useCoupons;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"总计";
            _total = [[UILabel alloc] initWithFrame:CGRectZero];
            _total.text = @"￥0.00";
            _total.font = [UIFont systemFontOfSize:16.0];
            [_total sizeToFit];
            cell.accessoryView = _total;
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

#pragma mark - action
- (void)toggleSelect:(UIButton *)sender{
    if (sender.isSelected) {
        sender.selected = NO;
    }else {
        sender.selected = YES;
    }
}

- (void)changeNum:(UIButton *)sender{
    NSInteger buynum = [_numField.text integerValue];
    if (sender.tag == 101) {
        buynum--;
    }else {
        buynum++;
    }
    if (buynum < 1) {
        buynum = 1;
    }
    _numField.text = [NSString stringWithFormat:@"%d", buynum];
    _buyNum.text = [NSString stringWithFormat:@"x%d", buynum];
    float total = [[_goodsdata objectForKey:@"price"] floatValue] * buynum;
    _total.text = [NSString stringWithFormat:@"￥%.2f", total];
    [_total sizeToFit];
}

- (void)submitOrder{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.userStatus.uid) forKey:@"uid"];
    [params setObject:self.userStatus.username forKey:@"username"];
    [params setObject:[_goodsdata objectForKey:@"id"] forKey:@"goods_id"];
    [params setObject:[_goodsdata objectForKey:@"price"] forKey:@"goods_price"];
    [params setObject:_numField.text forKey:@"buynum"];
    
    UIView *loadingView = [[DSXUI sharedUI] showLoadingViewWithMessage:@"订单提交中.."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[SITEAPI stringByAppendingString:@"&mod=order&ac=create"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [loadingView removeFromSuperview];
        id returns = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([returns isKindOfClass:[NSDictionary class]]) {
            if ([[returns objectForKey:@"orderid"] integerValue] > 0) {
                PayViewController *payView = [[PayViewController alloc] init];
                payView.orderid = [[returns objectForKey:@"orderid"] integerValue];
                payView.orderno = [returns objectForKey:@"orderno"];
                payView.orderTitle = [_goodsdata objectForKey:@"name"];
                payView.total = [_numField.text floatValue];
                [self.navigationController pushViewController:payView animated:YES];
            }
        }else {
            [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"订单保存失败,请重试"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"系统繁忙,请稍后重试"];
    }];
}

@end
