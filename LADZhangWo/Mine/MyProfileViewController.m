//
//  MyProfileViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyAddressViewController.h"

@implementation MyProfileViewController
@synthesize tableView = _tableView;
@synthesize profile   = _profile;

- (instancetype)init{
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        [self.view addSubview:_tableView];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"个人资料"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    UIView *loadingView = [[DSXUI standardUI] showLoadingViewWithMessage:@"正在加载.."];
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=profile&a=showdetail&uid=%ld",(long)[ZWUserStatus sharedStatus].uid];
    [[AFHTTPSessionManager sharedManager] GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _profile = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            _tableView.hidden = NO;
            [_tableView reloadData];
            [loadingView removeFromSuperview];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"profileCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"用户名";
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = [ZWUserStatus sharedStatus].username;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"头像";
            cell.detailTextLabel.text = @"       ";
            UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, 30, 30)];
            [avatar sd_setImageWithURL:[NSURL URLWithString:[ZWUserStatus sharedStatus].userpic]];
            avatar.layer.cornerRadius = 15.0;
            avatar.layer.masksToBounds = YES;
            [cell.detailTextLabel addSubview:avatar];
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"生日";
            cell.detailTextLabel.text = [_profile objectForKey:@"birthday"];
            cell.detailTextLabel.tag = 101;
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"性别";
            if ([[_profile objectForKey:@"usersex"] integerValue] == 1) {
                cell.detailTextLabel.text = @"男";
            }else {
                cell.detailTextLabel.text = @"女";
            }
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = @"收货地址管理";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
            [actionSheet addButtonWithTitle:@"相册"];
            [actionSheet addButtonWithTitle:@"拍照"];
            [actionSheet addButtonWithTitle:@"取消"];
            [actionSheet setCancelButtonIndex:2];
            [actionSheet setDelegate:self];
            [actionSheet setTag:101];
            [actionSheet showInView:self.view];
        }
        
        if (indexPath.row == 2) {
            _datePickerView = [[DSXModalView alloc] init];
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
            _datePicker.datePickerMode = UIDatePickerModeDate;
            [_datePickerView.contentView addSubview:_datePicker];
            
            UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [doneButton setTitle:@"确定" forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [doneButton setFrame:CGRectMake(SWIDTH-50, 10, 40, 30)];
            [doneButton addTarget:self action:@selector(setBirthDay) forControlEvents:UIControlEventTouchUpInside];
            [_datePickerView.contentView addSubview:doneButton];
            [_datePickerView show];
        }
        
        if (indexPath.row == 3) {
            UIActionSheet *sexSheet = [[UIActionSheet alloc] init];
            [sexSheet addButtonWithTitle:@"男"];
            [sexSheet addButtonWithTitle:@"女"];
            [sexSheet addButtonWithTitle:@"取消"];
            [sexSheet setCancelButtonIndex:2];
            [sexSheet showInView:self.view];
            [sexSheet setTag:102];
            [sexSheet setDelegate:self];
        }
        
        if (indexPath.row == 4) {
            MyAddressViewController *addressView = [[MyAddressViewController alloc] init];
            [self.navigationController pushViewController:addressView animated:YES];
        }
    }
}

- (void)setBirthDay{
    NSDate *date = [_datePicker date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([ZWUserStatus sharedStatus].uid) forKey:@"uid"];
    [params setObject:[ZWUserStatus sharedStatus].username forKey:@"username"];
    [params setObject:[formater stringFromDate:date] forKey:@"profilenew[birthday]"];
    [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=profile&a=update"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"uid"] integerValue] == [ZWUserStatus sharedStatus].uid) {
                [_profile setObject:[formater stringFromDate:date] forKey:@"birthday"];
                [_datePickerView hide];
                [_tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)setSex:(NSInteger)sex{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([ZWUserStatus sharedStatus].uid) forKey:@"uid"];
    [params setObject:[ZWUserStatus sharedStatus].username forKey:@"username"];
    [params setObject:@(sex) forKey:@"profilenew[usersex]"];
    
    [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=profile&a=update"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"uid"] intValue] == [ZWUserStatus sharedStatus].uid) {
                [_profile setObject:@(sex) forKey:@"usersex"];
                [_tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 101) {
        UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
        pickController.delegate = self;
        [pickController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        if (buttonIndex == 0) {
            pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickController animated:YES completion:nil];
        }
        if (buttonIndex == 1) {
            pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickController animated:YES completion:nil];
        }
        
    }
    //性别选择
    if (actionSheet.tag == 102) {
        if (buttonIndex == 0) {
            [self setSex:1];
        }
        if (buttonIndex == 1) {
            [self setSex:0];
        }
    }
}

#pragma mark - imagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIView *loadingView = [[DSXUI standardUI] showLoadingViewWithMessage:@"正在上传照片.."];
    UIImage *tmpImage = [self imageCompressForSize:[info objectForKey:UIImagePickerControllerOriginalImage] targetSize:CGSizeMake(1000, 1000)];
    NSData *imageData = UIImageJPEGRepresentation(tmpImage, 1.0);
    NSString *filePath = [[DSXSandboxHelper tmpPath] stringByAppendingString:@"/tmp_image.jpg"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    if ([imageData writeToFile:filePath atomically:YES]) {
        NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                                 @"username":[ZWUserStatus sharedStatus].username};
        [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=profile&a=setavatar"] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileURL:fileURL name:@"filedata" error:nil];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [loadingView removeFromSuperview];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([returns isKindOfClass:[NSDictionary class]]) {
                [[ZWUserStatus sharedStatus] setUserpic:[[ZWUserStatus sharedStatus].userpic stringByAppendingFormat:@"?%d",rand()]];
                [[ZWUserStatus sharedStatus] update];
                [_tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserImageChangedNotification object:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [loadingView removeFromSuperview];
            [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"上传失败"];
        }];
    }
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context， 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
    
}

-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end
