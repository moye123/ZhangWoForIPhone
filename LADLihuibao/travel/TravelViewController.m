//
//  TravelViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TravelViewController.h"
#import "TravelListViewController.h"

@implementation TravelViewController
@synthesize categoryList;
@synthesize slideView;

- (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"旅游"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBackBlack target:self action:@selector(back)];
    
    self.slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 150)];
    NSString *sliderAPI = [SITEAPI stringByAppendingString:@"&mod=travel&ac=showlist&pagesize=3"];
    AFHTTPRequestOperationManager *slideManager = [AFHTTPRequestOperationManager manager];
    slideManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [slideManager GET:sliderAPI parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in array) {
                [mutableArray addObject:@{@"id":[dict objectForKey:@"id"],@"pic":[dict objectForKey:@"pic"]}];
            }
            //NSLog(@"%@",mutableArray);
            self.slideView.picList = [NSArray arrayWithArray:mutableArray];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    self.categoryList = [NSArray array];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"travelItem"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Slider"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor backColor];
    
    //从服务器读取分类数据
    NSString *urlString = [SITEAPI stringByAppendingString:@"&mod=travel&ac=getcategory"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            self.categoryList = array;
            [self.collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.categoryList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 95);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"travelItem" forIndexPath:indexPath];
    if (cell) {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    NSDictionary *category = [self.categoryList objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 66, 66)];
    [imageView sd_setImageWithURL:[category objectForKey:@"pic"]];
    [cell.contentView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 100, 20)];
    titleLabel.text = [category objectForKey:@"cname"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *category = [self.categoryList objectAtIndex:indexPath.row];
    TravelListViewController *listController = [[TravelListViewController alloc] init];
    listController.catid = [[category objectForKey:@"catid"] intValue];
    listController.title = [category objectForKey:@"cname"];
    [self.navigationController pushViewController:listController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SWIDTH, 150);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Slider" forIndexPath:indexPath];
        [reuseView addSubview:self.slideView];
        
    }
    return reuseView;
}


@end