//
//  ShowAdModel.h
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ShowAdModel : NSObject

+ (instancetype)sharedModel;
- (void)showAdWithData:(NSDictionary *)data fromViewController:(UIViewController *)vc;

@end
