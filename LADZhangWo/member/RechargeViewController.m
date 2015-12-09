//
//  RechargeViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RechargeViewController.h"

@implementation RechargeViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"账户充值"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 100)];
    _tableView.tableFooterView = footerView;
    
    UIButton *submitButton = [[DSXUI sharedUI] whiteButtonWithTitle:@"确认充值"];
    [submitButton setFrame:CGRectMake(10, 50, SWIDTH-20, 40)];
    [submitButton.layer setCornerRadius:20.0];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
    
    _amountField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SWIDTH-115, 40)];
    _amountField.placeholder = @"请输入充值金额";
    _amountField.keyboardType = UIKeyboardTypeNumberPad;
    _amountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _index = 0;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submit{
    [_amountField resignFirstResponder];
    [self payByType:@"01"];
}

#pragma mark --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rechargeCell"];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"icon-alipay.png"];
        cell.textLabel.text = @"支付宝支付";
        cell.selected = YES;
    }
    
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"icon-wechat.png"];
        cell.textLabel.text = @"微信支付";
    }
    
    if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"icon-unionpay.png"];
        cell.textLabel.text = @"银联支付";
    }
    
    if (indexPath.row == 3) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"充值金额:";
        cell.accessoryView = _amountField;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 3) {
        // 取消前一个选中的，就是单选啦
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        
        // 选中操作
        UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        // 保存选中的
        _index = indexPath.row;
    }
    [_amountField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_tableView endEditing:YES];
    [_amountField resignFirstResponder];
}

#pragma mark - payment

-(void)payByType:(NSString *)payChannelType{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    IPNPreSignMessageUtil *preSign=[[IPNPreSignMessageUtil alloc]init];
    preSign.appId=@"1449652776799784";
    preSign.mhtOrderNo=[dateFormatter stringFromDate:[NSDate date]];
    preSign.mhtOrderName=@"ass";
    preSign.mhtOrderType=@"01";
    preSign.mhtCurrencyType=@"156";
    preSign.mhtOrderAmt=@"10";
    preSign.mhtOrderDetail=@"dsds";
    preSign.mhtOrderStartTime=[dateFormatter stringFromDate:[NSDate date]];
    preSign.notifyUrl=@"http://192.168.1.154:8080/api/mchnotify";
    preSign.mhtCharset=@"UTF-8";
    preSign.mhtOrderTimeOut=@"3600";
    preSign.mhtReserved=@"test";
    preSign.consumerId=@"IPN00001";
    preSign.consumerName=@"IpaynowCS";
    if (payChannelType!=nil) {
        preSign.payChannelType=payChannelType;
    }
    
    NSString *originStr=[preSign generatePresignMessage];
    
    NSString *orderNo = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1449652776799784" forKey:@"appId"];
    [params setObject:orderNo forKey:@"mhtOrderNo"];
    [params setObject:@"长沃测试订单" forKey:@"mhtOrderName"];
    [params setObject:@"01" forKey:@"mhtOrderType"];
    [params setObject:@"156" forKey:@"mhtCurrencyType"];
    [params setObject:@"10" forKey:@"mhtOrderAmt"];
    [params setObject:@"订单详情" forKey:@"mhtOrderDetail"];
    [params setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"mhtOrderStartTime"];
    [params setObject:@"http://192.168.1.154:8080/api/mchnotify" forKey:@"notifyUrl"];
    [params setObject:@"UTF-8" forKey:@"mhtCharset"];
    [params setObject:@"3600" forKey:@"mhtOrderTimeOut"];
    [params setObject:@"订单测试" forKey:@"mhtReserved"];
    [params setObject:@"IPN00001" forKey:@"consumerId"];
    [params setObject:@"IpaynowCS" forKey:@"consumerName"];
    if (payChannelType) {
        [params setObject:payChannelType forKey:@"payChannelType"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://posp.ipaynow.cn/ZyPluginPaymentTest_PAY/api/pay2.php" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [IpaynowPluginApi setProductIdentifier:@"cn.zhangwoo.zhangwo" andQuantity:1 orderNo:orderNo];
        [IpaynowPluginApi pay:@"" AndScheme:@"IpaynowPluginDemo" viewController:self delegate:self];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

-(void)IpaynowPluginResult:(IPNPayResult)result errCode:(NSString *)errCode errInfo:(NSString *)errInfo{
    NSString *resultString=nil;
    switch (result) {
        case IPNPayResultSuccess:
            resultString=@"支付成功";
            break;
        case IPNPayResultCancel:
            resultString=@"支付被取消";
            break;
        case IPNPayResultFail:
            resultString=[NSString stringWithFormat:@"支付失败:\r\n错误码:%@,异常信息:%@",errCode, errInfo];
            break;
        case IPNPayResultUnknown:
            resultString=[NSString stringWithFormat:@"支付结果未知:%@",errInfo];
            break;
            
        default:
            break;
    }
}

@end
