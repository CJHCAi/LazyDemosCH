//
//  HK_SingleColumnPickerView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_SingleColumnPickerView.h"

@interface HK_SingleColumnPickerView () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, weak) UIControl *bgView;
@property (nonatomic, weak) UIToolbar *toolbar;
@property (nonatomic, assign) NSInteger index;
@end

@implementation HK_SingleColumnPickerView

-(UIPickerView *)pickerView {
    if (!_pickerView) {
        UIPickerView *pickView = [[UIPickerView alloc] init];
        pickView.delegate = self;
        pickView.dataSource = self;
        pickView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
        _pickerView = pickView;
    }
    return _pickerView;
}

- (instancetype)initWithTitles:(NSArray *)titles block:(CallbcakBlock)block{
    if (self = [super init]) {
        self.titles = titles;
        [self setUpUI];
        _callBackBlock = block;
    }
    return self;
}

+ (instancetype)showWithData:(NSArray *)titles {
    HK_SingleColumnPickerView *picker = [[self alloc] initWithTitles:titles block:nil];
    return picker;
}

+ (instancetype)showWithData:(NSArray *)titles callBackBlock:(CallbcakBlock)block {
    HK_SingleColumnPickerView *picker = [[self alloc] initWithTitles:titles block:block];
    return picker;
}

- (void)setUpUI {
    UIControl *bg = [[UIControl alloc] init];
    bg.backgroundColor = RGBA(0, 0, 0, 0.2);
    [bg addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bg];
    self.bgView = bg;
    
    [self addSubview:self.pickerView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [self addSubview:toolbar];
    self.toolbar = toolbar;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolbar setItems:@[cancelItem,flexibleSpaceItem,okItem] animated:NO];
}

//更新位置
- (void)layoutSubviews {
    [super layoutSubviews];
    //背景视图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //pickerView 位置
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self);
        make.height.mas_equalTo(216);
    }];
    
    //toolbar 位置
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.pickerView.mas_top);
        make.left.width.mas_equalTo(self);
    }];
    
}

#pragma mark 事件

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)done {
    if (_callBackBlock) {
        _callBackBlock(_titles[self.index],self.index);
    }
    [self dismiss];
}


#pragma mark UIPickView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.titles.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.titles[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.index = row;
}


@end
