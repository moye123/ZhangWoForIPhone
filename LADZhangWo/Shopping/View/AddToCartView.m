//
//  AddToCartView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AddToCartView.h"

@implementation AddToCartView
@synthesize contentView = _contentView;
@synthesize goodsData = _goodsData;
- (instancetype)init{
    self = [super init];
    if (self) {
        CGRect rect = [UIScreen mainScreen].bounds;
        self.frame = rect;
        self.hidden = YES;
        _modalView = [[UIView alloc] initWithFrame:rect];
        _modalView.backgroundColor = [UIColor blackColor];
        _modalView.alpha = 0.5;
        [self addSubview:_modalView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_modalView addGestureRecognizer:tap];
        [_modalView setUserInteractionEnabled:YES];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 300)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self];
        _buyNum = 1;
        _userStatus = [ZWUserStatus sharedStatus];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}

- (void)setGoodsData:(NSDictionary *)goodsData{
    if (goodsData) {
        _goodsData = goodsData;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        [imageView sd_setImageWithURL:[_goodsData objectForKey:@"pic"]];
        [_contentView addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, self.frame.size.width-130, 40)];
        nameLabel.text = [_goodsData objectForKey:@"name"];
        nameLabel.font = [UIFont systemFontOfSize:17.0];
        [nameLabel sizeToFit];
        [_contentView addSubview:nameLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 90, self.frame.size.width-130, 20)];
        priceLabel.text = [NSString stringWithFormat:@"￥%@",[_goodsData objectForKey:@"price"]];
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = [UIFont systemFontOfSize:16.0];
        [_contentView addSubview:priceLabel];
        
        UILabel *buyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 100, 30)];
        buyNumLabel.text = @"购买数量";
        buyNumLabel.textColor = [UIColor blackColor];
        buyNumLabel.font = [UIFont systemFontOfSize:16.0];
        [_contentView addSubview:buyNumLabel];
        
        UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-116, 130, 30, 30)];
        [minusButton setTag:101];
        [minusButton setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
        [minusButton setTitle:@"-" forState:UIControlStateNormal];
        [minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [minusButton addTarget:self action:@selector(changNum:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:minusButton];
        
        _buyNumField = [[UITextField alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-80, 130, 34, 30)];
        _buyNumField.textColor = [UIColor blackColor];
        _buyNumField.textAlignment = NSTextAlignmentCenter;
        _buyNumField.enabled = NO;
        _buyNumField.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
        _buyNumField.text = [NSString stringWithFormat:@"%d",_buyNum];
        _buyNumField.font = [UIFont systemFontOfSize:14.0];
        [_contentView addSubview:_buyNumField];
        
        UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-40, 130, 30, 30)];
        [plusButton setTag:102];
        [plusButton setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
        [plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [plusButton setTitle:@"+" forState:UIControlStateNormal];
        [plusButton addTarget:self action:@selector(changNum:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:plusButton];
        
        UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _contentView.frame.size.height-40, _contentView.frame.size.width, 40)];
        [submitButton setBackgroundColor:[UIColor redColor]];
        [submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:submitButton];
    }
}

- (void)changNum:(UIButton *)sender{
    if (sender.tag == 101) {
        _buyNum--;
    }else {
        _buyNum++;
    }
    if (_buyNum<1) {
        _buyNum = 1;
    }
    _buyNumField.text = [NSString stringWithFormat:@"%d",_buyNum];
}

- (void)submit{
    if (_userStatus.isLogined) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[_goodsData objectForKey:@"id"] forKey:@"goods_id"];
        [params setObject:_buyNumField.text forKey:@"buynum"];
        [params setObject:@(_userStatus.uid) forKey:@"uid"];
        [params setObject:_userStatus.username forKey:@"username"];
        
        [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=cart&a=save"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject objectForKey:@"cartid"]) {
                    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"添加成功"];
                    [self hide];
                }
            }else {
                NSLog(@"添加失败");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
    
}

- (void)show{
    self.hidden = NO;
    CGRect frame = _contentView.frame;
    frame.origin.y = self.frame.size.height - frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = frame;
    }];
}

- (void)hide{
    CGRect frame = _contentView.frame;
    frame.origin.y = self.frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        _contentView.frame = frame;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
@end
