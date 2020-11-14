//
//  ViewController.m
//  Test
//
//  Created by K.O on 2018/7/20.
//  Copyright © 2018年 rela. All rights reserved.
//

#import "ViewController.h"
#import "InfoModel.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *categoryAry;
@property(nonatomic,strong)InfoModel *info;
@property(nonatomic,strong)UITableView *tbView;
@end


NSString *CELLID = @"NormalCellID";

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.categoryAry = @[@"性别",@"身高",@"体重",@"出生年月",@"时间",@"区间",@"省市"];
    UITableView *tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 375, 500) style:UITableViewStylePlain];
    
    [self.view addSubview:tbView];
    tbView.tableFooterView = [[UIView alloc]init];
    
    tbView.delegate = self;
    
    tbView.dataSource = self;
    
    self.info = [[InfoModel alloc] init];
    
    [tbView registerNib:[UINib nibWithNibName:@"NormalCell" bundle:nil] forCellReuseIdentifier:CELLID];
    
    self.tbView = tbView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoryAry.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];

    cell.category =self.categoryAry[indexPath.row];
    cell.info = self.info;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PickerView *vi = [[PickerView alloc] init];
    vi.tag = 100+indexPath.row;
    vi.delegate = self;
    
    if (indexPath.row==0) {
        vi.type = PickerViewTypeSex;
        
    }
    
    if (indexPath.row==1) {
        vi.type = PickerViewTypeHeigh;
        vi.selectComponent = 2;
    }
    
    if (indexPath.row==2) {
        vi.type = PickerViewTypeWeight;
    }
    if (indexPath.row==3) {
        vi.type = PickerViewTypeBirthday;
    }
    
    if (indexPath.row==4) {
        vi.type = PickerViewTypeTime;
    }
    
    
    if (indexPath.row==5) {
        vi.array = [self rangAry];
        vi.type = PickerViewTypeRange;
        vi.selectComponent = 2;
       
        
    }
    
    if (indexPath.row==6) {
        vi.type = PickerViewTypeCity;
    }
    
    
    [self.view addSubview:vi];
    
}

-(void)pickerView:(UIView *)pickerView result:(NSString *)string{
    
    NSLog(@"结果：%@",string);
    
    if (pickerView.tag-100==0) {
        
        self.info.sex = string;
        
        
    }
    
    if (pickerView.tag-100==1) {
      self.info.heigh = [NSString stringWithFormat:@"%@cm",string];;
    }
    
    if (pickerView.tag-100==2) {
       self.info.weight = [NSString stringWithFormat:@"%@kg",string];
    }
    if (pickerView.tag-100==3) {
        self.info.birthday = string;
    }
    
    if (pickerView.tag-100==4) {
        self.info.time = string;
    }
    
    
    if (pickerView.tag-100==5) {
    self.info.rang = string;
        
        
    }
    
    if (pickerView.tag-100==6) {
        self.info.city = string;
    }
    
    [self.tbView reloadData];
}





- (NSMutableArray *)rangAry{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 100; i <= 120; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arr addObject:str];
    }
    return arr;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
