//
//  HK_addAdress.m
//  HongKZH_IOS
//
//  Created by wuruijie on 2018/9/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_addAdress.h"
#import "HK_SingleColumnPickerView.h"
#import "HK_BaseRequest.h"
#import "ActionSheetStringPicker.h"
@interface HK_addAdress ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)UITextField * textField;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *subMitBtn;
@property(nonatomic,copy)NSString *couierName;
@end

@implementation HK_addAdress

-(NSMutableArray *)data {
    if (!_data) {
        _data =[[NSMutableArray alloc] init];
    }
    return _data;
}
-(void)setData {
    NSArray * arr =@[@"申通快递",@"顺丰快递",@"韵达快递",@"圆通快递",@"中通快递",@"EMS邮政",@"德邦快递"];
    for (int i=0; i<arr.count
         ; i++) {
        [self.data addObject:arr[i]];
    }
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,10,kScreenWidth,300)
                     style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //根据 formModel 的不同类型创建不同的 cell
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];;
    if (indexPath.row==0) {
              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
              cell.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:15.f];
              cell.textLabel.textColor = RGB(51, 51, 51);
              cell.accessoryType =  UITableViewCellAccessoryNone;
                cell.textLabel.text =@"快递单号";
                UITextField *tf = [[UITextField alloc] initWithFrame:CGRectZero];
                tf.delegate = self;
                tf.font = [UIFont fontWithName:PingFangSCRegular size:14.f];
                tf.textColor = RGB(102, 102, 102);
                tf.textAlignment = NSTextAlignmentRight;
                tf.placeholder =@"请输入快递单号";
                [cell.contentView addSubview:tf];
                self.textField = tf;
                [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(230);
                    make.right.mas_equalTo(cell.mas_right).offset(-16);
                    make.centerY.mas_equalTo(cell);
                    make.height.mas_equalTo(cell);
                }];
                [_textField addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventEditingChanged];
            }
    else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:15.f];
            cell.textLabel.textColor = RGB(51, 51, 51);
            cell.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:14.f];
            cell.detailTextLabel.textColor = RGB(102, 102, 102);
            cell.detailTextLabel.text =@"请选择";
            cell.textLabel.text =@"快递公司";
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)valueChanged {
    
    if (self.textField.text.length>0 && self.couierName.length) {
        
        self.subMitBtn.backgroundColor =[UIColor colorFromHexString:@"d45048"];
        self.subMitBtn.enabled =YES;
    }else {
        
        self.subMitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        self.subMitBtn.enabled =NO;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        HK_SingleColumnPickerView * picker =[HK_SingleColumnPickerView showWithData:self.data callBackBlock:^(NSString *value, NSInteger index) {
            self.couierName = value;
            UITableViewCell * cell =[tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = value;
            }];
        if (self.textField.text.length) {
            self.subMitBtn.backgroundColor =[UIColor colorFromHexString:@"d45048"];
            self.subMitBtn.enabled =YES;
        }
        [self.navigationController.view addSubview:picker];
        [picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.navigationController.view);
        }];
    }

}

#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"填写物流";
    [self setShowCustomerLeftItem:YES];
    [self setData];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.subMitBtn];
}
-(UIButton *)subMitBtn {
    if (!_subMitBtn) {
        _subMitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [AppUtils getButton:_subMitBtn font:PingFangSCRegular16 titleColor:[UIColor whiteColor] title:@"提交"];
        _subMitBtn.frame =CGRectMake(15,kScreenHeight-StatusBarHeight-NavBarHeight-22-49,kScreenWidth-30,49);
        _subMitBtn.layer.cornerRadius =5;
        _subMitBtn.layer.masksToBounds = YES;
        _subMitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        [_subMitBtn addTarget:self action:@selector(commitCourier) forControlEvents:UIControlEventTouchUpInside];
         
    }
    return _subMitBtn;
}
#pragma mark 发物流
-(void)commitCourier {
    if (self.textField.text.length==10) {
        [EasyShowTextView showText:@"快递单号无效"];
        return;
    }
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:HKUSERLOGINID forKey:kloginUid];
    [params setValue:self.orderNumber forKey:@"orderNumber"];
    [params setValue:self.couierName forKey:@"courier"];
    [params setValue:self.textField.text forKey:@"courierNumber"];
    [HK_BaseRequest buildPostRequest:@"mediaShop/returnLogistics" body:params success:^(id  _Nullable responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (!code) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            NSString *msg =responseObject[@"msg"];
            [EasyShowTextView showText:msg];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
