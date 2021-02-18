//
//  AreaChooseView.m
//  CheLian
//
//  Created by imac on 16/5/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "AreaChooseView.h"

@interface  AreaChooseView()<UIPickerViewDelegate,UIPickerViewDataSource>
/**
 *  地域选择视图
 */
@property (strong,nonatomic) UIPickerView *areaPickerV;


//data
@property (strong,nonatomic) NSDictionary *pickerDic;
/**
 *  省数据数组
 */
@property (strong,nonatomic) NSArray *provinceArr;
/**
 *  市数据数组
 */
@property (strong,nonatomic) NSArray *cityArr;
/**
 *  区县数据数组
 */
@property (strong,nonatomic) NSArray *townArr;
/**
 *  选择数组
 */
@property (strong,nonatomic) NSArray *selectedArray;

@end

@implementation AreaChooseView

- (void)getdata{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc]initWithContentsOfFile:path];
    self.provinceArr = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    if (self.selectedArray.count>0) {
        self.cityArr = [[self.selectedArray objectAtIndex:0]allKeys];
    }
    if (self.cityArr.count>0) {
        self.townArr = [[self.selectedArray objectAtIndex:0]allKeys];
    }
}

- (instancetype)initWithAreaFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        _provinceArr = [NSArray array];
        _cityArr = [NSArray array];
        _townArr = [NSArray array];
        [self getdata];
    }
    return self;
}

- (void)initView{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 40)];
    [self addSubview:headV];
    headV.backgroundColor = [UIColor whiteColor];

    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 1)];
    [headV addSubview:lineV];
    lineV.backgroundColor = LH_RGBCOLOR(75, 88, 91);
   
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 40, 20)];
    [headV addSubview:cancelBtn];
    cancelBtn.titleLabel.font = MFont(13);
    cancelBtn.backgroundColor =[UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:BtnNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:BtnNormal];
    [cancelBtn setTitle:@"取消" forState:BtnHighlighted];
    [cancelBtn setTitleColor:[UIColor redColor] forState:BtnHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:BtnTouchUpInside];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-60, 10, 40, 20)];
    [headV addSubview:sureBtn];
    sureBtn.titleLabel.font = MFont(13);
    sureBtn.backgroundColor = [UIColor redColor];
    [sureBtn setTitle:@"完成" forState:BtnNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [sureBtn setTitle:@"完成" forState:BtnHighlighted];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:BtnHighlighted];
    sureBtn.layer.cornerRadius = 4;
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:BtnTouchUpInside];

    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 39, __kWidth, 1)];
    [headV addSubview:bottomV];
    bottomV.backgroundColor = LH_RGBCOLOR(75, 88, 91);

    _areaPickerV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, __kWidth, self.frame.size.height-40)];
    [self addSubview:_areaPickerV];
    _areaPickerV.delegate =self;
    _areaPickerV.dataSource =self;
}
/**
 *  取消选择
 */
- (void)cancelAction{
    [self removeFromSuperview];
}
/**
 *  确定选择该地区
 */
- (void)sureAction{
    self.province =[self.provinceArr objectAtIndex:[_areaPickerV selectedRowInComponent:0]];
    self.city = [self.cityArr objectAtIndex:[_areaPickerV selectedRowInComponent:1]];
    self.area = [self.townArr objectAtIndex:[_areaPickerV selectedRowInComponent:2]];
    if (self.returntextfileBlock!=nil) {
        NSString *dataStr = [NSString stringWithFormat:@"%@ %@ %@",_province,_city,_area];
        self.returntextfileBlock(dataStr);
    }
    [self removeFromSuperview];
}
#pragma mark -UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArr.count;
    }else if(component ==1){
        return self.cityArr.count;
    }else{
        return self.townArr.count;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [self.provinceArr objectAtIndex:row];
    }else if (component==1){
        return [self.cityArr objectAtIndex:row];
    }else{
        return [self.townArr objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {
        return 110;
    }else if (component==1){
        return 100;
    }else{
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArr objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArr = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArr = nil;
        }
        if (self.cityArr.count > 0) {
            self.townArr = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:0]];
        } else {
            self.townArr = nil;
        }

    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    if (component==1){
        if (self.selectedArray.count > 0 && self.cityArr.count > 0) {
            self.townArr = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:row]];
        } else {
            self.townArr = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    [pickerView reloadComponent:2];
}

@end
