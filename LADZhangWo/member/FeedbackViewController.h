//
//  FeedbackViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface FeedbackViewController : UIViewController<UITextViewDelegate>{
    @private
    UILabel *_placeHolder;
}

@property(nonatomic,retain)UITextView *textView;
@property(nonatomic,retain)ZWUserStatus *userStatus;

@end
