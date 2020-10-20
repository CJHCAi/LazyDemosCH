//
//  BFMainViewController.m
//  自定义cell编辑状态
//
//  Created by bxkj on 2017/8/3.
//  Copyright © 2017年 周冰烽. All rights reserved.
//

#import "BFMainViewController.h"
#import "UIColor+BFColor.h"
#import "Masonry.h"
#import "BFNavView.h"
#import "BFLeftMainCell.h"
#import "BFRightMainCell.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static NSString * const goodsCellID = @"goodsCellID";
static NSString * const shopsCellID = @"shopsCellID";
@interface BFMainViewController ()<UITableViewDelegate,UITableViewDataSource>
//左按钮
@property(nonatomic,weak) UIButton *leftBtn;
//右按钮
@property(nonatomic,weak) UIButton *rightBtn;
//左按钮横线
@property(nonatomic,weak) UIView *leftBottomLine;
//有按钮横线
@property(nonatomic,weak) UIView *rightBottomLine;
//商品列表
@property(nonatomic,weak) UITableView *goodsTableView;
//商铺列表
@property(nonatomic,weak) UITableView *shopsTableView;
//底部全选背景
@property(nonatomic,weak) UIView *bottomBgView;
//全选按钮上的图片
@property(nonatomic,weak) UIImageView *selectAllImageView;

//选择的tableview,0为goodsTableView,1位shopsTableView
@property(nonatomic,assign) NSInteger isSelect;
//goodsTableView是否已经滑动过
@property(nonatomic,assign) BOOL goodsIsClips;
@end

@implementation BFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}
- (void)setupUI{
    self.goodsIsClips = NO;
    self.view.backgroundColor = [UIColor BF_ColorWithHex:0xF9F9F9];
    //导航栏
    [self setupNav];
    //选择栏
    [self setupSelectView];
    //tableView
    [self setupGoodsTableView];
    
}

- (void)setupNav{
    BFNavView *nav = [[BFNavView alloc]initWithRight:YES];
    nav.titleLabel.text = @"足迹";
    [nav.rightBtn setImage:[UIImage imageNamed:@"ico_delete"] forState:UIControlStateNormal];
    [nav.rightBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(@64);
    }];
}

- (void)setupSelectView{
    UIView *selectBgView = [[UIView alloc]init];
    selectBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectBgView];
    [selectBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@44);
    }];
    //中间竖线
    UIView *verticalLine = [[UIView alloc]init];
    verticalLine.backgroundColor = [UIColor BF_ColorWithHex:0xEDE9E9];
    [selectBgView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectBgView).offset(7);
        make.bottom.equalTo(selectBgView).offset(-7);
        make.centerX.equalTo(selectBgView);
        make.width.mas_equalTo(@1);
    }];
    //左边按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn setTitle:@"商品" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [selectBgView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(selectBgView);
        make.right.equalTo(verticalLine.mas_left);
    }];
    self.leftBtn = leftBtn;
    [self.leftBtn setTitleColor:[UIColor BF_ColorWithHex:0xFF8300] forState:UIControlStateNormal];
    //右边按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setTitle:@"商铺" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBgView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(selectBgView);
        make.left.equalTo(verticalLine.mas_right);
    }];
    self.rightBtn = rightBtn;
    //左边底部横线
    UIView *leftBottomLine = [[UIView alloc]init];
    leftBottomLine.backgroundColor = [UIColor BF_ColorWithHex:0xFF8605];
    [leftBtn addSubview:leftBottomLine];
    [leftBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(leftBtn);
        make.left.equalTo(leftBtn).offset(22);
        make.right.equalTo(verticalLine.mas_left).offset(-22);
        make.height.mas_equalTo(@2);
    }];
    self.leftBottomLine = leftBottomLine;
    //右边底部横线
    UIView *rightBottomLine = [[UIView alloc]init];
    rightBottomLine.backgroundColor = [UIColor clearColor];
    [rightBtn addSubview:rightBottomLine];
    [rightBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rightBtn);
        make.right.equalTo(rightBtn).offset(-22);
        make.left.equalTo(verticalLine.mas_right).offset(22);
        make.height.mas_equalTo(@2);
    }];
    self.rightBottomLine = rightBottomLine;
}

