//
//  TitleCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic)UIImage *image;
@property(nonatomic)NSString *title;
@property(nonatomic)NSString *detail;

@end
