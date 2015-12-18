//
//  TravelListViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TravelListViewController.h"
#import "TravelDetailViewController.h"

@implementation TravelListViewController
@synthesize catid;
@synthesize travelArray;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    //实例化afnetworking manager
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //初始化列表数组
    self.travelArray = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //下拉刷新
    _refreshControl = [[ZWRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refreshControl;
    
    //上拉加载更多
    _pullUpView = [[ZWPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    self.tableView.tableFooterView = _pullUpView;
    
    [self showTableViewWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"travelList"]];
    [self refresh];
    
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark
- (void)loadData{
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=travel&ac=showlist&catid=%ld&page=%d", (long)self.catid,_page];
    [_afmanager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        if ([data length] > 0) {
            id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([array isKindOfClass:[NSArray class]]) {
                if (_isRefreshing) {
                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"travelList"];
                    
                }
                [self showTableViewWithArray:array];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)showTableViewWithArray:(NSArray *)array{
    
    if ([array count]>0) {
        if (_isRefreshing) {
            [self.travelArray removeAllObjects];
            [self.tableView reloadData];
        }
        
        for (NSDictionary *item in array) {
            [self.travelArray addObject:item];
        }
        [self.tableView reloadData];
    }
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    [_pullUpView endLoading];
    if ([array count] >= 20) {
        _pullUpView.hidden = NO;
    }else{
        _pullUpView.hidden = YES;
    }
    
    if (_tipsLabel) {
        [_tipsLabel removeFromSuperview];
    }
    if ([self.travelArray count] == 0) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH-200)/2, 100, 200, 30)];
        _tipsLabel.text = @"此板块暂无数据..";
        _tipsLabel.font = [UIFont systemFontOfSize:14.0];
        _tipsLabel.textColor = [UIColor grayColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_tipsLabel];
    }
}

- (void)refresh{
    _page = 1;
    _isRefreshing = YES;
    [self loadData];
}

- (void)loadMore{
    _page++;
    _isRefreshing = NO;
    [self loadData];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.travelArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"travelCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"travelCell"];
    }else{
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    NSDictionary *travelItem = [self.travelArray objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 140)];
    //imageView.layer.cornerRadius = 10.0;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[travelItem objectForKey:@"pic"]];
    [cell.contentView addSubview:imageView];
    
    //显示标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, SWIDTH-76, 40)];
    titleLabel.text = [travelItem objectForKey:@"title"];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = [UIColor whiteColor];
    //titleLabel.numberOfLines = 2;
    [titleLabel sizeToFit];
    [cell.contentView addSubview:titleLabel];
    
    //显示位置信息
    if ([travelItem objectForKey:@"province"]) {
        UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 110, 20, 20)];
        [locationIcon setImage:[UIImage imageNamed:@"icon-location.png"]];
        [cell.contentView addSubview:locationIcon];
        
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 108, SWIDTH-60, 20)];
        locationLabel.text = [NSString stringWithFormat:@"%@  %@",[travelItem objectForKey:@"province"],[travelItem objectForKey:@"city"]];
        locationLabel.font = [UIFont systemFontOfSize:12.0];
        locationLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:locationLabel];
    }
    

    cell.tag = [[travelItem objectForKey:@"id"] intValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *travelItem = [self.travelArray objectAtIndex:indexPath.row];
    TravelDetailViewController *detailController = [[TravelDetailViewController alloc] init];
    detailController.travelID = [[travelItem objectForKey:@"id"] intValue];
    detailController.title = [travelItem objectForKey:@"title"];
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat diffHeight = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
    if (diffHeight > 100) {
        if (_pullUpView.hidden == NO) {
            [_pullUpView beginLoading];
            [self loadMore];
        }
        
    }
}

@end
