//
//  ChannelListView.m
//  LADZhangWo
//
//  Created by Apple on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChannelListView.h"

@implementation ChannelListView
@synthesize collectionView = _collectionView;
@synthesize channelList = _channelList;
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"channelCell"];
        [self addSubview:_collectionView];
        
        _cellWidth   = (frame.size.width/4)-1;
        _cellHeight  = 90;
        _channelList = [[NSUserDefaults standardUserDefaults] arrayForKey:@"channelList"];
        [_collectionView reloadData];
        
        [[AFHTTPRequestOperationManager sharedManager] GET:[SITEAPI stringByAppendingString:@"&c=channel"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                if ([responseObject count] > 0) {
                    _channelList = responseObject;
                    [[NSUserDefaults standardUserDefaults] setObject:_channelList forKey:@"channelList"];
                    [_collectionView reloadData];
                }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_channelList count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.001;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellWidth, _cellHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"channelCell" forIndexPath:indexPath];
    NSDictionary *channel = [_channelList objectAtIndex:indexPath.row];
    if (cell) {
        for (UIView *subview in cell.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_cellWidth-50)/2, 10, 50, 50)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[channel objectForKey:@"channelimage"]]];
    [cell addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, _cellWidth, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = [channel objectForKey:@"channelname"];
    [cell addSubview:titleLabel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *channel = [_channelList objectAtIndex:indexPath.row];
    if ([_delegate respondsToSelector:@selector(channelView:didSelectItemAtTag:)]) {
        [_delegate channelView:self didSelectItemAtTag:[channel objectForKey:@"channeltag"]];
    }
}

@end
