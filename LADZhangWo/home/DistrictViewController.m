//
//  DistrictViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DistrictViewController.h"

@implementation DistrictViewController
@synthesize fid;
@synthesize districtList;
@synthesize delegate;
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (!self.fid) {
        self.fid = 0;
        self.title = @"选择省份";
    }else {
        self.title = @"选择城市";
    }
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=district&a=showlist&fid=%d",self.fid];
    [[AFHTTPSessionManager sharedManager] GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.districtList = responseObject;
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -
- (void)back{
    if (self.fid > 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.districtList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSDictionary *district = [self.districtList objectAtIndex:indexPath.row];
    cell.textLabel.text = [district objectForKey:@"name"];
    if (self.fid == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *district = [self.districtList objectAtIndex:indexPath.row];
    if (self.fid > 0) {
        if ([self.delegate respondsToSelector:@selector(locationChangeWithName:)]) {
            [self.delegate locationChangeWithName:[district objectForKey:@"name"]];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        DistrictViewController *districtController = [[DistrictViewController alloc] init];
        districtController.delegate = self.delegate;
        districtController.fid = [[district objectForKey:@"id"] intValue];
        [self.navigationController pushViewController:districtController animated:YES];
    }
    
}


@end
