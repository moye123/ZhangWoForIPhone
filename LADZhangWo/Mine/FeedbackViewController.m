//
//  FeedbackViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "FeedbackViewController.h"

@implementation FeedbackViewController
@synthesize textView = _textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"反馈建议"];
    [self.view setBackgroundColor:[UIColor backColor]];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    [sendButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = sendButton;
    
    _textView = [[UITextView alloc] initWithFrame:self.view.frame];
    _textView.delegate = self;
    _textView.scrollEnabled = NO;
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.textColor = [UIColor blackColor];
    _textView.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 5);
    _textView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    [self.textView becomeFirstResponder];
    
    _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    _placeHolder.text = @"请输入反馈意见";
    _placeHolder.textColor = [UIColor grayColor];
    _placeHolder.font = [UIFont systemFontOfSize:16.0f];
    [_placeHolder sizeToFit];
    [_textView addSubview:_placeHolder];
    [self.view addSubview:_textView];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send{
    [self.textView resignFirstResponder];
    NSString *message = self.textView.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([ZWUserStatus sharedStatus].uid) forKey:@"uid"];
    [params setObject:[ZWUserStatus sharedStatus].username forKey:@"username"];
    [params setObject:message forKey:@"message"];
    if ([message length] > 0) {
        [[DSXHttpManager sharedManager] POST:@"&c=feedback&a=save" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"发送成功，谢谢你的支持"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@", error);
        }];

    }else {
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"请输入内容"];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.textView.text.length > 0) {
        _placeHolder.hidden = YES;
    }else {
        _placeHolder.hidden = NO;
    }
}
@end