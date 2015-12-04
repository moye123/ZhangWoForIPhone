//
//  AddAddressViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AddAddressViewController.h"

@implementation AddAddressViewController
@synthesize userStatus = _userStatus;
@synthesize nameField = _nameField;
@synthesize phoneField = _phoneField;
@synthesize districtField = _districtField;
@synthesize addressField = _addressField;
@synthesize postcodeField = _postcodeField;
@synthesize provinceList = _provinceList;
@synthesize cityList = _cityList;
@synthesize countyList = _countyList;
@synthesize submitButton = _submitButton;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"添加收货地址"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _userStatus = [ZWUserStatus status];
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _nameField = [self textFieldWithPlaceHolder:@"收货人姓名"];
    _phoneField = [self textFieldWithPlaceHolder:@"联系电话"];
    _districtField = [self textFieldWithPlaceHolder:@"省、市、区、县"];
    _districtField.enabled = NO;
    _addressField = [self textFieldWithPlaceHolder:@"详细地址"];
    _postcodeField = [self textFieldWithPlaceHolder:@"邮政编码"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 100)];
    self.tableView.tableFooterView = footerView;
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, SWIDTH-20, 40)];
    _submitButton.layer.cornerRadius = 20.0;
    _submitButton.layer.masksToBounds = YES;
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"button-bg.png"] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_submitButton];
    
    _madelView = [[DSXModalView alloc] init];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_madelView.contentView addSubview:_pickerView];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)textFieldWithPlaceHolder:(NSString *)placeHolder{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, 40)];
    textField.font = [UIFont systemFontOfSize:16.0];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = placeHolder;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    return textField;
}

- (void)reloadPickerViewComponent:(NSInteger)Component level:(NSInteger)level fid:(NSInteger)fid{
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=district&level=%ld&fid=%ld",(long)level,(long)fid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            if ([array count] > 0) {
                if (Component == 0) {
                    _provinceList = [NSMutableArray arrayWithArray:array];
                    NSInteger fid = [[_provinceList[0] objectForKey:@"id"] integerValue];
                    [self reloadPickerViewComponent:1 level:2 fid:fid];
                }else if (Component == 1){
                    _cityList = [NSMutableArray arrayWithArray:array];
                    NSInteger fid = [[_cityList[0] objectForKey:@"id"] integerValue];
                    [self reloadPickerViewComponent:2 level:3 fid:fid];
                    [_pickerView selectRow:0 inComponent:1 animated:YES];
                }else {
                    _countyList = [NSMutableArray arrayWithArray:array];
                    [_pickerView selectRow:0 inComponent:2 animated:YES];
                }
                
            }else {
                if (Component == 0) {
                    _provinceList = [NSMutableArray array];
                }else if (Component == 1){
                    _cityList = [NSMutableArray array];
                }else {
                    _countyList = [NSMutableArray array];
                }
            }
            [_pickerView reloadComponent:Component];
            NSString *province, *city, *county;
            if ([_provinceList count] > 0) {
                province = [[_provinceList objectAtIndex:[_pickerView selectedRowInComponent:0]] objectForKey:@"name"];
            }else {
                province = @"";
            }
            if ([_cityList count] > 0) {
                city = [[_cityList objectAtIndex:[_pickerView selectedRowInComponent:1]] objectForKey:@"name"];
            }else {
                city = @"";
            }
            if ([_countyList count] > 0) {
                county = [[_countyList objectAtIndex:[_pickerView selectedRowInComponent:2]] objectForKey:@"name"];
            }else {
                county = @"";
            }
            _districtField.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}


- (void)submit{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *name = _nameField.text;
    NSString *phone = _phoneField.text;
    NSString *postcode = _postcodeField.text;
    NSString *district = _districtField.text;
    NSString *address = _addressField.text;
    if ([name length] < 1) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"请输入收件人姓名"];
        return;
    }
    
    if ([phone length] < 7) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"请正确输入联系电话"];
        return;
    }
    
    if ([postcode length] != 6) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"请正确输入邮编"];
        return;
    }
    
    if ([district length] < 1) {
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"请选择区域"];
        return;
    }
    [_submitButton setEnabled:NO];
    [params setObject:@(_userStatus.uid) forKey:@"uid"];
    [params setObject:_userStatus.username forKey:@"username"];
    [params setObject:name forKey:@"name"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:postcode forKey:@"postcode"];
    [params setObject:district forKey:@"district"];
    [params setObject:address forKey:@"address"];
    UIView *loadingView = [[DSXUI sharedUI] showLoadingViewWithMessage:@"保存中.."];
    [_afmanager POST:[SITEAPI stringByAppendingString:@"&mod=address&ac=save"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id returns = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([returns isKindOfClass:[NSDictionary class]]) {
            if ([[returns objectForKey:@"addressid"] integerValue] > 0) {
                [[self.navigationController popViewControllerAnimated:YES] viewDidLoad];
            }
        }else {
            [_submitButton setEnabled:YES];
            [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleWarning Message:@"系统错误"];
        }
        [loadingView removeFromSuperview];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [loadingView removeFromSuperview];
        [_submitButton setEnabled:YES];
        NSLog(@"%@", error);
    }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell addSubview:_nameField];
    }
    if (indexPath.row == 1) {
        [cell addSubview:_phoneField];
    }
    
    if (indexPath.row == 2) {
        [cell addSubview:_postcodeField];
    }
    
    if (indexPath.row == 3) {
        [cell addSubview:_districtField];
    }
    
    if (indexPath.row == 4) {
        [cell addSubview:_addressField];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        [_madelView show];
        [self reloadPickerViewComponent:0 level:1 fid:0];
    }
}

#pragma mark - pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [_provinceList count];
    }else if (component == 1){
        return [_cityList count];
    }else {
        return [_countyList count];
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title;
    if (component == 0) {
        title =  [[_provinceList objectAtIndex:row] objectForKey:@"name"];
    }else if (component == 1){
        title =  [[_cityList objectAtIndex:row] objectForKey:@"name"];
    }else {
        title =  [[_countyList objectAtIndex:row] objectForKey:@"name"];
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger fid;
    if (component == 0) {
        fid = [[[_provinceList objectAtIndex:row] objectForKey:@"id"] integerValue];
        [self reloadPickerViewComponent:1 level:2 fid:fid];
    }else if (component == 1){
        fid = [[[_cityList objectAtIndex:row] objectForKey:@"id"] integerValue];
        [self reloadPickerViewComponent:2 level:3 fid:fid];
    }
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
