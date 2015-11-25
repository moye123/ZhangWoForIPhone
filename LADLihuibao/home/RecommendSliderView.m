//
//  RecommendSliderView.m
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RecommendSliderView.h"

@implementation RecommendSliderView
@synthesize tapDelegate;
@synthesize groupid = _groupid;
@synthesize dataCount = _dataCount;
@synthesize imgWidth = _imgWidth;
@synthesize imgHeight = _imgHeight;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        _idTypes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)showImages{
    
}

- (void)loadData{
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=homepage&ac=showlist&groupid=%d&num=%d",_groupid,_dataCount];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"recommendSlider%d",_groupid]];
            [self showImageWithArray:array];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)showImageWithArray:(NSArray *)array{
    if ([array count] > 0) {
        CGFloat x = 0;
        if (!_imgWidth) {
            _imgWidth = (self.frame.size.width-10)/2;
        }
        if (!_imgHeight) {
            _imgHeight = 100;
        }
        for (int i=0; i<[array count]; i++) {
            NSDictionary *dict = array[i];
            CGRect frame = CGRectMake(x, 0, _imgWidth, _imgHeight);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]]];
            [imageView setTag:[[dict objectForKey:@"dataid"] integerValue]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            tap.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:tap];
            [imageView setUserInteractionEnabled:YES];
            [self addSubview:imageView];
            [_idTypes setObject:[dict objectForKey:@"idtype"] forKey:[dict objectForKey:@"dataid"]];
            x+= _imgWidth+10;
        }
    }
    
}

- (void)imageClick:(UITapGestureRecognizer *)tap{
    NSInteger dataid = tap.view.tag;
    if ([self.tapDelegate respondsToSelector:@selector(showDetailWithID:andIdType:)]) {
        NSString *idtype = [_idTypes objectForKey:[NSString stringWithFormat:@"%d",dataid]];
        [self.tapDelegate showDetailWithID:dataid andIdType:idtype];
    }
}
@end
