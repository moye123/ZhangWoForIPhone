//
//  GoodsListViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GoodsListViewController.h"
#import "UIImageView+WebCache.h"
#import "GoodsDetailViewController.h"

@implementation GoodsListViewController
@synthesize catid;
@synthesize goodsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    self.goodsArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _refreshControl = [[LHBRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refreshControl;
    
    _pullUpView = [[LHBPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    self.tableView.tableFooterView = _pullUpView;
    
    NSString *key = [NSString stringWithFormat:@"googsList_%d",self.catid];
    [self reloadTableViewWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
    [self refresh];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 
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
- (void)loadData{
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=goods&ac=showlist&catid=%d&page=%d",self.catid,_page];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        if ([data length]>2) {
            id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([array isKindOfClass:[NSArray class]]) {
                if ([array count] > 0) {
                    if (_isRefreshing) {
                        NSString *key = [NSString stringWithFormat:@"googsList_%d",self.catid];
                        [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
                    }
                    [self reloadTableViewWithArray:array];
                }else{
                    
                }
                
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            [self.goodsArray removeAllObjects];
            [self.tableView reloadData];
        }
        
        for (NSDictionary *dict in array) {
            [self.goodsArray addObject:dict];
        }
        [self.tableView reloadData];
    }
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    [_pullUpView endLoading];
    if ([array count] >= 20) {
        _pullUpView.hidden = NO;
    }else {
        _pullUpView.hidden = YES;
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.goodsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsCell"];
    }else {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    NSDictionary *goods = [self.goodsArray objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 80)];
    imageView.layer.cornerRadius = 3.0;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[goods objectForKey:@"pic"]]];
    [cell.contentView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, SWIDTH-130, 20)];
    titleLabel.text = [goods objectForKey:@"name"];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    [titleLabel sizeToFit];
    [cell.contentView addSubview:titleLabel];
    
    NSInteger starnum = [[goods objectForKey:@"score"] integerValue];
    DSXStarView *starView = [[DSXStarView alloc] initWithStar:starnum];
    starView.frame = CGRectMake(120, 35, starView.frame.size.width, starView.frame.size.height);
    [cell.contentView addSubview:starView];
    
    //价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 73, 80, 18)];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",[goods objectForKey:@"price"]];
    priceLabel.textColor = [UIColor colorWithHexString:@"0x3DC0AD"];
    priceLabel.font = [UIFont systemFontOfSize:18.0];
    
    cell.tag = [[goods objectForKey:@"id"] integerValue];
    [cell.contentView addSubview:priceLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSDictionary *goods = [self.goodsArray objectAtIndex:indexPath.row];
    GoodsDetailViewController *detailController = [[GoodsDetailViewController alloc] init];
    detailController.hidesBottomBarWhenPushed = YES;
    detailController.goodsid = cell.tag;
    detailController.title = [goods objectForKey:@"name"];
    [self.navigationController pushViewController:detailController animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
