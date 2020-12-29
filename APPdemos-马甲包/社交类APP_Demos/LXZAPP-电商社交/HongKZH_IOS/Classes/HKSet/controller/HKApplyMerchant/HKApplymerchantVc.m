//
//  HKApplymerchantVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKApplymerchantVc.h"
#import "HK_RowFundCell.h"
#import "ChinaArea.h"
#import "HKBaseCitySelectorViewController.h"
#import "HKRealAuthResultVc.h"
#import "HKSetTool.h"
@interface HKApplymerchantVc ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField * _shopNameTF;
    UITextField * _personNameTF;
    UITextField * _PhoneNumberTF;
    NSString *province_Id;
    NSString *city_Id;
    NSString *region_Id;
    NSString * _provice;
    NSString * _city;
}
@property (nonatomic, strong)UIView * topMessageView;
@property (nonatomic, strong)UIButton *subMitBtn;
@property (nonatomic, strong)UITableView *rowTableView;
@property (nonatomic, strong)UIView * footView;
@property (nonatomic, copy) NSString *addressStr;
@end
@implementation HKApplymerchantVc

-(UIView *)topMessageView {
    if (!_topMessageView) {
        _topMessageView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,100)];
        _topMessageView.backgroundColor =[UIColor whiteColor];
    
        UILabel *messageL =[[UILabel alloc] initWithFrame:CGRectMake(15,15,kScreenWidth-30,65)];
        messageL.numberOfLines = 0;
        [AppUtils getConfigueLabel:messageL font:PingFangSCMedium20 aliment:NSTextAlignmentLeft textcolor:RGBA(51,51,51,1) text:@"请留下您的联系方式，方便我们联系您后续合作事宜:"];
        [_topMessageView addSubview:messageL];
    }
    return _topMessageView;
}
-(UIButton *)subMitBtn {
    if (!_subMitBtn) {
        _subMitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [AppUtils getButton:_subMitBtn font:PingFangSCRegular16 titleColor:[UIColor whiteColor] title:@"提交"];
        _subMitBtn.frame =CGRectMake(30,kScreenHeight-StatusBarHeight-NavBarHeight-30-49-SafeAreaBottomHeight,kScreenWidth-60,49);
        _subMitBtn.layer.cornerRadius =5;
        _subMitBtn.layer.masksToBounds = YES;
        _subMitBtn.enabled = NO;
        _subMitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        [_subMitBtn addTarget:self action:@selector(subComplains) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subMitBtn;
}
-(UIView *)footView {
    if (!_footView) {
        _footView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,30)];
        _footView.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        UILabel *fo =[[UILabel alloc] initWithFrame:CGRectMake(15,10,kScreenWidth-30,20)];
        [AppUtils getConfigueLabel:fo font:PingFangSCMedium12 aliment:NSTextAlignmentLeft textcolor:RGBA(153,153,153,1) text:@"商务合作热线: 010-87654321(9:00-22:00)"];
        [_footView addSubview:fo];
    }
    return _footView;
}

#pragma mark 申请为商家
-(void)subComplains {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:HKUSERLOGINID forKey:kloginUid];
    [params setValue:province_Id forKey:@"provinceId"];
    [params setValue:city_Id forKey:@"cityId"];
    [params setValue:_personNameTF.text forKey:@"contacts"];
    [params setValue:_shopNameTF.text forKey:@"name"];
    [params setValue:_PhoneNumberTF.text forKey:@"telephone"];
    
    [Toast loading];
    
    [HKSetTool AppleShopUserWithDic:params successBlock:^(id response) {
        [Toast loaded];
        
            HKRealAuthResultVc * result  =[[HKRealAuthResultVc alloc] init];
            [self.navigationController pushViewController:result animated:YES];
        
    } fail:^(NSString *error) {
        [Toast loaded];
        [EasyShowTextView showText:@"申请失败"];
    }];

}
-(UITableView *)rowTableView {
    if (!_rowTableView) {
        _rowTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topMessageView.frame),kScreenWidth,270) style:UITableViewStylePlain];
        _rowTableView.delegate =self;
        _rowTableView.dataSource =self;
        _rowTableView.rowHeight =60;
        _rowTableView.tableFooterView =[[UIView alloc] init];
        _rowTableView.scrollEnabled =NO;
        _rowTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _rowTableView.tableFooterView =self.footView;
    }
    return _rowTableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  4;
}


