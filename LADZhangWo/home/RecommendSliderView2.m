//
//  RecommendSliderView2.m
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RecommendSliderView2.h"

@implementation RecommendSliderView2
@synthesize groupid = _groupid;
@synthesize dataCount = _dataCount;
@synthesize tapDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _afmanager = [AFHTTPRequestOperationManager manager];
        _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _idTypes = [NSMutableDictionary dictionary];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)loadData{
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&c=homepage&a=showlist&groupid=%ld&num=%ld",(long)_groupid,(long)_dataCount] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            [self showImagesWithArray:array];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)showImagesWithArray:(NSArray *)array{
    if ([array count] > 0) {
        CGFloat x = 0;
        CGFloat width = (self.frame.size.width-10)/2;
        for (int i=0; i < [array count]; i++) {
            CGRect frame;
            NSInteger m = i%3;
            NSDictionary *dict = array[i];
            if (m == 0) {
                frame = CGRectMake(x, 0, width, self.frame.size.height);
                x+= width+10;
            }else if (m == 1){
                frame = CGRectMake(x, 0, width, (self.frame.size.height-10)/2);
            }else {
                frame = CGRectMake(x, (self.frame.size.height-10)/2+10, width, (self.frame.size.height-10)/2);
                x+= width;
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView sd_setImageWithURL:[dict objectForKey:@"pic"]];
            [imageView setTag:[[dict objectForKey:@"dataid"] integerValue]];
            [imageView addGestureRecognizer:tap];
            [imageView setUserInteractionEnabled:YES];
            [self addSubview:imageView];
            [_idTypes setObject:[dict objectForKey:@"idtype"] forKey:[dict objectForKey:@"dataid"]];
        }
    }
}

- (void)imageClick:(UITapGestureRecognizer *)tap{
    NSInteger dataid = tap.view.tag;
    if ([self.tapDelegate respondsToSelector:@selector(showDetailWithID:andIdType:)]) {
        NSString *idType = [_idTypes objectForKey:[NSString stringWithFormat:@"%ld",(long)dataid]];
        [self.tapDelegate showDetailWithID:dataid andIdType:idType];
    }
}

@end
