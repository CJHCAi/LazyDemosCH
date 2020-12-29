//
//  HKSelfMeidaVodeoViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMeidaVodeoViewController.h"
#import "HKSelfMeidaVodeoTableViewCell.h"
#import "GetMediaAdvAdvByIdRespone.h"
#import "HKSelfMeidaVodeoViewModel.h"
#import "HKSelfVideoToolViewController.h"
#import "HKLeSeeViewModel.h"
#import "GetMediaAdvAdvByIdRespone.h"
#import "HKRewardViewsController.h"
#import "HKSelfMeidaVodeoNavView.h"
#import "WHFullAliyunVideoView.h"
#import "HK_VideoConfogueTool.h"
#import "GrabRedEnvelopeViewController.h"
#import "HKDetailsPageViewController.h"
#import "HKLeSeeVideoMyGoodsViewController.h"
#import "HKMyFriendListViewModel.h"
@interface HKSelfMeidaVodeoViewController ()<UITableViewDelegate,UITableViewDataSource,HKSelfMeidaVodeoTableViewCellDelegate,HKSelfMeidaVodeoNavViewDelagate,WHFullAliyunVideoViewDelegate,GrabRedEnvelopeViewControllerDelegate,HKSelfVideoToolViewControllerDeleagte,HKLeSeeVideoMyGoodsViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)HKSelfMeidaVodeoTableViewCell *playCell;
@property (nonatomic, strong)NSMutableArray *vodeoArray;
@property(nonatomic, assign) CGFloat y;

@property (nonatomic, strong)HKSelfMeidaVodeoNavView *navView;
@property (nonatomic, strong)WHFullAliyunVideoView *aliyunPlayView;
@property (nonatomic, strong)UIImageView *reward;
@property (nonatomic,weak) HKSelfVideoToolViewController *toolVc;
@end

@implementation HKSelfMeidaVodeoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.aliyunPlayView reset];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.view addSubview:self.reward];
    [self.reward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.pagingEnabled = YES;
    }
    return _tableView;
}
-(void)backVc{
    [self.aliyunPlayView releasePlayer];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)headMoreSender:(NSInteger)tag withResponse:(GetMediaAdvAdvByIdRespone *)response {
    if (tag==10) {
        HKMyFollowAndFansList *list =[[HKMyFollowAndFansList alloc] init];
        list.headImg = response.data.headImg;
        list.uid = response.data.uid;
        list.name  =response.data.uName;
        [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
    }else {
        [SRActionSheet sr_showActionSheetViewWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"加入黑名单",@"举报"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
            if (index ==0) {
                [HKMyFriendListViewModel addFriendToBlackListWithUserId:response.data.uid success:^(id response) {
                    [EasyShowTextView showText:@"成功加入黑名单"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addBlackList" object:nil];
                    [AppUtils hanldeSuccessPopAfterSecond:1.5 WithCunrrentController:self];
                    
                } fial:^(NSString *error) {
                    [EasyShowTextView showText:error];
                }];
            }else {
                [HKMyFriendListViewModel addUserContentReportVc:self];
            }
        }];
    }
}
-(void)toolClick:(UIButton *)sender{
    [self showtoolViewWIthIndex:sender.tag andIndexPath:self.playCell.indexpath];
}

-(void)more {
    HKSelfVideoToolViewController*vc = [[HKSelfVideoToolViewController alloc]init];
    vc.delegate = self;
    vc.responde = self.playCell.dataM; self.navigationController.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0];
    self.toolVc = vc;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
-(void)playSurplusTime:(NSInteger)surplusTime{
    self.navView.time = surplusTime;
}
#pragma tableView--delegate
#pragma tableView
-(void)commitSuc{
    self.aliyunPlayView.dataM =  self.aliyunPlayView.dataM;
}
-(void)gotoGoodsInfo:(GetMediaAdvAdvByIdProducts *)goodsId{
    HKDetailsPageViewController*detailVc = [[HKDetailsPageViewController alloc]init];
    detailVc.productM = goodsId;
    detailVc.provinceId = @"001";
    [self.navigationController pushViewController:detailVc animated:YES];
}
-(void)rewardLeB{
    int type = 0;
    NSDictionary*dic;
     SelfMediaModelList*model = self.dataArray[_playCell.indexpath.row];
    if (model.isCity) {
        type = 1;
        dic = @{@"loginUid":HKUSERLOGINID,@"money":@(1),@"cityAdvId":model.ID.length>0?model.ID:@""};
    }else{
       dic = @{@"loginUid":HKUSERLOGINID,@"money":@(1),@"id":model.ID.length>0?model.ID:@""};
    }
    
    [HKLeSeeViewModel advReward:dic type:type success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [self showReward:1];
            
        }else{
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:responde.msg];
        }
    }];
}
-(void)showtoolViewWIthIndex:(NSInteger)index andIndexPath:(NSIndexPath *)indexPath{
    if (index == 2) {
        HKSelfVideoToolViewController*vc = [[HKSelfVideoToolViewController alloc]init];
        vc.delegate = self;
         vc.responde = self.playCell.dataM; self.navigationController.definesPresentationContext = YES;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0];
        self.toolVc = vc;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }else if (index == 1){
        NSString*staue = @"1";
        if (self.playCell.dataM.data.praiseState.intValue == 1) {
            staue = @"0";
        }
        [HKLeSeeViewModel praise:@{@"loginUid":HKUSERLOGINID,@"id":self.playCell.model.ID,@"state":staue}type:0 success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
              self.aliyunPlayView.dataM.data.praiseCount = [NSString stringWithFormat:@"%@",responde.data];
                self.aliyunPlayView.dataM.data.praiseState = staue;
                self.aliyunPlayView.dataM = self.aliyunPlayView.dataM;
//                [self.playCell layoutIfNeeded];
            }
        }];
    }else if (index == 3){
        [self rewardLeB];
//        [HKRewardViewsController showReward:self andType:0 andId:self.playCell.model.ID];
    }else if (index == 0){
        //收藏
        if (self.dataArray.count>0) {
            NSString*staue = @"1";
            if (self.playCell.dataM.data.collectionState.intValue == 1) {
                staue = @"0";
            }
            if ([self.dataArray.firstObject isCity]) {
                [HKLeSeeViewModel collection:@{@"loginUid":HKUSERLOGINID,@"state":staue,@"cityAdvId":self.playCell.dataM.data.cityAdvId} type:1 success:^(HKBaseResponeModel *responde) {
                    [self settingSave:responde staue:staue];
                }];
            }else{
                [HKLeSeeViewModel collection:@{@"loginUid":HKUSERLOGINID,@"state":staue,@"id":self.playCell.dataM.data.ID} type:0 success:^(HKBaseResponeModel *responde) {
                    [self settingSave:responde staue:staue];
                }];
            }
        }
    }else{
        HKLeSeeVideoMyGoodsViewController*vc = [[HKLeSeeVideoMyGoodsViewController alloc]init];
        vc.delegate = self;
        vc.dataArray = self.playCell.dataM.data.products; self.navigationController.definesPresentationContext = YES;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0];
        self.toolVc = vc;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        
    }
}
-(void)settingSave:(HKBaseResponeModel*)respone staue:(NSString*)staue{
    if (respone.responeSuc) {
        self.aliyunPlayView.dataM.data.collectionCount = (NSString*)respone.data;
        self.aliyunPlayView.dataM.data.collectionState = staue;
        self.aliyunPlayView.dataM =  self.aliyunPlayView.dataM;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSelfMeidaVodeoTableViewCell*cell = [HKSelfMeidaVodeoTableViewCell baseCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    cell.indexpath = indexPath;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenHeight;
}


-(void)playAliyunVodPlayerEventFinish{
    [self.toolVc dismissViewControllerAnimated:YES completion:nil];
    if ( self.playCell.dataM.data.rewardCount == 0) {
        
        [self playNextCell];
        
    }else{
        [GrabRedEnvelopeViewController showWithSuperVC:self vodeoId:self.playCell.dataM];
    }
}
-(void)playNextCell{
    
    if(self.playCell.indexpath.row+1<=self.dataArray.count-1) {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.playCell.indexpath.row+1 inSection:0];
//        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+kScreenHeight)animated:YES];
//        [UIView animateWithDuration:0.2 animations:^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }completion:^(BOOL finished) {
//            if (finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HKSelfMeidaVodeoTableViewCell *finnalCell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            if (finnalCell) {
                self.playCell = finnalCell;
                
            }else{
                
            }
        });
        
//            }
      
//        }];
    

    }
}
-(void)handleScrollStop{
        HKSelfMeidaVodeoTableViewCell *finnalCell = nil;
        NSArray *visiableCells = [self.tableView visibleCells];
          CGFloat gap = MAXFLOAT;
        for (HKSelfMeidaVodeoTableViewCell *cell in visiableCells) {
            if (![cell isKindOfClass:[HKSelfMeidaVodeoTableViewCell class]]) return;
            CGPoint coorCentre = [cell.superview convertPoint:cell.center toView:nil];
            CGFloat delta = fabs(coorCentre.y-[UIScreen mainScreen].bounds.size.height*0.5);
            if (delta < gap) {
                gap = delta;
                finnalCell = cell;
            }
            
        }
    
        if (finnalCell!=self.playCell)  {
            self.indexPath = finnalCell.indexpath;
//            [self.aliyunPlayView reset];
            self.playCell = finnalCell;
            return;
        }
        
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self handleScrollStop];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO) { // scrollView已经完全静止
        [self handleScrollStop];
    }
}

