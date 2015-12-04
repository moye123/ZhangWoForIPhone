//
//  IncomeViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "IncomeViewController.h"
#import "IncomeView.h"
#import "ContactusViewController.h"

@implementation IncomeViewController
@synthesize afmanager = _afmanager;
@synthesize userStatus;
@synthesize scrollView;

- (instancetype)init{
    self = [super init];
    if (self) {
        self.userStatus = [ZWUserStatus status];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的收益"];
    [self.navigationController.tabBarItem setTitle:@"收益"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    IncomeView *myIncomeView = [[IncomeView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    [self.scrollView addSubview:myIncomeView];
    
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //下载个人收益数据
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=income&ac=getdata&uid=%ld",(long)self.userStatus.uid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id dictionary = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            self.income = [dictionary objectForKey:@"income"];
            float income = [[dictionary objectForKey:@"income"] floatValue];
            myIncomeView.incomeLabel.text = [NSString stringWithFormat:@"￥: %.2f",income];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    //邀请按钮
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rechargeButton setFrame:CGRectMake(20, 217, 80, 80)];
    [rechargeButton setBackgroundImage:[UIImage imageNamed:@"icon-recharge.png"] forState:UIControlStateNormal];
    [self.scrollView addSubview:rechargeButton];
    
    //充值按钮
    UIButton *withdrawalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [withdrawalButton setFrame:CGRectMake((SWIDTH-80)/2, 217, 80, 80)];
    [withdrawalButton setBackgroundImage:[UIImage imageNamed:@"icon-withdrawal.png"] forState:UIControlStateNormal];
    [self.scrollView addSubview:withdrawalButton];
    
    //联系我们按钮
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactButton setFrame:CGRectMake(SWIDTH-100, 217, 80, 80)];
    [contactButton setBackgroundImage:[UIImage imageNamed:@"icon-contact.png"] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(showContactus) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:contactButton];
    
    //底部广告
    DSXSliderView *slider = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 310, SWIDTH, 150)];
    [self.scrollView addSubview:slider];
    
    [_afmanager GET:[SITEAPI stringByAppendingString:@"&mod=travel&ac=showlist&pagesize=3"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            NSMutableArray *imageViews = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in array) {
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[dict objectForKey:@"pic"] placeholderImage:[UIImage imageNamed:@"placeholder600x300.png"]];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                [imageViews addObject:imageView];
            }
            slider.imageViews = imageViews;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    self.scrollView.contentSize = CGSizeMake(0, 460);
    [self.view addSubview:self.scrollView];
}

- (void)showContactus{
    ContactusViewController *contactController = [[ContactusViewController alloc] init];
    [self.navigationController pushViewController:contactController animated:YES];
}

@end
