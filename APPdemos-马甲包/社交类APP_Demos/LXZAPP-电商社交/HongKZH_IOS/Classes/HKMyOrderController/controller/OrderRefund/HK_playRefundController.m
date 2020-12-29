//
//  HK_playRefundController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_playRefundController.h"
#import "HK_SingleColumnPickerView.h"
#import "HK_RowFundCell.h"
#import "HK_BaseRequest.h"
@interface HK_playRefundController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _cellDataArr;
    NSMutableArray * _pickerTypeStr;
    NSMutableArray * _pickerResonStr;
    UITextField * _nameTF;
    UITextField * _phoneTF;
    UITextField * _typeTF;
    UITextField * _resonTF;
    NSString * _apiStr;
    NSString *_aplus;
}
@property (weak, nonatomic) IBOutlet UIView *topInfoView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *logOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *logTwoLabel;
@property (weak, nonatomic) IBOutlet UIButton *SubmitBtn;
@property (nonatomic, strong)UITableView *rowTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitH;

@end

@implementation HK_playRefundController

#pragma  mark 提交申请售后或退款
- (IBAction)SubmitClicked:(id)sender {
    if (![AppUtils verifyPhoneNumbers:_phoneTF.text]) {
        [EasyShowTextView showText:@"请输入正确手机号"];
        return;
    }
    NSMutableDictionary * params  =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:self.orderNumber forKey:@"orderNumber"];
    [params setValue:_nameTF.text forKey:@"refundcontact"];
    [params setValue:_phoneTF.text forKey:@"refundTelephone"];
    
    if (self.orderStatus ==Hk_orderRefundAfter) {
        if ([_typeTF.text isEqualToString:@"仅退款"]) {
            [params setValue:@"1" forKey:@"type"];
        }else {
            
            [params setValue:@"2" forKey:@"type"];
        }
    }
