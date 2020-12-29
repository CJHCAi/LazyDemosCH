//
//  HKBaseCitySelectorViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseCitySelectorViewController.h"

@interface HKBaseCitySelectorViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic ,strong) UIPickerView *cityPicker;
@property (nonatomic, strong)HKChinaModel *lisM;
@property (nonatomic, strong)NSMutableArray *parray;
@property (nonatomic, strong)NSMutableArray *carray;
@property (nonatomic, strong)NSMutableArray *aarray;
@property (nonatomic,assign) NSInteger selectPro;
@property (nonatomic,assign) NSInteger selectCity;
@property (nonatomic,assign) NSInteger selectarea;
@property (nonatomic, strong)UIButton *shadeBtn;
@property (nonatomic, strong)UIView *confirmView;
@property (nonatomic, strong)UIButton *conBtn;
@end

@implementation HKBaseCitySelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return kScreenWidth/3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    
    return 3;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.selectPro = row;
        self.selectCity = 0;
        self.selectarea = 0;
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else if (component == 1){
        self.selectCity = row;
        self.selectarea = 0;
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else{
        self.selectarea = row;
    }
    [pickerView reloadAllComponents];
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componen{
    NSMutableArray*proM = self.lisM.provinces;
    HKProvinceModel*cityM = proM[self.selectPro];
   
    if (componen == 0) {
        
        return [proM[row] name];
    }else if(componen == 1){
        if (cityM.citys.count) {
            HKCityModel*city = cityM.citys[row];
            return [city name];
        }
    }
    if (cityM.citys.count) {
        HKCityModel*city = cityM.citys[self.selectCity];
        return [city.areas[row] name];
    }
    return @"";
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSMutableArray*proM = self.lisM.provinces;
    HKProvinceModel*cityM = proM[self.selectPro];
    
    if (component == 0) {
        
        return self.lisM.provinces.count;
    }else if(component == 1){
        return cityM.citys.count;
    }
    if (cityM.citys.count) {
        HKCityModel*city = cityM.citys[self.selectCity];
        return [city.areas count];
    }
    return  0;
}
-(void)setUI{
    [self.view addSubview:self.cityPicker];
    [self.view addSubview:self.confirmView];
    [self.view addSubview:self.shadeBtn];
    [self.cityPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.cityPicker.mas_top);
        make.height.mas_offset(50);
    }];
    [self.conBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.confirmView).offset(-15);
        make.centerY.equalTo(self.confirmView);
    }];
    [self.shadeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.confirmView.mas_top);
    }];
    
}
- (UIPickerView *)cityPicker
{
    if(_cityPicker == nil)
    {
        _cityPicker = [[UIPickerView alloc]init];;
        _cityPicker.delegate = self;
        _cityPicker.dataSource = self;
        _cityPicker.backgroundColor = [UIColor whiteColor];
    }
    return _cityPicker;
}
-(HKChinaModel *)lisM{
    if (!_lisM) {
        _lisM = [NSKeyedUnarchiver unarchiveObjectWithFile:KCityListData];
    }
    return _lisM;
}
- (NSMutableArray *)parray
{
    if(_parray == nil)
    {
        _parray = [ NSMutableArray array];
    }
    return _parray;
}
- (NSMutableArray *)aarray
{
    if(_aarray == nil)
    {
        _aarray = [ NSMutableArray array];
    }
    return _aarray;
}
- (NSMutableArray *)carray
{
    if(_carray == nil)
    {
        _carray = [ NSMutableArray array];
    }
    return _carray;
}
+(void)showCitySelectorWithProCode:(NSString*)proCode cityCode:(NSString*)cityCode areaCode:(NSString*)areaCode navVc:(UIViewController*)navVc ConfirmBlock:(ConfirmBlock)confirmBlock{
   HKBaseCitySelectorViewController*citySelec = [[HKBaseCitySelectorViewController alloc]init];
    if (proCode.length>0) {
        citySelec.proCode = proCode;
    }
    if (cityCode.length>0) {
        citySelec.cityCode = cityCode;
    }
    if (areaCode.length>0) {
        citySelec.areaCode = areaCode;
    }
    
    citySelec.confirmBlock = confirmBlock;
    citySelec.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    citySelec.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    navVc.navigationController.definesPresentationContext = YES;
    [navVc.navigationController presentViewController:citySelec animated:YES completion:nil];
    
}

