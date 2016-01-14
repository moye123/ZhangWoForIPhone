//
//  GoodsListViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsDetailViewController.h"
#import "MyFavoriteViewController.h"
#import "MyMessageViewController.h"

@implementation GoodsListViewController
@synthesize catid = _catid;
@synthesize goodsList = _goodsList;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    _goodsList = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[GoodsItemCell class] forCellReuseIdentifier:@"goodsCell"];
    
    _refreshControl = [[ZWRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refreshControl;
    
    _pullUpView = [[ZWPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    self.tableView.tableFooterView = _pullUpView;
    
    NSString *key = [NSString stringWithFormat:@"googsList_%ld",(long)_catid];
    [self reloadTableViewWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
    [self refresh];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showPopMenu{
    [_popMenu toggle];
}

- (void)dropDownMenu:(DSXDropDownMenu *)dropDownMenu didSelectedAtCellItem:(UITableViewCell *)cellItem withData:(NSDictionary *)data{
    [dropDownMenu slideUp];
    NSString *action = [data objectForKey:@"action"];
    if ([action isEqualToString:@"shownotice"]) {
        MyMessageViewController *messageView = [[MyMessageViewController alloc] init];
        [self.navigationController pushViewController:messageView animated:YES];
    }
    
    if ([action isEqualToString:@"showfavorite"]) {
        MyFavoriteViewController *favorView = [[MyFavoriteViewController alloc] init];
        [self.navigationController pushViewController:favorView animated:YES];
    }
    
    if ([action isEqualToString:@"showhome"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.tabBarController setSelectedIndex:0];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_popMenu slideUp];
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
    NSDictionary *coordinateParam = [DSXUtil getLocation];
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=goods&a=showlist&catid=%ld&page=%d",(long)_catid,_page];
    
    [[AFHTTPSessionManager sharedManager] GET:urlString parameters:coordinateParam progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if ([responseObject count] > 0) {
                if (_isRefreshing) {
                    NSString *key = [NSString stringWithFormat:@"googsList_%ld",(long)_catid];
                    [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:key];
                }
                [self reloadTableViewWithArray:responseObject];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            [_goodsList removeAllObjects];
            [self.tableView reloadData];
        }
        
        for (NSDictionary *dict in array) {
            [_goodsList addObject:dict];
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
    return [_goodsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SWIDTH*0.35+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *goodsData = [_goodsList objectAtIndex:indexPath.row];
    GoodsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell"];
    cell.imageWidth = SWIDTH*0.35;
    cell.goodsData  = goodsData;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSDictionary *goodsData = [_goodsList objectAtIndex:indexPath.row];
    GoodsDetailViewController *detailController = [[GoodsDetailViewController alloc] init];
    detailController.hidesBottomBarWhenPushed = YES;
    detailController.goodsid = [[goodsData objectForKey:@"id"] integerValue];
    detailController.title = [goodsData objectForKey:@"name"];
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