#pragma mark 已经提交过必须传2..
    [params setValue:self.types forKey:@"state"];
    [params setValue:_resonTF.text forKey:@"refundReason"];
    [HK_BaseRequest buildPostRequest:_apiStr body:params success:^(id  _Nullable responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg =responseObject[@"msg"];
            if (msg.length) {
                [EasyShowTextView showText:msg];
            }
        }else {
            
//    //修改退款时..完成直接回到列表页刷新数据..
//            if ([self.types isEqualToString:@"2"]) {
            
                 [self.navigationController popViewControllerAnimated:YES];
//            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
-(void)initNav {
    NSString *aplus;
    if ([self.types isEqualToString:@"1"]) {
        aplus =@"申请";
    }else {
        aplus =@"修改";
    }
    if (self.orderStatus ==Hk_orderRefundAfter) {
        self.title =[NSString stringWithFormat:@"%@售后",aplus];
        _apiStr = get_userOrderRefundAfter;
    }else {
        self.title =[NSString stringWithFormat:@"%@退款",aplus];
        _apiStr = get_userOrderRefund;
    }
    _aplus = self.title;
    [self setShowCustomerLeftItem:YES];

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

-(UITableView *)rowTableView {
    if (!_rowTableView) {
        _rowTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topInfoView.frame)+15,kScreenWidth,300) style:UITableViewStylePlain];
        _rowTableView.delegate =self;
        _rowTableView.dataSource =self;
        _rowTableView.rowHeight =60;
        _rowTableView.tableFooterView =[[UIView alloc] init];
        _rowTableView.scrollEnabled =NO;
        _rowTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [_rowTableView registerClass:[HK_RowFundCell class] forCellReuseIdentifier:@"rowFun"];
    }
    return _rowTableView;
}
//设置数据源
-(void)setDataSource {
    if (self.orderStatus ==Hk_orderRefundAfter) {
         _cellDataArr =[NSMutableArray arrayWithObjects:@"售后类型:",@"售后原因:",@"售后联系人:",@"联系方式:", nil];
        
        _pickerTypeStr =[NSMutableArray arrayWithObjects:@"仅退款",@"退款退货", nil];
          _pickerResonStr =[NSMutableArray arrayWithObjects:@"假货",@"卖家错发漏发",@"款式型号颜色问题退换货",@"商品质量瑕疵",@"收到商品与描述不符",@"协商一致退款",@"其他原因", nil];
        
    }else {
        _cellDataArr =[NSMutableArray arrayWithObjects:@"退款原因:",@"退款联系人:",@"联系方式:", nil];
         _pickerResonStr =[NSMutableArray arrayWithObjects:@"订单不能按预计时间送达",@"操作有误(商品,地址等选错)",@"重复下单/误下单",@"其他渠道价格更低",@"该商品降价了",@"不想买了",@"其他原因", nil];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self setDataSource];
    self.view.backgroundColor =[UIColor whiteColor];
    self.topInfoView.backgroundColor =[UIColor colorFromHexString:@"f5f5f5"];
    self.tipsLabel.textColor =[UIColor colorFromHexString:@"333333"];
    self.logOneLabel.textColor =[UIColor colorFromHexString:@"333333"];
    self.logTwoLabel.textColor =[UIColor colorFromHexString:@"333333"];
    self.submitH.constant = SafeAreaBottomHeight +30;
    self.SubmitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
    self.SubmitBtn.layer.cornerRadius =5;
    self.SubmitBtn.layer.masksToBounds =YES;
    self.SubmitBtn.enabled = NO;
     [self.SubmitBtn setTitle:_aplus forState:UIControlStateNormal];
   
    [self.view addSubview:self.rowTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
      return _cellDataArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_RowFundCell * rowCell =[tableView dequeueReusableCellWithIdentifier:@"rowFun" forIndexPath:indexPath];
    if (self.orderStatus==HK_orderReFund) {
    //申请退款
        switch (indexPath.row) {
            case 0:
            {
                rowCell.imageRow.hidden = NO;
                rowCell.textInput.enabled = NO;
                _resonTF =rowCell.textInput;
                rowCell.textInput.placeholder =@"请选择退款原因";
            }
                break;
            case 1:
            {
                rowCell.imageRow.hidden = YES;
                rowCell.textInput.placeholder =@"请输入申请人姓名";
                rowCell.textInput.enabled = YES;
                _nameTF =rowCell.textInput;
//                [rowCell.textInput addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventEditingChanged];
            }break;
            case 2:
            {
                rowCell.imageRow.hidden = YES;
                rowCell.textInput.placeholder =@"请输入联系方式";
                rowCell.textInput.enabled = YES;
                _phoneTF =rowCell.textInput;
           [rowCell.textInput addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventEditingChanged];
            }break;
            default:
                break;
        }
    }else {
     //申请售后
        switch (indexPath.row) {
            case 0:
            {
                rowCell.imageRow.hidden = NO;
                rowCell.textInput.enabled = NO;
                _typeTF =rowCell.textInput;
                rowCell.textInput.placeholder =@"请选择售后类型";
            }
            case 1:
            {
                rowCell.imageRow.hidden = NO;
                rowCell.textInput.placeholder =@"请选择售后原因";
                rowCell.textInput.enabled = NO;
                _resonTF =rowCell.textInput;
                
            }break;
            case 2:
            {  rowCell.imageRow.hidden = YES;
                rowCell.textInput.placeholder =@"请输入申请人姓名";
                rowCell.textInput.enabled = YES;
                _nameTF =rowCell.textInput;
//                [rowCell.textInput addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventEditingDidEnd];
                
            }break;
            case 3:
            {
                rowCell.imageRow.hidden = YES;
                rowCell.textInput.placeholder =@"请输入联系方式";
                rowCell.textInput.enabled = YES;
                _phoneTF =rowCell.textInput;
            [rowCell.textInput addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            default:
                break;
        }
    }
    rowCell.tagLabel.text  =_cellDataArr[indexPath.row];
    return  rowCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderStatus==Hk_orderRefundAfter && indexPath.row>1) {
        return;
    }
    if (self.orderStatus ==HK_orderReFund && indexPath.row>0) {
        return;
    }
    NSArray  *tagArr;
    //选择退款类型
    if (self.orderStatus==HK_orderReFund && indexPath.row==0) {
        tagArr =_pickerResonStr;
    }else if (self.orderStatus ==Hk_orderRefundAfter&&indexPath.row==0) {
        tagArr =_pickerTypeStr;
     //选退款原因
    }else if (self.orderStatus==Hk_orderRefundAfter &&indexPath.row==1){
         tagArr =_pickerResonStr;
    }
    HK_SingleColumnPickerView * picker =[HK_SingleColumnPickerView showWithData:tagArr callBackBlock:^(NSString *value, NSInteger index) {
       //获取当前点击的cell
       // HK_RowFundCell * cell =[tableView cellForRowAtIndexPath:indexPath];
        if (self.orderStatus==HK_orderReFund && indexPath.row==0) {
            
            self->_resonTF.text =value;
            
        }else if (self.orderStatus==Hk_orderRefundAfter && indexPath.row==0){
            self->_typeTF.text = value;
        }else if (self.orderStatus ==Hk_orderRefundAfter && indexPath.row==1){
            self->_resonTF.text =value;
        }
    }];
    [self.navigationController.view addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
 
}
-(void)confirmSubmit {
    
    if (_nameTF.text.length && _phoneTF.text.length==11 && _phoneTF.text) {
        
        self.SubmitBtn.backgroundColor =[UIColor colorFromHexString:@"d45048"];
        self.SubmitBtn.enabled =YES;
    }else {
        self.SubmitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        self.SubmitBtn.enabled =NO;
    }
}
@end
