//
//  AddAddressViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface AddAddressViewController : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    @private
    DSXModalView *_madelView;
    UIPickerView *_pickerView;
}

@property(nonatomic,retain)UITextField *nameField;
@property(nonatomic,retain)UITextField *phoneField;
@property(nonatomic,retain)UITextField *districtField;
@property(nonatomic,retain)UITextField *addressField;
@property(nonatomic,retain)UITextField *postcodeField;
@property(nonatomic,retain)NSMutableArray *provinceList;
@property(nonatomic,retain)NSMutableArray *cityList;
@property(nonatomic,retain)NSMutableArray *countyList;
@property(nonatomic,retain)UIButton *submitButton;

@end
