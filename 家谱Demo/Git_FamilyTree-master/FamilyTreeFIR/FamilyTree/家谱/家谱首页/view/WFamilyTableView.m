//
//  WFamilyTableView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WFamilyTableView.h"
#import "WFamilyTableViewCell.h"

static NSString *const kReusableWFamCellIdentifier = @"kReusableWFamCellIdentifier";


@interface WFamilyTableView()<UITableViewDelegate,UITableViewDataSource>

/**单例数据*/
@property (nonatomic,strong) WFamilyModel *famModel;


@end
@implementation WFamilyTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

#pragma mark *** 初始化数据 ***
-(void)initData{
    
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self addSubview:self.tableView];
}

#pragma mark *** UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.famModel.datalist) {
        return self.famModel.datalist.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WFamilyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReusableWFamCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[WFamilyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReusableWFamCellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.famNameLabel.text = self.famModel.datalist[indexPath.row].GemeName;
    cell.famIntroLabel.text = self.famModel.datalist[indexPath.row].Grjl;
    cell.famImageView.imageURL = [NSURL URLWithString:self.famModel.datalist[indexPath.row].GemePhoto];
    cell.famCellType = indexPath.row%2==1?FamilyCellImageTypeLeft:FamilyCellImageTypeRight;
    
    [cell changeCellStyle];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       NSInteger gemeId =  self.famModel.datalist[indexPath.row].GemeId;
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"gemeid":@(gemeId)} requestID:GetUserId requestcode:kRequestCodequerygemedetailbyid success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            WpersonInfoModel *model = [WpersonInfoModel modelWithJSON:jsonDic[@"data"]];
            
            WPersonInfoViewController *personVc = [[WPersonInfoViewController alloc] initWithTitle:@"个人信息" image:nil];
            personVc.infoModel = model;
            [self.viewController.navigationController pushViewController:personVc animated:YES];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
        
}

#pragma mark *** getters ***


-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 370*AdaptationWidth();

        [_tableView registerClass:[WFamilyTableViewCell class] forCellReuseIdentifier:kReusableWFamCellIdentifier];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
    
}
-(WFamilyModel *)famModel{
    if (!_famModel) {
        _famModel = [WFamilyModel shareWFamilModel];
        
    }
    return _famModel;
}
@end
