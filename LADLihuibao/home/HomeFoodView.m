//
//  HomeFoodView.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HomeFoodView.h"
#import "LHBCommon.h"
#import "UIImageView+WebCache.h"

@implementation HomeFoodView
@synthesize delegate;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
    label.text = @"特色美食推荐";
    label.font = [UIFont systemFontOfSize:16.0 weight:300];
    [self addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 1)];
    [self addSubview:line];
    
    [self showImageWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"homeFoods"]];
    [self loadData];
}

- (void)loadData{
    NSString *urlString = [SITEAPI stringByAppendingString:@"&mod=goods&ac=showlist&catid=1&pagesize=9"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        if ([data length] > 2) {
            id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([array isKindOfClass:[NSArray class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"homeFoods"];
                [self showImageWithArray:array];
                
            }
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)showImageWithArray:(NSArray *)array{
    if ([array count] > 2) {
        CGFloat width = (self.frame.size.width-30)/3;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 35, self.frame.size.width-20, 80)];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        NSInteger count = [array count];
        scrollView.contentSize = CGSizeMake((width+5)*count, 0);
        CGFloat x = 0;
        for (int i=0; i<[array count]; i++) {
            
            NSDictionary *dict = array[i];
            CGRect frame = CGRectMake(x, 0, width, width-20);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]]];
            [imageView setTag:[[dict objectForKey:@"id"] integerValue]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [imageView addGestureRecognizer:tap];
            [imageView setUserInteractionEnabled:YES];
            [scrollView addSubview:imageView];
            x+= width+5;
        }
    }
    
}

- (void)imageClick:(UITapGestureRecognizer *)tap{
    NSInteger foodID = tap.view.tag;
    if ([self.delegate respondsToSelector:@selector(showFoodDetailWithID:)]) {
        [self.delegate showFoodDetailWithID:foodID];
    }
}

@end
