//
//  HKCorporateAdvertisingViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCorporateAdvertisingInfoViewController.h"
#import "HKHeadVodeoView.h"
#import "HKSelfMeidaVodeoViewModel.h"
#import "EnterpriseAdvRespone.h"
#import "HKRecommendsCell.h"
#import "HKAdvertisingAtlasTableViewCell.h"
#import "AllAlbumByUserRespone.h"
#import "HKAllProductSeleMeadiTableViewCell.h"
#import "HKBaseParameter.h"
#import "AllProductByUserRespone.h"
#import "HKHeadVodeoView.h"
#import "HK_VideoConfogueTool.h"
#import "HKLeSeeViewModel.h"
#import "HKCollageShareView.h"
#import "HKShareBaseModel.h"
#import "HKMyFriendListViewModel.h"
#import "HKCompanyInfoController.h"
#import "HKGiftBoxViewController.h"
#import "HKExpectVideoTableViewCell.h"
#import "HKCenterTitleTableViewCell.h"
#import "HKAdvertisingVideoUserTableViewCell.h"
#import "HKEnterpriseProductsTableViewCell.h"
@interface HKCorporateAdvertisingInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HKHeadVodeoViewDelegate,HKExpectVideoTableViewCellDelegate,HKAdvertisingVideoUserTableViewCellDelegate>
@property (nonatomic, strong)HKHeadVodeoView *vodeoView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)EnterpriseAdvRespone *infoRespone;
@property (nonatomic, strong)AllAlbumByUserRespone *atlasRespone;
@property (nonatomic, strong)HKBaseParameter *parameter;
@property (nonatomic, strong)UIView *sessonHeadView;
@end