- (void)setupGoodsTableView{
    //移除元素,防止覆盖
    [self.shopsTableView removeFromSuperview];
    [self.bottomBgView removeFromSuperview];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 112, kScreenWidth, kScreenHeight-112) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor BF_ColorWithHex:0xF9F9F9];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelectionDuringEditing = YES;
    [tableView registerClass:[BFLeftMainCell class] forCellReuseIdentifier:goodsCellID];
    
    [self.view addSubview:tableView];
    self.goodsTableView = tableView;
    //底部全选
    [self setupBottomStatus];
}

- (void)setupShopsTableView{
    //移除元素,防止覆盖
    [self.goodsTableView removeFromSuperview];
    [self.bottomBgView removeFromSuperview];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 112, kScreenWidth, kScreenHeight-112) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor BF_ColorWithHex:0xF9F9F9];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelectionDuringEditing = YES;
    [tableView registerClass:[BFRightMainCell class] forCellReuseIdentifier:shopsCellID];
    
    [self.view addSubview:tableView];
    self.shopsTableView = tableView;
    //底部全选
    [self setupBottomStatus];
}
//底部全选
- (void)setupBottomStatus{
    UIView *bottomBgView = [[UIView alloc]init];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(50);
        make.height.mas_equalTo(@50);
    }];
    self.bottomBgView = bottomBgView;
    
    //左侧全选按钮
    [self setLeftSelectAllBtn];
    //右侧删除按钮
    [self setRightDeleteBtn];
}
//左侧全选按钮
- (void)setLeftSelectAllBtn{
    UIButton *selectAll = [[UIButton alloc]init];
    [selectAll setTitle:@"全选" forState:UIControlStateNormal];
    [selectAll setTitleColor:[UIColor BF_ColorWithHex:0xA1A1A1] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(clickSelectAll) forControlEvents:UIControlEventTouchUpInside];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomBgView addSubview:selectAll];
    [selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.bottomBgView);
        make.width.mas_equalTo(@164);
    }];
    //图片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"select"];
    [selectAll addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectAll).offset(20);
        make.centerY.equalTo(selectAll);
        make.width.height.mas_equalTo(@25);
    }];
    self.selectAllImageView = imageView;
}
//右侧删除按钮
- (void)setRightDeleteBtn{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor BF_ColorWithHex:0xFF5A5A];
    [self.bottomBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bottomBgView);
        make.width.mas_equalTo(@(kScreenWidth-164));
    }];
}
#pragma mark - TableViewDelegate && dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    //文字
    UILabel *label = [[UILabel alloc]init];
    label.text = @"7月31号";
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor BF_ColorWithHex:0xB2B2B2];
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(22);
    }];
    //底部横线
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor BF_ColorWithHex:0xEFEFEF];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(headerView);
        make.height.mas_equalTo(@1);
    }];
    return headerView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.goodsTableView) {
        BFLeftMainCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID forIndexPath:indexPath];
        
        cell.goodsImageView.image = [UIImage imageNamed:@"1"];
        cell.goodsTitle.text = @"尼龙轮摇摆拉丝机 产品简洁高效";
        cell.address.text = @"浙江－杭州";
        cell.goodsPrice.text = @"2000元";
        cell.tipImageView.image = [UIImage imageNamed:@"renzheng"];
        
        return cell;
    }else{
        BFRightMainCell *cell = [tableView dequeueReusableCellWithIdentifier:shopsCellID forIndexPath:indexPath];
        
        cell.shopImageView.image = [UIImage imageNamed:@"1"];
        cell.shopName.text = @"济南宏雕智能科技有限公司";
        [cell.isVipBtn setTitle:@"家家通会员" forState:UIControlStateNormal];
        [cell.isVipBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle 16buleicon"] forState:UIControlStateNormal];
        cell.shopSales.text = @"塑料橡胶机械-工业冷水机";
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.goodsTableView) {
        //处于编辑状态下
        if (self.goodsTableView.editing) {
            BFLeftMainCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.collectBtn.selected = !cell.collectBtn.selected;
            if (cell.collectBtn.selected) {
                [cell.collectBtn setImage:[UIImage imageNamed:@"select copy2"] forState:UIControlStateNormal];
            }else{
                [cell.collectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            }
        }else{
            //非编辑状态下
        }
    }else{
        //处于编辑状态下
        if (self.shopsTableView.editing) {
            BFRightMainCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.collectBtn.selected = !cell.collectBtn.selected;
            if (cell.collectBtn.selected) {
                [cell.collectBtn setImage:[UIImage imageNamed:@"select copy2"] forState:UIControlStateNormal];
            }else{
                [cell.collectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            }
        }else{
            //非编辑状态下
        }
    }
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //编辑设置成自定义的必须把系统的设置为None
    return UITableViewCellEditingStyleNone;
}


//Method
- (void)updateMasonrys{
    [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(@50);
    }];
}
- (void)resetMasonrys{
    [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(50);
        make.height.mas_equalTo(@50);
    }];
}

