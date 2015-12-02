//
//  HomeCategoryView.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HomeCategoryView.h"

@implementation HomeCategoryView
@synthesize categoryList;
@synthesize collectionView = _collectionView;
@synthesize categoryDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect frame = self.frame;
        frame.origin.y = 10;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:@"CategoryCell"];
        
        [self reloadCollectionViewWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"channels"]];
        [self loadData];
    }
    return self;
}

- (void)loadData{
    NSString *urlString = [SITEAPI stringByAppendingString:@"&mod=channel"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        if ([data length] > 2) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"channels"];
            [self reloadCollectionViewWithData:data];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

- (void)reloadCollectionViewWithData:(NSData *)data{
    if ([data length] > 2) {
        id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            self.categoryList = array;
            [self.collectionView reloadData];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.categoryList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.frame.size.width)/5, 85);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.categoryList objectAtIndex:indexPath.row];
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    [cell setData:dict];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *category = [self.categoryList objectAtIndex:indexPath.row];
    if ([self.categoryDelegate respondsToSelector:@selector(showCategoryWithTag:)]) {
        [self.categoryDelegate showCategoryWithTag:[category objectForKey:@"channeltag"]];
    }
}

@end