#pragma mark - ChinaPlckerViewDelegate
- (void)chinaPlckerViewDelegateChinaModel:(ChinaArea *)chinaModel{
    NSMutableString *str = [[NSMutableString alloc] init];
    // 省
    NSString *string1 = @"";
    if (chinaModel.provinceModel.NAME.length > 0) {
        string1 = [NSString stringWithFormat:@"%@",chinaModel.provinceModel.NAME];
        province_Id = chinaModel.provinceModel.ID;
    }
    _provice =string1;
    // 市
    NSString *string2 = @"";
    if (chinaModel.cityModel.NAME.length > 0) {
        string2 = [NSString stringWithFormat:@"%@",chinaModel.cityModel.NAME];
        city_Id = chinaModel.cityModel.ID;
    }
    _city  =string2;
    // 区
    NSString *string3 =  @"";
    if (chinaModel.areaModel.NAME.length > 0) {
        string3 = [NSString stringWithFormat:@"%@",chinaModel.areaModel.NAME];
        region_Id = chinaModel.areaModel.ID;
    }
    [str appendString:string1];
    [str appendString:string2];
    [str appendString:string3];
    
    self.addressStr = str;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.rowTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self confirmSubmit];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
           @weakify(self)
        [HKBaseCitySelectorViewController showCitySelectorWithProCode:@"" cityCode:@"" areaCode:@"" navVc:self ConfirmBlock:^(HKProvinceModel *proCode, HKCityModel *cityCode, getChinaListAreas *areaCode) {
            @strongify(self)
            ChinaArea*china = [[ChinaArea alloc]init];
            AreaModel*area = [[AreaModel alloc]init];
            area.GRADE = @"4";
            area.ID = [NSString stringWithFormat:@"%@",areaCode.code];
            area.NAME = areaCode.name;
            area.PARENT_AREA_ID =  cityCode.code;
            CityModel*cityM = [[CityModel alloc]init];
            cityM.GRADE = @"3";
            cityM.ID = cityCode.code;
            cityM.NAME = cityCode.name;
            cityM.PARENT_AREA_ID = proCode.code;
            ProvinceModel*proM = [[ProvinceModel alloc]init];
            proM.GRADE = @"2";
            proM.ID=proCode.code;
            proM.NAME = proCode.name;
            china.provinceModel = proM;
            china.cityModel = cityM;
            china.areaModel =area;
            [self chinaPlckerViewDelegateChinaModel:china];
        }];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_RowFundCell * cell =[tableView dequeueReusableCellWithIdentifier:@"ROW"];
    if (cell==nil) {
        cell =[[HK_RowFundCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ROW"];
    }
        //申请退款
        switch (indexPath.row) {
            case 0:
            {
                cell.tagLabel.text =@"所在地区";
                cell.imageRow.hidden = YES;
                cell.textInput.enabled = NO;
                cell.detailTextLabel.text= self.addressStr.length > 0 ?self.addressStr :@"请选择您所在的地区";
                cell.detailTextLabel.font =PingFangSCRegular13;
                cell.detailTextLabel.textColor =[UIColor colorFromHexString:@"666666"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:
            {
                cell.tagLabel.text =@"店铺名称";
                cell.imageRow.hidden = YES;
                cell.textInput.placeholder =@"请输入您的店铺名称";
                cell.textInput.enabled = YES;
                _shopNameTF =cell.textInput;
            }break;
            case 2:
            {
                cell.tagLabel.text =@"联系人";
                cell.imageRow.hidden = YES;
                cell.textInput.placeholder =@"请输入联系人姓名";
                cell.textInput.enabled = YES;
                _personNameTF =cell.textInput;
            }
            break;
            case 3:
            {
                cell.tagLabel.text = @"联系电话";
                cell.imageRow.hidden = YES;
                cell.textInput.placeholder =@"请输入联系人姓名";
                cell.textInput.enabled = YES;
                _PhoneNumberTF =cell.textInput;
                [cell.textInput addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            default:
                break;
        }
    return  cell;
}
-(void)confirmSubmit {
    if (_shopNameTF.text.length && _PhoneNumberTF.text.length==11 && _personNameTF.text.length && self.addressStr.length) {
        
        self.subMitBtn.backgroundColor = RGB(255,74,44);
        self.subMitBtn.enabled =YES;
    }else {
        self.subMitBtn.backgroundColor =[ UIColor colorFromHexString:@"#cccccc"];
        self.subMitBtn.enabled =NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"申请成为商家";
    self.showCustomerLeftItem =YES;
    [self.view addSubview:self.topMessageView];
    [self.view addSubview:self.rowTableView];
    [self.view addSubview:self.subMitBtn];
}


@end
