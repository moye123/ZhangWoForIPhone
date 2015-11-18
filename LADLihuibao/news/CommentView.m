//
//  CommentView.m
//  YuShuiHePan
//
//  Created by songdewei on 15/10/6.
//  Copyright © 2015年 yushuihepan. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView
@synthesize postView;
@synthesize textView;
@synthesize sendButton;
@synthesize delegate;

- (instancetype)init{
    CGRect rect = [UIScreen mainScreen].bounds;
    _width  = rect.size.width;
    _height = rect.size.height;
    _frame  = CGRectMake(0, _height - 160, _width, 160);
    self = [super initWithFrame:_frame];
    if (self) {
        [self setHidden:YES];
        [self setup];
    }
    return self;
}

- (void)show{
    self.modalView.hidden = NO;
    self.hidden = NO;
    [self.textView becomeFirstResponder];
}
- (void)hide{
    [self endEditing:YES];
    self.modalView.hidden = YES;
    self.hidden = YES;
}
- (void)remove{
    [self.modalView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)setup{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    self.modalView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.modalView.backgroundColor = [UIColor blackColor];
    self.modalView.alpha = 0.5;
    self.modalView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.modalView addGestureRecognizer:tap];
    [window addSubview:self.modalView];
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [window addSubview:self];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, _width-20, 100)];
    self.textView.layer.borderWidth = 0.6;
    self.textView.layer.borderColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00].CGColor;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:16.0];
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(_width-80, 120, 70, 30)];
    self.sendButton.backgroundColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.sendButton setTitle:@"发表" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGRect frame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([self.textView isFirstResponder]) {
        CGRect viewFrame = self.frame;
        viewFrame.origin.y = frame.origin.y - 160;
        self.frame = viewFrame;
    }
}

- (void)keyBoardWillHide:(NSNotification *)notification{
    self.frame = _frame;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.textView.text.length > 0) {
        self.sendButton.tag = 1;
        self.sendButton.backgroundColor = [UIColor redColor];
    }else {
        self.sendButton.tag = 0;
        self.sendButton.backgroundColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
    }
}

- (void)sendComment{
    if (sendButton.tag == 1) {
        [self.delegate sendComment];
    }
}

@end
