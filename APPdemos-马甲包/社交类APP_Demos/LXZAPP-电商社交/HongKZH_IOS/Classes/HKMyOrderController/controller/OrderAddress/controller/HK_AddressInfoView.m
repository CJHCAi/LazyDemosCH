//
//  HK_AddressInfoView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_AddressInfoView.h"
#import "HK_AddressInfoCell.h"
#import "RadioButton.h"
#import "HK_AddAddressView.h"
#import "HK_ChangeAddressView.h"
#import "HK_BaseRequest.h"
@interface HK_AddressInfoView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* myTableView;
    NSIndexPath * myTableIndexPath;
    UIImageView *imageVIew;
    UILabel *label;
    UILabel *explainLable;

}

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;



@end

@implementation HK_AddressInfoView

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr =[[NSMutableArray alloc] init];
     }
    return _dataArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self setupMyTable];
}


-(void)initNav
{
    self.title = @"收货地址管理";
    if (@available(iOS 11.0, *)) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBtnPressed:) image:[UIImage imageNamed:@"selfMediaClass_back"]];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBtnPressed:) title:@"+ 新建" font:[UIFont systemFontOfSize:16] titleColor:[UIColor blackColor] highlightedColor:[UIColor blackColor] titleEdgeInsets:UIEdgeInsetsZero];
    }else{
        
        UIButton *backButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        /**
         *  设置frame只能控制按钮的大小
         */
        backButton.frame= CGRectMake(0, 0, 62, 36);
        [backButton setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -5;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
        
        
        UIButton *backButton1  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        /**
         *  设置frame只能控制按钮的大小
         */
        backButton1.frame= CGRectMake(0, 0, 62, 36);
        [backButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [backButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [backButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton1 setTitle:@"新建" forState:UIControlStateNormal];
        [backButton1 addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        backButton1.titleLabel.font = [UIFont systemFontOfSize:16];
        UIBarButtonItem *btn_right1 = [[UIBarButtonItem alloc] initWithCustomView:backButton1];
        UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer1.width = -5;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer1, btn_right1, nil];
    }
    
}

-(void)setupMyTable
{
    CGRect rect = self.view.bounds;
    if (@available(iOS 11.0, *)) {
        rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-NavBarHeight-StatusBarHeight);
    }
    
    rect.size.height-=0;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UICOLOR_RGB_Alpha(0xF3F3F3, 1);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:[HK_AddressInfoCell class] forCellReuseIdentifier:@"cell"];
    UIView *header =[[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 10)];
    header.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    self.tableView.tableHeaderView = header;
    
    [self.view addSubview:self.tableView];
    
    imageVIew = [[UIImageView alloc]init];
    imageVIew.frame  = CGRectMake(kScreenWidth/2 - 30, kScreenHeight/2-140, 60, 60);
    [imageVIew setImage:[UIImage imageNamed:@"InFigure_address"]];
    imageVIew.hidden = NO;
//    [myTableView addSubview:imageVIew];
    label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-90, kScreenHeight/2-70, 180, 20)];
    label.text = @"目前没有可用收货地址";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UICOLOR_RGB_Alpha(0x666666, 1);
    label.font = [UIFont systemFontOfSize:14];
    label.hidden = NO;
    [myTableView addSubview:label];
    explainLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-90, kScreenHeight/2-55, 180, 40)];
    explainLable.text = @"随时为您服务";
    explainLable.hidden = NO;
    explainLable.textAlignment = NSTextAlignmentCenter;
    explainLable.textColor = UICOLOR_RGB_Alpha(0x989898, 1);
    explainLable.font = [UIFont systemFontOfSize:13];
    //    [myTableView addSubview:explainLable];
    
    rect = self.view.bounds;
    
    if (@available(iOS 11.0, *)) {
        rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-SafeAreaBottomHeight);
    }
    
    rect.origin.y = rect.size.height -49;
    rect.origin.x = 90;
    rect.size.height = 49;
    rect.size.width = kScreenWidth-180;
}

-(void)leftBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnPressed:(id)sender
{
    HK_AddAddressView *sv=[[HK_AddAddressView alloc]init];
    [self.navigationController pushViewController:sv animated:YES];
}

