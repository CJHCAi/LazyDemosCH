//
//  ModifyAddressViewController.m
//  CheLian
//
//  Created by imac on 16/5/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ModifyAddressViewController.h"
#import "ModifyAddresstableViewCell.h"
#import "AreaChooseView.h"

@interface ModifyAddressViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

/**
 *  地区选择
 */
@property (strong,nonatomic) AreaChooseView *pickerView;
/**
 *  地区信息
 */
@property (strong,nonatomic) NSString *addStr;


@end

@implementation ModifyAddressViewController

-(void)viewWillAppear:(BOOL)animated{
    _addStr=_areaAdd;
  
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"修改收货地址";
}

- (void)initView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-110-46)];
    [self.view addSubview:_tableView];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor = LH_RGBCOLOR(230, 230, 230);
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectYH(_tableView), __kWidth, 46)];
    [self.view addSubview:addBtn];
    addBtn.backgroundColor = [UIColor redColor];
    addBtn.titleLabel.font = MFont(15);
    [addBtn setTitle:@"保存地址" forState:BtnNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [addBtn addTarget:self action:@selector(saveAction) forControlEvents:BtnTouchUpInside];
    
}
/**
 *  选择视图
 */
- (void)showPick{
    WK(weakSelf)
    _pickerView = [[AreaChooseView alloc]initWithAreaFrame:CGRectMake(0, __kHeight-296, __kWidth, 250)];
    [self.view addSubview:_pickerView];
    _pickerView.backgroundColor = LH_RGBCOLOR(200, 200, 210);
    _pickerView.returntextfileBlock=^(NSString *data){
        _addStr =data;
        [ weakSelf.tableView reloadData];
        NSArray *arr = [data componentsSeparatedByString:@" "];
        weakSelf.modifyAddressModel.Province =arr[0];
        weakSelf.modifyAddressModel.city = arr[1];
        weakSelf.modifyAddressModel.area = arr[2];
    };
    
}

#pragma mark -UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModifyAddresstableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModifyAddresstableViewCell"];
    if (!cell) {
        cell = [[ModifyAddresstableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModifyAddresstableViewCell"];
    }
    cell.detailTV.delegate =self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTV.tag =indexPath.row+22;
    if (indexPath.row ==0) {
        cell.titleLb.text = @"收货人";
        cell.detailTV.text = _modifyAddressModel.realname;
        cell.detailTV.keyboardType = UIKeyboardTypeDefault;
    }
    if (indexPath.row ==1){
        cell.titleLb.text = @"手机号码";
        cell.detailTV.text = _modifyAddressModel.mobile;
         cell.detailTV.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.row ==2){
        cell.titleLb.text = @"省市地区";
        cell.detailTV.text = _addStr;
    }
    if (indexPath.row ==3){
        cell.detailTV.hidden = YES;
        cell.addressTF.hidden = NO;
        cell.titleLb.text = @"详细地址";
        cell.addressTF.text = _modifyAddressModel.address;
        cell.addressTF.delegate = self;
    }
    if (indexPath.row ==4){
        cell.titleLb.text = @"设为默认地址";
        cell.detailTV.hidden = YES;
        cell.chooseIV.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if (_isDefalut) {
            cell.chooseIV.image = MImage(@"默认.png");
        }else{
            cell.chooseIV.image = MImage(@"非默认.png");
        }
    }
    if (indexPath.row==5) {
        cell.titleLb.text = @"邮编";
        cell.detailTV.text = _modifyAddressModel.zipcode;
        cell.detailTV.keyboardType = UIKeyboardTypeDefault;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        return 80;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==4) {
        _isDefalut = !_isDefalut;
        [_tableView reloadData];
        if (_isDefalut) {
            [self setDeault];
        }
    }
    
}
#pragma mark -UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (__kHeight<__k5Height) {
        [UIView animateWithDuration:0.4 animations:^{
            _tableView.frame=CGRectMake(0, 0, __kWidth, __kHeight-108);
        }];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (__kHeight<__k5Height) {
        [UIView animateWithDuration:0.4 animations:^{
            _tableView.frame=CGRectMake(0, 64, __kWidth, __kHeight-108);
        }];
    }
    _modifyAddressModel.address = textView.text;
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -UITextFiledDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag ==24) {
        [self showPick];
        [self.view endEditing:YES];
        return NO;
    }
    if (textField.tag == 27) {
        if (__kHeight<__k5Height) {
            [UIView animateWithDuration:0.4 animations:^{
                _tableView.frame = CGRectMake(0, -110, __kWidth, __kHeight-108);
            }];
        }
        if (__kHeight==__k5Height) {
            [UIView animateWithDuration:0.4 animations:^{
                _tableView.frame = CGRectMake(0, 0, __kWidth, __kHeight-108);
            }];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag-22) {
        case 0:
        {
            _modifyAddressModel.realname = textField.text;
        }
            break;
        case 1:
        {
            if ([textField.text length]!=11) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码不正确请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alert show];
            }else{
            _modifyAddressModel.mobile = textField.text;
            }
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:{
            if (__kHeight<=__k5Height) {
                [UIView animateWithDuration:0.4 animations:^{
                    _tableView.frame = CGRectMake(0, 64, __kWidth, __kHeight-108);
                }];
            }
            if ([textField.text length]!=6) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"邮政编码不正确请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alert show];
            }else{
            _modifyAddressModel.zipcode =textField.text;
            }
        }
            break;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


/**
 *  设为默认
 */
- (void)setDeault{
    NSLog(@"设为默认");
}


/**
 *  保存
 */
- (void)saveAction{
//    [_tableView reloadData];
    
    NSLog(@"%@-%@-%@-%@-%@-%@-%@-", self.modifyAddressModel.realname,self.modifyAddressModel.mobile,self.modifyAddressModel.Province,self.modifyAddressModel.city,self.modifyAddressModel.Province,self.modifyAddressModel.address,self.modifyAddressModel.zipcode);
    [TCJPHTTPRequestManager POSTWithParameters:@{@"ReId":self.modifyAddressModel.addressId,
                                                 @"ReMeid":GetUserId,
                                                 @"ReName":self.modifyAddressModel.realname,
                                                 @"ReAreaid":@"",
                                                 @"ReMobile":self.modifyAddressModel.mobile,
                                                 @"ReCountry":@"中国",
                                                 @"ReProvince":self.modifyAddressModel.Province,
                                                 @"ReCity":self.modifyAddressModel.city,
                                                 @"ReMap":self.modifyAddressModel.area,
                                                 @"ReAddrdetail":self.modifyAddressModel.address,
                                                 @"ReIsdefault":_isDefalut?@"1":@"0",
                                                 @"areaname":self.modifyAddressModel.area,
                                                 @"city":self.modifyAddressModel.city} requestID:GetUserId requestcode:kRequestCodeeditrecadd success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         NSLog(@"%@", jsonDic[@"data"]);
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
