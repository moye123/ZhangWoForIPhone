//
//  HomeTitleCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTitleCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic)NSString *title;
@property(nonatomic)NSString *detail;
@property(nonatomic)UIImage *image;

@end