-(void)setProCode:(NSString *)proCode{
    _proCode = proCode;
    for (int i = 0; i<self.lisM.provinces.count; i++) {
        HKProvinceModel*proM = self.lisM.provinces[i];
        if (proM.code.intValue == proCode.intValue) {
            self.selectPro = i;
            break;
        }
    }
}
-(void)setCityCode:(NSString *)cityCode{
    _cityCode = cityCode;
    HKProvinceModel*proM = self.lisM.provinces[self.selectPro];
    for (int i = 0; i<proM.citys.count; i++) {
        HKCityModel*city = proM.citys[i];
        if (cityCode.intValue == city.code.intValue) {
            self.selectCity = i;
            break;
        }
    }
}
-(void)setAreaCode:(NSString *)areaCode{
    _areaCode = areaCode;
    HKProvinceModel*proM = self.lisM.provinces[self.selectPro];
    HKCityModel*city = proM.citys[self.selectCity];
    for (int i = 0; i<city.areas.count; i++) {
        getChinaListAreas*cityM = city.areas[i];
        if (areaCode.intValue == cityM.code.intValue) {
            self.selectarea = i;
            break;
        }
    }
    [self.cityPicker selectRow:self.selectPro inComponent:0 animated:YES];
    [self.cityPicker selectRow:self.selectCity inComponent:1 animated:YES];
    [self.cityPicker selectRow:self.selectarea inComponent:2 animated:YES];
}
-(void)gotocancle{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIButton *)shadeBtn{
    if (!_shadeBtn) {
        _shadeBtn = [[UIButton alloc]init];
        [_shadeBtn addTarget:self action:@selector(gotocancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadeBtn;
}
-(void)confirmViewClick{
    if ([self.delegate respondsToSelector:@selector(confirmWithProCode:cityCode:areaCode:)]) {
        
    }
    HKProvinceModel*proCode=self.lisM.provinces[self.selectPro];
    
    HKCityModel*cityCode;
    if ([self.lisM.provinces[self.selectPro] citys].count) {
        cityCode =[self.lisM.provinces[self.selectPro] citys][self.selectCity];
    }else {
        cityCode.name =@"";
        cityCode.code =@"100010";
        cityCode.provinceId =@"100010";
    }
    getChinaListAreas*areaCode;
    if ([self.lisM.provinces[self.selectPro] citys].count &&[[self.lisM.provinces[self.selectPro] citys][self.selectCity] areas].count) {
        areaCode =[[self.lisM.provinces[self.selectPro] citys][self.selectCity] areas][self.selectarea];
    }else {
        areaCode.name =@"";
        areaCode.cityId =@"100010";
    }
//    self.confirmBlock(self.lisM.provinces[self.selectPro], [self.lisM.provinces[self.selectPro] citys][self.selectCity], [[self.lisM.provinces[self.selectPro] citys][self.selectCity] areas][self.selectarea]);
    self.confirmBlock(proCode,cityCode,areaCode);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIView *)confirmView{
    if (!_confirmView) {
        _confirmView = [[UIView alloc]init];
        _confirmView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"确定" forState:0];
        [btn setTitleColor:[UIColor blackColor]forState:0];
        [btn addTarget:self action:@selector(confirmViewClick) forControlEvents:UIControlEventTouchUpInside];
        _conBtn = btn;
        [_confirmView addSubview:btn];
    }
    return _confirmView;
}
@end
