//
//  ReceiveAddressViewController.m
//  CheLian
//
//  Created by imac on 16/5/4.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ReceiveAddressViewController.h"
#import "ReceiveAddressTableCell.h"
#import "IncreaseReceiveAddressViewController.h"

#import "ModifyAddressViewController.h"
#import "ReceiveAddressDefaultTableCell.h"

@interface ReceiveAddressViewController ()<UITableViewDelegate,UITableViewDataSource,ReceiveAddressDefaultTableCellDelegate,ReceiveAddressTableCellDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArr;

//@property (strong,nonatomic) ReceiveAddressModel *dataModel;
/**
 *  默认地址
 */
@property (strong,nonatomic) NSString *defaultAdd;
/**
 *  省市区
 */
@property (strong,nonatomic) NSString *chooseArea;
@end

@implementation ReceiveAddressViewController

- (void)getdata{
    
    [TCJPHTTPRequestManager POSTWithParameters:@{} requestID:GetUserId requestcode:kRequestCodegetrecaddlist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSLog(@"%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
            NSArray *arr = [NSString jsonArrWithArr:jsonDic[@"data"]];
            
            _dataArr = [NSMutableArray array];
            for (int i=0 ; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                ReceiveAddressModel *data = [[ReceiveAddressModel alloc]init];
                data.realname = dic[@"ReName"];
                data.mobile = dic[@"ReMobile"];
                data.Province = dic[@"ReProvince"];
                data.city = dic[@"ReCity"];
                data.area = dic[@"ReMap"];
                data.address = dic[@"ReAddrdetail"];
                data.zipcode = @"";
                data.defaultCode = dic[@"ReIsdefault"];
                data.addressId = dic[@"ReId"];
                if ([data.defaultCode isEqualToString:@"1"]) {
                    [_dataArr insertObject:data atIndex:0];
                }else{
                [_dataArr addObject:data];
                }
            }
            [self.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    

}

- (void)checkDefault{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self getdata];
    [self checkDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"选择地址";
    [self initView];
}

-(void)initView{
    //添加headerView
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-110-46)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = LH_RGBCOLOR(230, 230, 230);


    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectYH(_tableView), __kWidth, 46)];
    [self.view addSubview:addBtn];
    addBtn.titleLabel.font = MFont(15);
    addBtn.backgroundColor = [UIColor whiteColor];
    [addBtn setTitle:@"新增地址" forState:BtnNormal];
    [addBtn setTitleColor:[UIColor redColor] forState:BtnNormal];
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:BtnTouchUpInside];
    
}

-(void)addAddress{
    IncreaseReceiveAddressViewController *increaseReceiveAddressVc = [[IncreaseReceiveAddressViewController alloc]initWithShopTitle:@"新增地址" image:MImage(@"chec")];
    [self.navigationController pushViewController:increaseReceiveAddressVc animated:YES];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return _dataArr.count;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 ReceiveAddressModel *dataModel=_dataArr[indexPath.row];
    if (indexPath.row == 0) {
        ReceiveAddressDefaultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveAddressDefaultTableCell"];
        if (!cell) {
            cell = [[ReceiveAddressDefaultTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReceiveAddressDefaultTableCell"];
        }
        cell.delegate = self;
        cell.editBtn.tag = indexPath.row;
        cell.nameLb.text=dataModel.realname;
        cell.mobileLb.text =dataModel.mobile;
        cell.addressLb.text = [NSString stringWithFormat:@"[默认]%@%@%@%@",dataModel.Province,dataModel.city,dataModel.area,dataModel.address];
        _chooseArea=[NSString stringWithFormat:@"%@%@%@",dataModel.Province,dataModel.city,dataModel.area];
          return cell;
    }else{
    ReceiveAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyReceiveAddressCell"];
    if (!cell) {
        cell = [[ReceiveAddressTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyReceiveAddressCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        cell.delegate = self;
        cell.editBtn.tag = indexPath.row;
        cell.nameLb.text=dataModel.realname;
        cell.mobileLb.text =dataModel.mobile;
        cell.addressLb.text = [NSString stringWithFormat:@"%@%@%@%@",dataModel.Province,dataModel.city,dataModel.area,dataModel.address];
          return cell;
    }
    
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReceiveAddressModel*data=_dataArr[indexPath.row];
    [self.delegate didSelectAddress:data];
    [self.navigationController popViewControllerAnimated:YES];
   
}

#pragma mark -Cell Delegate
-(void)editAddress:(UIButton *)sender{
    ReceiveAddressModel*data=_dataArr[sender.tag];
    ModifyAddressViewController *vc=[[ModifyAddressViewController alloc]initWithShopTitle:@"修改地址" image:MImage(@"chec")];
    vc.modifyAddressModel =data;
    if (sender.tag == 0) {
        vc.isDefalut = YES;
    }else{
        vc.isDefalut = NO;
    }
    _chooseArea =[NSString stringWithFormat:@"%@%@%@",data.Province,data.city,data.area];
    vc.areaAdd=_chooseArea;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
