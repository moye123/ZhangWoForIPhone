//
//  TravelViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TravelViewController.h"
#import "UIImageView+WebCache.h"
#import "TravelDetailViewController.h"
#import "RefreshHeadView.h"

@implementation TravelViewController
@synthesize mainTableView;
@synthesize travelArray;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"六盘水旅游"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack2 target:self action:@selector(back)];

    self.travelArray = [NSMutableArray array];
    
    CGRect frame = self.view.frame;
    //frame.size.height = SHEIGHT - 66;
    self.mainTableView = [[UITableView alloc] initWithFrame:frame];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    //下拉刷新
    _refreshControl = [[LHBRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.refreshControl = _refreshControl;
    tableViewController.tableView = self.mainTableView;
    
    //上拉加载更多
    _pullUpView = [[LHBPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    self.mainTableView.tableFooterView = _pullUpView;
    
    [self showTableViewWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"travelList"]];
    [self refresh];
    
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark 
- (void)loadData{
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=travel&ac=showlist&page=%d",_page];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
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
            [self.mainTableView reloadData];
        }
        
        for (NSDictionary *item in array) {
            [self.travelArray addObject:item];
        }
        [self.mainTableView reloadData];
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
    return 100;
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
    
    NSDictionary *travelItem = [self.travelArray objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 80)];
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[travelItem objectForKey:@"pic"]];
    [cell.contentView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, SWIDTH-100, 40)];
    titleLabel.text = [travelItem objectForKey:@"title"];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.numberOfLines = 2;
    [titleLabel sizeToFit];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 48, SWIDTH-100, 20)];
    priceLabel.text = [NSString stringWithFormat:@"票价: %@",[travelItem objectForKey:@"fare"]];
    priceLabel.font = [UIFont systemFontOfSize:14.0];
    [cell.contentView addSubview:priceLabel];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 70, SWIDTH-100, 20)];
    locationLabel.text = [NSString stringWithFormat:@"%@  %@",[travelItem objectForKey:@"province"],[travelItem objectForKey:@"city"]];
    locationLabel.font = [UIFont systemFontOfSize:12.0];
    locationLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:locationLabel];
    
    cell.tag = [[travelItem objectForKey:@"id"] intValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    TravelDetailViewController *detailController = [[TravelDetailViewController alloc] init];
    detailController.travelID = cell.tag;
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