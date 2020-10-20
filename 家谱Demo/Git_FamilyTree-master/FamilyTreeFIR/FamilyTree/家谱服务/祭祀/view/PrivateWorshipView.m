//
//  PrivateWorshipView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PrivateWorshipView.h"
#import "PrivateWorshipTableViewCell.h"
#import "CreateCemViewController.h"


@interface PrivateWorshipView()<UITableViewDataSource,UITableViewDelegate, PrivateWorshipTableViewCellDelegate>

/** 新增墓园按钮*/
@property (nonatomic, strong) UIButton *addCemeterialBtn;
@end

@implementation PrivateWorshipView
#pragma mark - lazyLoad


-(NSMutableArray *)PrivateViewMyWorshipArr{
    if (!_PrivateViewMyWorshipArr) {
        _PrivateViewMyWorshipArr = [@[] mutableCopy];
    }
    return _PrivateViewMyWorshipArr;
}

-(NSMutableArray<WorshipDatalistModel *> *)PrivateViewAllWorshipArr{
    if (!_PrivateViewAllWorshipArr) {
        _PrivateViewAllWorshipArr = [@[] mutableCopy];
    }
    return _PrivateViewAllWorshipArr;
}

#pragma mark - 界面初始化
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //添加标题和管理
        [self initTitleAndManager];
        [self initMyTableView];
        [self initRankingLB];
        [self initCemeterialListTableView];
        [self initAddCemeterialBtn];
    }
    return self;
}

-(void)initTitleAndManager{
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, Screen_width/2, 20)];
    titleLB.textAlignment = NSTextAlignmentLeft;
    titleLB.text = @"我创建的墓园";
    titleLB.font = MFont(12);
    [self addSubview:titleLB];
    UIButton *EditBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.85*Screen_width, 0, 0.15*Screen_width, 25)];
    [EditBtn setTitle:@"管理" forState:UIControlStateNormal];
    [EditBtn setTitle:@"完成" forState:UIControlStateSelected];
    [EditBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [EditBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    EditBtn.titleLabel.font = MFont(12);
    [EditBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:EditBtn];
}

-(void)initMyTableView{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 25, Screen_width, 160) style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    //self.myTableView.bounces = NO;
    self.myTableView.tag = 1001;
    [self addSubview:self.myTableView];
}

-(void)initRankingLB{
    UILabel *rankingLB = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectYH(self.myTableView), Screen_width/2, 20)];
    rankingLB.textAlignment = NSTextAlignmentLeft;
    rankingLB.text = @"墓园排行";
    rankingLB.font = MFont(12);
    [self addSubview:rankingLB];

}

-(void)initCemeterialListTableView{
    self.cemeterialListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectYH(self.myTableView)+20, Screen_width, 160)];
    self.cemeterialListTableView.dataSource = self;
    self.cemeterialListTableView.delegate = self;
    //self.cemeterialListTableView.bounces = NO;
    self.cemeterialListTableView.tag = 1002;
    [self addSubview:self.cemeterialListTableView];
}

-(void)initAddCemeterialBtn{
    self.addCemeterialBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectYH(self.cemeterialListTableView)+5, Screen_width, 35)];
    self.addCemeterialBtn.backgroundColor = [UIColor whiteColor];
    [self.addCemeterialBtn setTitle:@"新建墓园" forState:UIControlStateNormal];
    [self.addCemeterialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addCemeterialBtn.titleLabel.font = MFont(13);
    [self.addCemeterialBtn setImage:MImage(@"mcGuanli_xinjian.png") forState:UIControlStateNormal];
    self.addCemeterialBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addCemeterialBtn.hidden = YES;
    [self.addCemeterialBtn addTarget:self action:@selector(clickAddCemeterialBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addCemeterialBtn];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1001) {
        if (self.PrivateViewMyWorshipArr.count != 0) {
            return self.PrivateViewMyWorshipArr.count;
        }else{
            return 0;
        }
        
        
    }else{
        if (self.PrivateViewAllWorshipArr.count != 0) {
            return self.PrivateViewAllWorshipArr.count;
        }else{
            return 0;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((tableView.tag == 1001) && (indexPath.row < self.PrivateViewMyWorshipArr.count)) {
        PrivateWorshipTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"privateWorshipCell"];
        if (!myCell) {
            myCell = [[PrivateWorshipTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"privateWorshipCell"];
        }
    
       if (self.PrivateViewMyWorshipArr.count > 0) {
                myCell.worshipDatalistModel = self.PrivateViewMyWorshipArr[indexPath.row];
        }

        myCell.delegate = self;
        return myCell;
    }else{
        PrivateWorshipTableViewCell *allCell = [tableView dequeueReusableCellWithIdentifier:@"rankingWorshipCell"];
        if (!allCell) {
            allCell = [[PrivateWorshipTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rankingWorshipCell"];
        }
        if (self.PrivateViewAllWorshipArr.count != 0 ) {
            allCell.worshipDatalistModel = self.PrivateViewAllWorshipArr[indexPath.row];
        }
        return allCell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.PrivateWorshipEdit) {
        [self.delegate TableView:tableView didSelectTableRowAtIndexPath:indexPath];
    }
    
    
}


-(void)clickEditBtn:(UIButton *)sender{
    
    sender.selected = !sender.selected;
 
    self.PrivateWorshipEdit = sender.selected;

    for (int i = 0; i < self.PrivateViewMyWorshipArr.count; i++) {
        self.PrivateViewMyWorshipArr[i].worshipDatalistModelEdit = sender.selected;
    }
    [self.myTableView reloadData];
    
    self.addCemeterialBtn.hidden = !sender.selected;

    //进入编辑状态
    [self.delegate PrivateWorshipView:self didSelect:sender.selected];
    
}

-(void)clickAddCemeterialBtn:(UIButton *)sender{
    //新建墓园
   
    if (_delegate && [_delegate respondsToSelector:@selector(PrivateWorshipViewDidSelectedCreateCem:)]) {
        [_delegate PrivateWorshipViewDidSelectedCreateCem:self];
    }
    
}

#pragma mark - PrivateWorshipTableViewCellDelegate
-(void)cemeterialDidEdit:(PrivateWorshipTableViewCell *)cell{
    
    //跳转到编辑页面
    CreateCemViewController *creatCemVC = [[CreateCemViewController alloc]initWithTitle:@"私人墓园" image:nil];
    creatCemVC.creatOrEditStr = NO;
    creatCemVC.CeId = cell.worshipDatalistModel.CeId;
    [[self viewController].navigationController pushViewController:creatCemVC animated:YES];
    
    
}

-(void)cemeterialDidDelete:(PrivateWorshipTableViewCell *)cell{
    
    //删除该行
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    //删除数据源
    [self.PrivateViewMyWorshipArr removeObjectAtIndex:indexPath.row];
    
    [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //发网络请求
    NSDictionary *logDic = @{@"CeId":@(cell.worshipDatalistModel.CeId)};
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeDelcemetery success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        //MYLog(@"%@",jsonDic[@"data"]);
        if (succe) {
            [SXLoadingView showAlertHUD:@"删除成功" duration:0.5];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