@implementation HKCorporateAdvertisingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
   //加入播放历史中.
    [HK_VideoConfogueTool addVideoWatchHistoryWithVideoID:self.ID successBlock:^(id response) {
    } fial:^(NSString *fials) {
       
    }];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)surplusTime:(NSInteger)surplusTime{
    self.infoRespone.videoTime = surplusTime;
    [self.tableView reloadData];
}
-(void)clickWithTag:(NSInteger)tag{
    if (!self.infoRespone) {
        return;
    }
    switch (tag) {
        case 0:{
            //举报..
//            [HKMyFriendListViewModel addUserContentReportVc:self];
            HKShareBaseModel*shareM = [[HKShareBaseModel alloc]init];
            shareM.advM = self.infoRespone;
            shareM.subVc = self;
            [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:shareM];
        }
            break;
        case 1:{
            NSString*state = @"1";
            if (self.infoRespone.data.collectionState.integerValue == 1) {
                state = @"0";
            }
            [HKLeSeeViewModel collection:@{@"loginUid":HKUSERLOGINID,@"state":state,@"id":self.infoRespone.data.ID} type:1 success:^(HKBaseResponeModel *responde) {
                if (responde.responeSuc) {
                    self.infoRespone.data.collectionState = state;
                    [self.tableView reloadData];
                }
            }];
        }
            break;
        case 2:{
            NSString*state = @"1";
            if (self.infoRespone.data.praiseState.integerValue == 1) {
                state = @"0";
            }
            [HKLeSeeViewModel praise:@{@"loginUid":HKUSERLOGINID,@"state":state,@"id":self.infoRespone.data.ID} type:1 success:^(HKBaseResponeModel *responde) {
                if (responde.responeSuc) {
                    self.infoRespone.data.praiseState = state;
                    self.infoRespone.data.praiseCount = (NSString*)responde.data;
                    [self.tableView reloadData];
                }
            }];
        }
            break;
        case 3:{
            HKShareBaseModel*shareM = [[HKShareBaseModel alloc]init];
            shareM.advM = self.infoRespone;
            shareM.subVc = self;
            [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:shareM];
        }
            break;
        case 4:
        {
          //企业主页..
            HKCompanyInfoController * info =[[HKCompanyInfoController alloc] init];
            [self.navigationController pushViewController:info animated:YES];
        }
        default:
            break;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.vodeoView.staue = HKPalyStaue_close;
    HKExpectVideoTableViewCell*cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.playType =  HKPalyStaue_stop;
}
-(void)loadNextData{
    self.parameter.pageNumber++;
    [self getAllProductByUserId];
}
-(void)loadData{
    [self loadVedioInfo];
//    [self loadAtlas];
//    [self getAllProductByUserId];
}
-(void)updatePlay:(HKPalyStaue)playType{
    if (playType == HKPalyStaue_play||playType == HKPalyStaue_resume) {
        if (self.vodeoView.staue == HKPalyStaue_play||self.vodeoView.staue == HKPalyStaue_resume) {
            self.vodeoView.staue = HKPalyStaue_pause;
        }
    }
    
}
-(void)updatePlayHead:(HKPalyStaue)staue{
    if (staue == HKPalyStaue_play||staue == HKPalyStaue_resume) {
        HKExpectVideoTableViewCell*cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if (cell.playType == HKPalyStaue_play||cell.playType == HKPalyStaue_resume) {
            cell.playType = HKPalyStaue_stop;
        }
    }
}
-(void)getAllProductByUserId{
    [HKSelfMeidaVodeoViewModel getAllProductByUserId:@{@"uid":self.parameter.uid,@"pageNumber":@(self.parameter.pageNumber)} success:^(AllProductByUserRespone *responde) {
        [self.tableView.mj_footer endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            NSMutableArray*array = [NSMutableArray arrayWithCapacity:2];
            [self.parameter.questionArray addObject:array];
            for (AllProductByUsersList*model in responde.data.list) {
                NSMutableArray*arrays = self.parameter.questionArray.lastObject;
                if (arrays.count<2) {
                    [arrays addObject:model];
                }else{
                    NSMutableArray*array = [NSMutableArray arrayWithCapacity:2];
                    [array addObject:model];
                    [self.parameter.questionArray addObject:array];
                    
                }
            }
            [self.tableView reloadData];
        }else{
            if (self.parameter.pageNumber>0) {
                self.parameter.pageNumber--;
            }
        }
    }];
}

-(void)playFinish{
    
    
    [HKSelfMeidaVodeoViewModel getEndPlayMediaAdvById:@{@"loginUid":HKUSERLOGINID,@"id":self.infoRespone.data.ID} type:1 success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc&&[responde.data isKindOfClass:[NSDictionary class]]) {
            self.infoRespone.isOpen = YES;
            NSDictionary*dictData =(NSDictionary*)responde.data;
            [self.tableView reloadData];
            if(dictData[@"integral"]){
                NSInteger type = [dictData[@"integral"]integerValue];
                if (type == 0) {
                    return ;
                }
                [HKGiftBoxViewController showGiftBoxwithSuperVc:self money:type];
            }
        }
    }];
}
-(void)loadVedioInfo{//0f139c7f2bcf4e85ade3d5721f801a07
    [HKSelfMeidaVodeoViewModel getEnterpriseAdv:@{@"id":self.ID.length>0?self.ID:@"",@"loginUid":HKUSERLOGINID} success:^(EnterpriseAdvRespone *responde) {
        
        if (responde.responeSuc) {
            self.vodeoView.iconUrl = responde.data.coverImgSrc;
            [self.vodeoView addVideoViewWithUrlString:responde.data.imgSrc];
            self.infoRespone = responde;
            self.title = responde.data.title;
            NSMutableArray*array = [NSMutableArray arrayWithCapacity:2];
            [self.parameter.questionArray addObject:array];
            for (HKAdvDetailsProducts*modelP in responde.data.products) {
                AllProductByUsersList*model = [[AllProductByUsersList alloc]init];
                model.ID = modelP.productId;
                model.title = modelP.title;
                model.price = modelP.integral;
                model.imgSrc = modelP.imgSrc;
                NSMutableArray*arrays = self.parameter.questionArray.lastObject;
                if (arrays.count<2) {
                    [arrays addObject:model];
                }else{
                    NSMutableArray*array = [NSMutableArray arrayWithCapacity:2];
                    [array addObject:model];
                    [self.parameter.questionArray addObject:array];
                    
                }
            }
            [self.tableView reloadData];
        }
    }];
}
//-(void)loadAtlas{
//    [HKSelfMeidaVodeoViewModel getAllAlbumByUserId:@{@"uid":HKUSERID,@"pageNumber":@"1",@"sortValue":@"desc"} success:^(AllAlbumByUserRespone *responde) {
//        if (responde.responeSuc) {
//            self.atlasRespone = responde;
//            [self.tableView reloadData];
//        }
//    }];
//}
-(void)setUI{
    [self.view addSubview:self.vodeoView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.vodeoView.mas_bottom);
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
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        view.backgroundColor = _tableView.backgroundColor;
        _tableView.tableFooterView = view;
//        _tableView.tableHeaderView = self.vodeoView;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.infoRespone.data.recommends.count;
    }else if (section == 2){
        if (self.infoRespone.data.products.count>0) {
            return 1;
        }else{
            return 0;
        }
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKAdvertisingVideoUserTableViewCell*cell = [HKAdvertisingVideoUserTableViewCell baseCellWithTableView:tableView];
        cell.respone = self.infoRespone;
        cell.delegate = self;
        return cell;
    }else  if (indexPath.section == 1) {
        HKExpectVideoTableViewCell*cell = [HKExpectVideoTableViewCell baseCellWithTableView:tableView];
        
        cell.videoId = self.infoRespone.data.imgSrc;
        cell.imageStr = self.infoRespone.data.officiaImgSrc;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 2){
        HKEnterpriseProductsTableViewCell*cell = [HKEnterpriseProductsTableViewCell baseCellWithTableView:tableView];
        cell.dataArray = self.infoRespone.data.products;;
        return cell;
    }else {
     
        HKRecommendsCell*cell = [HKRecommendsCell baseCellWithTableView:tableView];
        cell.model = self.infoRespone.data.recommends[indexPath.row];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
       HKCenterTitleTableViewCell*cell = [HKCenterTitleTableViewCell baseCellWithTableView:tableView];
        
        return cell;
    }
    if (section ==3&&self.infoRespone.data.recommends.count>0) {
   
        return self.sessonHeadView;;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section ==3) {
        if (self.infoRespone.data.recommends.count>0) {
            self.sessonHeadView.hidden = NO;
           return 50;
        }else{
            self.sessonHeadView.hidden = YES;
            return 0;
        }
        
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return;
      RecommendModle*model =  self.infoRespone.data.recommends[indexPath.row];
        HKCorporateAdvertisingInfoViewController*vc = [[HKCorporateAdvertisingInfoViewController alloc]init];
        vc.ID = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(HKHeadVodeoView *)vodeoView{
    if (!_vodeoView) {
        _vodeoView = [[HKHeadVodeoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
        _vodeoView.delegate = self;
    }
    return _vodeoView;
}
-(HKBaseParameter *)parameter{
    if (!_parameter) {
        _parameter = [[HKBaseParameter alloc]init];
        _parameter.pageNumber = 1;
        _parameter.uid = HKUSERID;
    }
    return _parameter;
}
-(UIView *)sessonHeadView{
    if (!_sessonHeadView) {
        UIView *head =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,40)];
        head.backgroundColor =[UIColor whiteColor];
        UILabel *prol =[[UILabel alloc] initWithFrame:CGRectMake(15,0,200,40)];
        [AppUtils getConfigueLabel:prol font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"相关视频"];
        UIView*lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorFromHexString:@"efefef"];
        [head addSubview:lineView];
        [head addSubview:prol];
        _sessonHeadView = head;
    }
    return _sessonHeadView;
}
@end