#pragma mark - clickEvent
//右上角删除图标按钮点击事件
- (void)clickDelete{
    if (self.isSelect == 0) {
        self.goodsIsClips = !self.goodsIsClips;
        if (self.goodsIsClips) {
            [self updateMasonrys];
            [UIView animateWithDuration:0.5 animations:^{
                self.goodsTableView.frame = CGRectMake(0, 112, kScreenWidth, kScreenHeight-112-50);
                [self.view layoutIfNeeded];
            }];
            [self.goodsTableView setEditing:YES animated:YES];
        }else{
            [self resetMasonrys];
            [UIView animateWithDuration:0.5 animations:^{
                self.goodsTableView.frame = CGRectMake(0, 112, kScreenWidth, kScreenHeight-112);
                [self.view layoutIfNeeded];
            }];
            [self.goodsTableView setEditing:NO animated:NO];
        }
    }else{
        self.goodsIsClips = !self.goodsIsClips;
        if (self.goodsIsClips) {
            [self updateMasonrys];
            [UIView animateWithDuration:0.5 animations:^{
                self.shopsTableView.frame = CGRectMake(0, 112, kScreenWidth, kScreenHeight-112-50);
                [self.view layoutIfNeeded];
            }];
            [self.shopsTableView setEditing:YES animated:YES];
            
        }else{
            [self resetMasonrys];
            [UIView animateWithDuration:0.5 animations:^{
                self.shopsTableView.frame = CGRectMake(0, 112, kScreenWidth, kScreenHeight-112);
                [self.view layoutIfNeeded];
            }];
            [self.shopsTableView setEditing:NO animated:NO];
        }
    }
}


//全选按钮点击事件
- (void)clickSelectAll{
    if (self.isSelect == 0) {
        for (BFLeftMainCell *cell in self.goodsTableView.visibleCells) {
            cell.collectBtn.selected = !cell.collectBtn.selected;
            if (cell.collectBtn.selected) {
                [cell.collectBtn setImage:[UIImage imageNamed:@"select copy2"] forState:UIControlStateNormal];
                self.selectAllImageView.image = [UIImage imageNamed:@"select copy2"];
            }else{
                [cell.collectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                self.selectAllImageView.image = [UIImage imageNamed:@"select"];
            }
        }
    }else{
        for (BFRightMainCell *cell in self.shopsTableView.visibleCells) {
            cell.collectBtn.selected = !cell.collectBtn.selected;
            if (cell.collectBtn.selected) {
                [cell.collectBtn setImage:[UIImage imageNamed:@"select copy2"] forState:UIControlStateNormal];
                self.selectAllImageView.image = [UIImage imageNamed:@"select copy2"];
            }else{
                [cell.collectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                self.selectAllImageView.image = [UIImage imageNamed:@"select"];
            }
        }
    }
}

//切换成商品界面
- (void)clickLeftBtn{
    self.isSelect = 0;
    [self.leftBtn setTitleColor:[UIColor BF_ColorWithHex:0xFF8300] forState:UIControlStateNormal];
    self.leftBottomLine.backgroundColor = [UIColor BF_ColorWithHex:0xFF8605];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightBottomLine.backgroundColor = [UIColor clearColor];
    [self setupGoodsTableView];
}
//切换成商铺界面
- (void)clickRightBtn{
    self.isSelect = 1;
    [self.rightBtn setTitleColor:[UIColor BF_ColorWithHex:0xFF8300] forState:UIControlStateNormal];
    self.rightBottomLine.backgroundColor = [UIColor BF_ColorWithHex:0xFF8605];
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftBottomLine.backgroundColor = [UIColor clearColor];
    [self setupShopsTableView];
}



@end
