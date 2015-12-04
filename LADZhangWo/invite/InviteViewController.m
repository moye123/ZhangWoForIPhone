//
//  InviteViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "InviteViewController.h"
#import "IncomeView.h"

@implementation InviteViewController
@synthesize userStatus;
@synthesize inviteCode;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"邀请好友"];
    [self.navigationController.tabBarItem setTitle:@"邀请"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.userStatus = [ZWUserStatus status];
    _inviteKey = [NSString stringWithFormat:@"inviteCode_%ld",(long)self.userStatus.uid];
    self.inviteCode = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:_inviteKey];
    if ([self.inviteCode length] < 8) {
        [self getInviteCode];
    }
    
    
    IncomeView *myIncomeView = [[IncomeView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    [self.view addSubview:myIncomeView];
    
    //获取邀请码
    UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setFrame:CGRectMake((SWIDTH-280)/2, 230, 280, 36)];
    [codeButton setImage:[UIImage imageNamed:@"button-invitecode.png"] forState:UIControlStateNormal];
    [codeButton setImage:[UIImage imageNamed:@"button-invitecode-on.png"] forState:UIControlStateHighlighted];
    //[codeButton addTarget:self action:@selector(getInviteCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeButton];
    
    //邀请好友
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteButton setFrame:CGRectMake((SWIDTH-280)/2, 296, 280, 36)];
    [inviteButton setImage:[UIImage imageNamed:@"button-invite.png"] forState:UIControlStateNormal];
    [inviteButton setImage:[UIImage imageNamed:@"button-invite-on.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:inviteButton];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH-270)/2, 346, 270, 50)];
    tipsLabel.text = @"提示:邀请你的好友注册后，你将获得3元收益";
    tipsLabel.numberOfLines = 2;
    tipsLabel.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:tipsLabel];
}

#pragma mark -
- (void)getInviteCode{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[SITEAPI stringByAppendingFormat:@"&mod=invite&ac=getcode&uid=%ld",(long)self.userStatus.uid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id dictionay = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dictionay isKindOfClass:[NSDictionary class]]) {
            self.inviteCode = [dictionay objectForKey:@"invitecode"];
            [[NSUserDefaults standardUserDefaults] setObject:self.inviteCode forKey:_inviteKey];
            //NSLog(@"%@",self.inviteCode);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