-(void)buttonClick:(id)sender
{
//    XY_AddAddressView *sv=[[XY_AddAddressView alloc]init];
//    [self.navigationController pushViewController:sv animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_AddressInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor =[UIColor whiteColor];
    
    addressDataModel * model =[self.dataArr objectAtIndex:indexPath.row];
    
    cell.userAddrData = model;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btn.tag = indexPath.section;
    
    cell.btn.isSelf = YES;
    [cell.btn addTarget:self action:@selector(didButtonValueChanged:) forControlEvents:UIControlEventValueChanged];

    UILabel * taglabel = (UILabel*)[cell.buttonsView viewWithTag:10000011];
    if (!taglabel) {
        if ([model.isDefault length] >0  &&[model.isDefault isKindOfClass:[NSString class] ])
        {
            if ([model.isDefault isEqualToString:@"1"]) {
                cell.modificationButtontwo.hidden = NO;
                cell.backgroundColor = [UIColor colorFromHexString:@"fffde5"];
            }
            else
            {
                cell.modificationButtontwo.hidden = YES;
                cell.backgroundColor = UICOLOR_RGB_Alpha(0xffffff, 1);
            }
        }
    }
    else
    {
        if (indexPath.section==0)
        {
        }
        else
        {
        }

    }

    [cell setModificationBlock:^(addressDataModel *item){
        HK_ChangeAddressView *sv=[[HK_ChangeAddressView alloc]init];
        [sv addData:item];
        [self.navigationController pushViewController:sv animated:YES];
    }];

    [cell setDeleteBlock:^(){
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }];
    return cell;

}

-(void)didButtonValueChanged:(UIButton *)button
{
//    [Tool event:@"slt_address_#addr" label:@"slt_address_#address"];
#pragma mark--**点击地址进行修改，目前点击后返回上一级
    //2.0统计//
//    XY_AddressInfoModel * model = (XY_AddressInfoModel *)[[ViewModelLocator sharedModelLocator].rootaddrNode childAtIndex:button.tag];
//    model.isDefault = YES;
//    [[ViewModelLocator sharedModelLocator] setDefaultAddr:model];
//
//    [ViewModelLocator sharedModelLocator].submitModel.addressInfoModel = model;
//
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//
//    [dic setObject:[ViewModelLocator sharedModelLocator].userModel.useruid forKey:@"uid"];
//    [dic setObject:[NSString stringWithFormat:@"%lld",model.addrid] forKey:@"id"];
//
//    [self Business_Request:BusinessRequestType_get_setdefault_address dic:dic cache:NO];
}

-(UIImage*)getSubImage:(CGRect)rect image:(UIImage *)Image
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect([Image CGImage], rect);
    
    CGRect smallBounds = CGRectMake(0, 0, 13, CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, smallBounds, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
//点击修改订单详情内的地址
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      addressDataModel * model  =[self.dataArr objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(changeBlock:)]) {
        [self.delegate changeBlock:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    addressDataModel * model  =[self.dataArr objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"您确定要删除吗"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
        
            [self deleteAddress:model.addressId withIndexPath:indexPath];
            
        }], nil] show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark 删除用户地址
-(void)deleteAddress:(NSString *)uid withIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"addressId"];
    [params setValue:LOGIN_UID forKey:@"loginUid"];;
    [HK_BaseRequest buildPostRequest:get_deleteUserDeliveryAddress body:params success:^(id  _Nullable responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg  =responseObject[@"msg"];
            [EasyShowTextView showText:msg];
        }else {
            
            // 将此条数据从数组中移除，seld.array为存放列表数据的可变数组
            [self.dataArr removeObjectAtIndex:indexPath.row];
            //再将此条cell从列表删除,_tableView为列表
           [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            //记得刷新列表
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle

{
    return UIStatusBarStyleDefault;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupUpdata];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)setupUpdata
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [HK_BaseRequest buildPostRequest:get_userDeliveryAddressList body:dic success:^(id  _Nullable responseObject) {
        HK_OrderDeliverModel * model =[HK_OrderDeliverModel mj_objectWithKeyValues:responseObject];
        if (!model.code) {
            [self.dataArr removeAllObjects];
            for (addressDataModel *modeld in model.data) {
                
                [self.dataArr addObject:modeld];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

@end
