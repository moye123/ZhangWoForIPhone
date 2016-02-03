//
//  MyMessageViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyMessageViewController.h"
 
@implementation MyMessageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"消息中心"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[NoticeViewCell class] forCellReuseIdentifier:@"noticeCell"];
    [self didStartRefreshing:nil];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    [super didStartRefreshing:refreshView];
    self.currentPage = 1;
    self.isRefreshing = YES;
    [self loadDataSource];
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    [super didStartLoading:refreshView];
    self.currentPage++;
    self.isRefreshing = NO;
    [self loadDataSource];
}

#pragma mark - loadDataSource

- (void)loadDataSource{
    NSString *urlString = [NSString stringWithFormat:@"&c=notification&a=showlist&uid=%ld&page=%ld",(long)[ZWUserStatus sharedStatus].uid,(long)self.currentPage];
    [[DSXHttpManager sharedManager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                self.moreData = [responseObject objectForKey:@"data"];
                if ([self.moreData count] > 0) {
                    if (self.isRefreshing) {
                        self.isRefreshing = NO;
                        [self.dataList removeAllObjects];
                        [self.tableView reloadData];
                    }
                    for (NSDictionary *dict in self.moreData) {
                        [self.dataList addObject:dict];
                    }
                    [self.tableView reloadData];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
    NSDictionary *notice = [self.dataList objectAtIndex:indexPath.row];
    [cell setNoticeData:notice];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

@end
