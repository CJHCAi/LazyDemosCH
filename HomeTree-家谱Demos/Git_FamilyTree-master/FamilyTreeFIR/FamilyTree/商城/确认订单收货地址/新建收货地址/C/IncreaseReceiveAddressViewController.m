//
//  IncreaseReceiveAddressViewController.m
//  CheLian
//
//  Created by 姚珉 on 16/5/19.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "IncreaseReceiveAddressViewController.h"
#import "IncreaseReceiveAddressTableCell.h"
#import "ReceiveAddressModel.h"
#import "AreaChooseView.h"


@interface IncreaseReceiveAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

/** 表格*/
@property (nonatomic, strong) UITableView *tableView;

@property (strong,nonatomic) ReceiveAddressModel*dataModel;
/**
 *  地区选择
 */
@property (strong,nonatomic) AreaChooseView *pickerView;
/**
 *  地区信息
 */
@property (strong,nonatomic) NSString *addStr;

@property (strong,nonatomic) UILabel *placeholderLb;

@property (nonatomic) BOOL isDefault;

@end

@implementation IncreaseReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataModel = [[ReceiveAddressModel alloc]init];
    self.title = @"新增收货地址";
    self.view.backgroundColor = LH_RGBCOLOR(230, 230, 230);
    [self initView];
}

-(void)initView{
    _isDefault = NO;
    //添加tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-110-46)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    //添加保存按钮
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectYH(_tableView), __kWidth, 46)];
    [self.view addSubview:saveBtn];
    [saveBtn setTitle:@"保存地址" forState:BtnNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    saveBtn.backgroundColor = [UIColor redColor];
    saveBtn.titleLabel.font = MFont(15);
    [saveBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:BtnTouchUpInside];
    
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
        NSArray *arr =[data componentsSeparatedByString:@" "];
        weakSelf.dataModel.Province=arr[0];
        weakSelf.dataModel.city = arr[1];
        weakSelf.dataModel.area = arr[2];
    };

}

//保存按钮执行方法
-(void)saveAction{
    
 
    NSLog(@"%@-%@-%@-%@-%@-%@-%@-%@", self.dataModel.realname,self.dataModel.mobile,self.dataModel.Province,self.dataModel.city,self.dataModel.Province,self.dataModel.address,self.dataModel.zipcode,_isDefault?@"是默认":@"不是默认");
    [TCJPHTTPRequestManager POSTWithParameters:@{@"ReMeid":GetUserId,
                                                 @"ReName":self.dataModel.realname,
                                                 @"ReAreaid":@"",
                                                 @"ReMobile":self.dataModel.mobile,
                                                 @"ReCountry":@"中国",
                                                 @"ReProvince":self.dataModel.Province,
                                                 @"ReCity":self.dataModel.city,
                                                 @"ReMap":self.dataModel.area,
                                                 @"ReAddrdetail":self.dataModel.address,
                                                 @"ReIsdefault":_isDefault?@"1":@"0",
                                                 @"areaname":self.dataModel.area,
                                                 @"city":self.dataModel.city} requestID:GetUserId requestcode:kRequestCodegetaddtrecadd success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         NSLog(@"%@", jsonDic[@"data"]);
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
}

#pragma mark - UITableViewDataSource , UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IncreaseReceiveAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IncreasReceiveAddressCell"];
    if (!cell) {
        cell = [[IncreaseReceiveAddressTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IncreasReceiveAddressCell"];
    }
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row+33;
    switch (indexPath.row) {
        case 0:
            cell.label.text = @"收货人";
            cell.textField.placeholder = @"请输入收货人";
            break;
        case 1:
            cell.label.text = @"手机号码";
            cell.textField.placeholder = @"请输入手机号码";
            break;
        case 2:
            cell.label.text = @"省市地区";
            cell.textField.placeholder = @"请输入省市地区";
            if (![_addStr isEqualToString:@""]) {
                cell.textField.text = _addStr;
            }
            break;
        case 3:
            cell.label.text = @"详细地址";
            cell.textField.hidden = YES;
            cell.addressTF.hidden = NO;
            _placeholderLb = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, __kWidth-133, 30)];
            [cell.addressTF addSubview:_placeholderLb];
            cell.addressTF.delegate =self;
            _placeholderLb.backgroundColor = [UIColor clearColor];
            _placeholderLb.textColor =LH_RGBCOLOR(200, 200, 200);
            _placeholderLb.textAlignment = NSTextAlignmentLeft;
            _placeholderLb.font = MFont(13);
            _placeholderLb.text = @"请输入详细地址(5~120个字)";
            if (!IsNilString(cell.addressTF.text)) {
                _placeholderLb.hidden = YES;
            }
            break;
        case 4 :{
           cell.label.text = @"设为默认地址";
            cell.textField.hidden = YES;
            cell.chooseIV.hidden = NO;
            if (_isDefault) {
                  cell.chooseIV.image = MImage(@"默认.png");
            }else{
               cell.chooseIV.image = MImage(@"非默认.png");
            }

        }
            break;
        default:
            cell.label.text = @"邮政编码";
            cell.textField.placeholder = @"邮政编码";
            break;
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
    if (indexPath.row == 4) {
        _isDefault = !_isDefault;
        [_tableView reloadData];
    }
}
#pragma mark -UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (__kHeight<__k5Height) {
        [UIView animateWithDuration:0.4 animations:^{
            _tableView.frame=CGRectMake(0, 0, __kWidth, __kHeight-130);
        }];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (__kHeight<__k5Height) {
        [UIView animateWithDuration:0.4 animations:^{
            _tableView.frame=CGRectMake(0, 64, __kWidth, __kHeight-130);
        }];
    }
    _dataModel.address = textView.text;
    NSLog(@"%@",textView.text);
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (IsNilString(textView.text)) {
        _placeholderLb.hidden = NO;
    }else{
        _placeholderLb.hidden = YES;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==35) {
        [self showPick];
      [self.view endEditing:YES];
        return NO;
    }
    if (textField.tag == 38) {
        if (__kHeight<=__k5Height) {
            [UIView animateWithDuration:0.4 animations:^{
                _tableView.frame = CGRectMake(0, -110, __kWidth, __kHeight-108);
            }];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag-33) {
        case 0:
        {
            _dataModel.realname = textField.text;
            NSLog(@"%@",_dataModel.realname);
        }
            break;
        case 1:
        {
            if ([textField.text length]!=11) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码位数不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alert show];
            }else{
                _dataModel.mobile = textField.text;
            }
            NSLog(@"%@",_dataModel.mobile);
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
        default:{
            if (__kHeight<=__k5Height) {
                [UIView animateWithDuration:0.4 animations:^{
                    _tableView.frame = CGRectMake(0, 64, __kWidth, __kHeight-108);
                }];
            }
            if ([textField.text length]!=6) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"邮政编码位数不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alert show];
            }else{
                _dataModel.zipcode =textField.text;
            }
            NSLog(@"%@",_dataModel.zipcode);
        }
            break;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