// 松手时还在运动, 先调用scrollViewDidEndDragging,在调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // scrollView已经完全静止
    [self handleScrollStop];
}
-(void)setPlayCell:(HKSelfMeidaVodeoTableViewCell *)playCell{
    _playCell = playCell;
    

    SelfMediaModelList*model = self.dataArray[_playCell.indexpath.row];
    if (model.isCity) {
        [HKSelfMeidaVodeoViewModel getCityAdvMediaInfo:@{@"loginUid":HKUSERLOGINID,@"cityAdvId":model.ID} success:^(GetMediaAdvAdvByIdRespone *responde) {
            if (responde.responeSuc) {
                responde.data.playId = model.ID;
                [self.vodeoArray addObject:responde];
                self.playCell.dataM = responde;
                self.navView.respone = responde;
                [self.aliyunPlayView playWithVid:responde.data.imgSrc playView:self.playCell.iconView];
            }
        }];
    }else{
        if (model.respone) {
            [self playVideoWithID:model.respone];
        }else{
            [self loadDataCurrentWithId:model.ID];
        }
        
    }
}

-(void)playVideoWithID:(GetMediaAdvAdvByIdRespone*)respone{
    [self.vodeoArray addObject:respone];
    _playCell.dataM = respone;
    [self.aliyunPlayView reset];
    self.aliyunPlayView.superView = _playCell.iconView;
    self.aliyunPlayView.dataM= respone;
    self.navView.respone = respone;
    [self.aliyunPlayView playWithVid:respone.data.imgSrc];
    [self loadNextData:respone.data.nextMediaAdvId];
    //加入播放历史中..
//       [HK_VideoConfogueTool addVideoWatchHistoryWithVideoID:respone.data.ID successBlock:^(id response) {} fial:^(NSString *fials) {
//
//           [EasyShowTextView showText:fials];
//         
//       }];
}
//加载当前视频数据
-(void)loadDataCurrentWithId:(NSString*)ID{
    NSString *source = self.sourceType.length >0?@"2":@"1";
    [HKSelfMeidaVodeoViewModel getMediaAdvAdvById:@{@"loginUid":HKUSERLOGINID,@"id":ID.length>0?ID:@"",@"sourceType":source} success:^(GetMediaAdvAdvByIdRespone *responde) {
        if (responde.responeSuc) {
            responde.data.playId = ID;
            [self playVideoWithID:responde];
        }else{
             [self.aliyunPlayView playWithVid:responde.data.imgSrc playView:self.playCell.iconView];
               [SVProgressHUD showErrorWithStatus:@"视频地址无效"];
        }
        
    }];
}//4afc40270f934fc3aa138f2c5433c610,a6a1f1938b074da3b476230a1d449407
//加载下一个数据
-(void)loadNextData:(NSString*)ID{
   
    [HKSelfMeidaVodeoViewModel getMediaAdvAdvById:@{@"loginUid":HKUSERLOGINID,@"id":ID.length>0?ID:@"",@"sourceType":@"1"} success:^(GetMediaAdvAdvByIdRespone *responde) {
        if (responde.responeSuc) {
            responde.data.playId = ID;
            [self addCellAndData:responde];
        }
        
    }];
}
-(void)addCellAndDataIndex:(NSIndexPath*)indexPath{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
-(void)addCellAndData:(GetMediaAdvAdvByIdRespone*)responde{
    SelfMediaModelList*nextModel = [[SelfMediaModelList alloc]init];
    nextModel.respone = responde;
    [self.dataArray addObject:nextModel];
    [self addCellAndDataIndex:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]];
}
-(void)setDataArray:(NSMutableArray *)dataArray{
        _dataArray = dataArray;
    DLog(@"..%zd",dataArray.count);
        [self.tableView reloadData];
}
-(void)setSelectRow:(NSInteger)selectRow{
    _selectRow = selectRow;
     self.indexPath = [NSIndexPath indexPathForRow:selectRow inSection:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView setContentOffset:CGPointMake(0, selectRow*kScreenHeight)];
        
        [self handleScrollStop];
    });
   
}
-(void)hideReward{
    [UIView animateWithDuration:0.1 animations:^{
        self.reward.hidden = YES;
    }];
}
-(void)showReward:(int)sause{
    if (sause == 1) {
        self.reward.image = [UIImage imageNamed:@"dashang1"];
    }else{
        self.reward.image = [UIImage imageNamed:@"buzu"];
    }
    self.reward.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        self.reward.hidden = NO;
    }completion:^(BOOL finished) {
        if (finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.reward.hidden = YES;
            });
        }
    }];
}
- (NSMutableArray *)vodeoArray
{
    if(_vodeoArray == nil)
    {
        _vodeoArray = [ NSMutableArray array];
    }
    return _vodeoArray;
}
-(HKSelfMeidaVodeoNavView *)navView{
    if (!_navView ) {
        _navView = [[HKSelfMeidaVodeoNavView alloc]init];
        _navView.delegate = self;
    }
    return _navView;
}
-(WHFullAliyunVideoView *)aliyunPlayView{
    if (!_aliyunPlayView) {
        _aliyunPlayView = [[WHFullAliyunVideoView alloc]init];
        _aliyunPlayView.delegate = self;
    }
    return _aliyunPlayView;
}
-(UIImageView *)reward{
    if (!_reward) {
        _reward = [[UIImageView alloc]init];
        _reward.image = [UIImage imageNamed:@"dashang1"];
        _reward.hidden = YES;
    }
    return _reward;
}
@end
