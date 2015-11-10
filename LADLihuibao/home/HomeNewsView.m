//
//  HomeNewsView.m
//  LADLihuibao
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HomeNewsView.h"
#import "LHBCommon.h"
#import "UIImageView+WebCache.h"

@implementation HomeNewsView
@synthesize contentView;
@synthesize delegate;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
        titleLabel.text = @"资讯快递";
        titleLabel.font = [UIFont systemFontOfSize:16.0 weight:300];
        [self addSubview:titleLabel];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 360)];
        [self addSubview:self.contentView];
        
        [self showImageWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"homeNews"]];
        [self loadData];
    }
    return self;
}

- (void)loadData{
    NSString *urlString = [SITEAPI stringByAppendingString:@"&mod=post&ac=showlist&pic=1&pagesize=9&catid=0"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        if ([data length] > 0) {
            id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([array isKindOfClass:[NSArray class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"homeNews"];
                [self showImageWithArray:array];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)showImageWithArray:(NSArray *)array{
    if ([array count] > 0) {
        for (UIView *subview in self.contentView.subviews) {
            [subview removeFromSuperview];
        }
        
        CGFloat x=10,y=0;
        CGFloat width = (self.frame.size.width - 40)/3;
        for (int i=0; i<[array count]; i++) {
            if (i > 0) {
                if (i%3==0) {
                    x = 10;
                    y = y+90;
                }else {
                    x+= width+10;
                }
            }
            
            NSDictionary *dict = array[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, 80)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]]];
            [imageView setContentMode:UIViewContentModeScaleToFill];
            [imageView setTag:[[dict objectForKey:@"id"] intValue]];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
            [imageView addGestureRecognizer:singleTap];
            [imageView setUserInteractionEnabled:YES];
            [self.contentView addSubview:imageView];
        }
    }
    
}

- (void)imageViewClick:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger newsID = tap.view.tag;
    
    if ([self.delegate respondsToSelector:@selector(showNewsDetailWhithID:)]) {
        [self.delegate showNewsDetailWhithID:newsID];
    }
}

@end
