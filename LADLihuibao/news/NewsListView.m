//
//  NewsListView.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewsListView.h"
#import "UIImageView+WebCache.h"

@implementation NewsListView
@synthesize catid;
@synthesize newsArray;
@synthesize showNewsDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        _refreshControl = [[LHBRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        UITableViewController *tableViewController = [[UITableViewController alloc] init];
        tableViewController.tableView = self;
        tableViewController.refreshControl = _refreshControl;
        [_refreshControl addTarget:self action:@selector(reFreshTableView) forControlEvents:UIControlEventValueChanged];
        
        _pullUpView = [[LHBPullUpView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        _pullUpView.hidden = YES;
        self.tableFooterView = _pullUpView;
        
        self.delegate = self;
        self.dataSource = self;
        self.newsArray = [NSMutableArray array];
        
        NSString *key = [NSString stringWithFormat:@"newsList_%d",self.catid];
        [self showTableViewWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
        [self loadData];
    }
    return self;
}

- (void)loadData{
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=post&ac=showlist&catid=%d&page=%d",self.catid,_page];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        if ([data length] > 2) {
            id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([array isKindOfClass:[NSArray class]]) {
                NSString *key = [NSString stringWithFormat:@"newsList_%d",self.catid];
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
                [self performSelectorOnMainThread:@selector(showTableViewWithArray:) withObject:array waitUntilDone:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)showTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            [self.newsArray removeAllObjects];
            [self reloadData];
        }
        for (NSDictionary *newsItem in array) {
            [self.newsArray addObject:newsItem];
        }
        [self reloadData];
    }
    if ([array count] >= 20) {
        _pullUpView.hidden = NO;
    }else {
        _pullUpView.hidden = YES;
    }
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    [_pullUpView endLoading];
}

- (void)reFreshTableView{
    _page = 1;
    _isRefreshing = YES;
    [self loadData];
}

- (void)loadMore{
    _page++;
    _isRefreshing = NO;
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 265;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsCell"];
    }else{
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    NSDictionary *newsItem = [self.newsArray objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, SWIDTH-16, 140)];
    imageView.layer.cornerRadius = 10.0;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[newsItem objectForKey:@"pic"]]];
    [cell.contentView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 155, SWIDTH-16, 32)];
    titleLabel.text = [newsItem objectForKey:@"title"];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.numberOfLines = 2;
    [titleLabel sizeToFit];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 200, SWIDTH-16, 40)];
    summaryLabel.text = [newsItem objectForKey:@"summary"];
    summaryLabel.textColor = [UIColor grayColor];
    summaryLabel.font = [UIFont systemFontOfSize:14.0];
    summaryLabel.numberOfLines = 2;
    [summaryLabel sizeToFit];
    [cell.contentView addSubview:summaryLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 238, 100, 20)];
    timeLabel.text = [newsItem objectForKey:@"pubtime"];
    timeLabel.font = [UIFont systemFontOfSize:12.0];
    timeLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:timeLabel];
    
    UIImageView *browseView = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH-100, 240, 16, 16)];
    [browseView setImage:[UIImage imageNamed:@"icon-browse.png"]];
    [cell.contentView addSubview:browseView];
    
    UILabel *viewnum = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH-80, 238, 30, 20)];
    viewnum.text = [newsItem objectForKey:@"viewnum"];
    viewnum.textColor = [UIColor grayColor];
    viewnum.font = [UIFont systemFontOfSize:12.0];
    [cell.contentView addSubview:viewnum];
    
    UIImageView *commentView = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH-50, 242, 14, 14)];
    [commentView setImage:[UIImage imageNamed:@"icon-comments.png"]];
    [cell.contentView addSubview:commentView];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH-30, 238, 30, 20)];
    commentLabel.text = [newsItem objectForKey:@"commentnum"];
    commentLabel.textColor = [UIColor grayColor];
    commentLabel.font = [UIFont systemFontOfSize:12.0];
    [cell.contentView addSubview:commentLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSInteger newsID = [[[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    if ([self.showNewsDelegate respondsToSelector:@selector(showNewsDetailWithID:)]) {
        [self.showNewsDelegate showNewsDetailWithID:newsID];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat diffHeight = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
    if (diffHeight > 50) {
        if (_pullUpView.hidden == NO) {
            [_pullUpView beginLoading];
            [self loadMore];
        }
        
    }
}

@end
