//
//  CommodityDetailsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "CommodityDetailsViewController.h"
#import "CommodityDetailsRespone.h"
#import "CommodityDetailsViewModel.h"
#import "HKTDetailImageableViewCell.h"
#import "HKDetaikDescTableViewCell.h"
#import "HKDetailshopTableViewCell.h"
#import "HKPurchaseToolView.h"
#import "HKSelectCommodityParametersViewController.h"
#import "HKBaseCartListViewController.h"
#import "HKHtmlTableViewCell.h"
#import "HKDetailsPageViewController.h"
#import "HKConfirmationOfOrderViewController.h"
#import "HK_CladlyChattesView.h"
//#import "RCUserInfo.h"
@interface CommodityDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,HKDetailshopTableViewCellDelegate,HKPurchaseToolViewDelegate>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)HKPurchaseToolView *toolView;
@end

@implementation CommodityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
//    [self loadData];
}

-(void)gotoSelectParameWithTag:(NSInteger)tag{
    
    [HKSelectCommodityParametersViewController showVc:self respone:self.responde];
}
-(void)gotoToolClick:(NSInteger)tag{
    if (tag == 0) {
        [self gotoShopsWithShopId:self.responde.data.shop.shopId];
    }else{
        HK_CladlyChattesView *chat = [[HK_CladlyChattesView alloc] init];
        
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = self.responde.data.userId;
        
        //设置聊天会话界面要显示的标题
        chat.title = self.responde.data.shop.name;
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    }
}
-(void)setUI{
    [self.view addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(50);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.toolView.mas_top);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    if (bottomOffset <= height){ 
        if ([self.delegate respondsToSelector:@selector(vcScrollViewDidScroll:isDown:)]) {
            [self.delegate vcScrollViewDidScroll:scrollView.contentOffset.y isDown:YES];
        }

    }else{
        if ([self.delegate respondsToSelector:@selector(vcScrollViewDidScroll:isDown:)]) {
            [self.delegate vcScrollViewDidScroll:scrollView.contentOffset.y isDown:NO];
        }

    }
   
        
        
}
-(void)setResponde:(CommodityDetailsRespone *)responde{
    _responde = responde;
    [self.tableView reloadData];
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.responde.data.descript.length>0) {
        return 4;
    }else{
        return 3;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKTDetailImageableViewCell*cell = [HKTDetailImageableViewCell baseCellWithTableView:tableView];
        if (self.responde) {
            
            cell.imageArray = self.responde.data.images;
        }
        return cell;
    }else if (indexPath.section == 1){
        HKDetaikDescTableViewCell*cell = [HKDetaikDescTableViewCell baseCellWithTableView:tableView];
        cell.respone = self.responde;
        return cell;
    }else if(indexPath.section == 2){
        HKDetailshopTableViewCell*cell = [HKDetailshopTableViewCell baseCellWithTableView:tableView];
        cell.delegate = self;
        cell.respone = self.responde;
        return cell;
    }else{
        HKHtmlTableViewCell *cell = [HKHtmlTableViewCell baseCellWithTableView:tableView];
        cell.htmlStr = self.responde.data.descript;
        return cell;
    }
}
-(void)gotoDetailsWithID:(NSString*)productId{
    HKDetailsPageViewController*vc = [[HKDetailsPageViewController alloc]init];
    vc.productId = productId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoShopsWithShopId:(NSString *)shopId {
    [AppUtils pushShopInfoWithShopId:shopId andCurrentVc:self];
}
-(void)gotoCat:(NSArray*)cartArray{
    HKConfirmationOfOrderViewController*vc = [[HKConfirmationOfOrderViewController alloc]init];
    vc.cartIdArray = [NSMutableArray arrayWithArray:cartArray];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(HKPurchaseToolView *)toolView{
    if (!_toolView) {
        _toolView = [[HKPurchaseToolView alloc]init];
        _toolView.delegate = self;
    }
    return _toolView;
}
@end
