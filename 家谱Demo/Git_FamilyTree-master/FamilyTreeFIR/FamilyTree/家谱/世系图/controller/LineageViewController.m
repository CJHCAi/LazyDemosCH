//
//  LineageViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "LineageViewController.h"
#import "CommonNavigationViews.h"
#import "LineageCellView.h"
#import "SelectMyFamilyView.h"
#import "LineageModel.h"
#import <AVFoundation/AVFoundation.h>

#define cell_width 50
#define cell_height 75
#define cellXSpace 50
#define cellYSpace 35


@interface LineageViewController()<CommandNavigationViewsDelegate,SelectMyFamilyViewDelegate,UIScrollViewDelegate>
{
    
}

/** 家谱选择视图*/
@property (nonatomic, strong) SelectMyFamilyView *selecMyFamView;
/** 滚动视图*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** 背景视图*/
@property (nonatomic, strong) UIImageView *backIV;
/** 待定视图*/
@property (nonatomic, strong) UIView *backV;
/** 选定的家谱成员id*/
@property (nonatomic, assign) NSInteger selectedusr;
/** 总模型*/
@property (nonatomic, strong) LineageModel *lineageModel;
/** 家族字典*/
@property (nonatomic, strong) NSMutableDictionary *dic;
///** 所有数据的数组*/
//@property (nonatomic, strong) NSArray<LineageDatalistModel *> *totalArr;
/** 正在画第几代*/
@property (nonatomic, assign) NSInteger isWritingLayer;
/** 画关系视图*/
@property (nonatomic, strong) UIView *lineView;
/** 总共画几代*/
@property (nonatomic, assign) NSInteger layers;
/** 锁*/
@property (nonatomic, strong) NSLock *lock;

/** 已经排到多少顺序了*/
@property (nonatomic, assign) NSInteger showSeq;
/** 音乐播放器*/
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation LineageViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.comNavi.delegate = self;
    self.selectedusr = 1002726;
    [self initUI];
    //添加人
    [self downloadRelative:self.selectedusr];
}

#pragma mark - 视图初始化
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.backIV];
    [self.backIV addSubview:self.backV];


}

-(void)buildView{
    [self.lock tryLock];
    for (UIView *view in [self.backV subviews]) {
        //if (view.tag != self.selectedusr) {
            [view removeFromSuperview];
        //}
    }
    //确定滚动图范围
    NSInteger maxLayers = 0;
    NSInteger minLayers = 100;
    NSInteger seqs = 0;
    for (id key in self.dic) {
        LineageDatalistModel *model = (LineageDatalistModel *)self.dic[key];
       if (model.layers > maxLayers) {
            maxLayers = model.layers;
        }
        if (model.layers < minLayers) {
            minLayers = model.layers;
        }
        if (model.seq > seqs) {
            seqs = model.seq;
        }
    }
    self.layers = maxLayers - minLayers+1;
    MYLog(@"总代数%ld",self.layers);
    MYLog(@"总排序位置%ld",seqs);
    
    self.scrollView.contentSize = CGSizeMake(cell_width*seqs+cellXSpace*(seqs+1)+500>self.scrollView.bounds.size.width?(cell_width*seqs+cellXSpace*(seqs+1)+500):self.scrollView.bounds.size.width, cell_height*self.layers+cellYSpace*(self.layers+1)>self.scrollView.bounds.size.height?(cell_height*self.layers+cellYSpace*(self.layers+1)):self.scrollView.bounds.size.height);
    self.backIV.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    self.backV.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    self.scrollView.contentOffset = CGPointMake((self.scrollView.contentSize.width-Screen_width)/2, (self.scrollView.contentSize.height-self.backV.frame.size.height)/2);
//    MYLog(@"横向%lf,纵向%lf",self.scrollView.contentOffset,(self.scrollView.contentSize.height-self.backV.frame.size.height)/2);
    //MYLog(@"%lf",self.scrollView.contentSize.height);
    
    //向上找
    //排序
    for (int i = (short)maxLayers ;i > minLayers-1; i--) {
        self.isWritingLayer = i - minLayers+1;
        NSMutableArray *arr = [@[] mutableCopy];
        for (id key in self.dic) {
            LineageDatalistModel *model = (LineageDatalistModel *)self.dic[key];
            if (model.layers == i) {
                [arr addObject:model];
            }
        }
        //放图
        [self buildSameLayer:[arr copy]];
    }
}

-(void)buildSameLayer:(NSArray<LineageDatalistModel *> *)arr{
    if (self.isWritingLayer == self.layers){
        for (LineageDatalistModel *model in arr) {
        LineageCellView *cell = [[LineageCellView alloc]initWithFrame:CGRectMake(cellXSpace*(model.seq)+cell_width*(model.seq-1),cellYSpace * self.isWritingLayer + cell_height * (self.isWritingLayer-1), cell_width, cell_height)];
        //MYLog(@"高%lf",cell.frame.origin.y);
        //cell.backgroundColor = [UIColor redColor];
        cell.model = model;
        cell.tag = model.userid;
        [self.backV addSubview:cell];
        //选定为红色
        if (cell.model.userid == self.selectedusr) {
            cell.nameLB.textColor = [UIColor redColor];
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.center.x-Screen_width/2, self.scrollView.center.y-Screen_height/2)];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [self startMusic];
            [self downloadRelative:cell.model.userid];
        }];
        [cell addGestureRecognizer:tap];
        }
    }else{
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"seq" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray<LineageDatalistModel *> *sortedArray = [arr sortedArrayUsingDescriptors:sortDescriptors];
        //NSInteger haveTotalSon = 0;
        for (int i = 0;i < sortedArray.count;i++){
            MYLog(@"层级%ld",sortedArray[i].seq);
            //有几个子女
            //NSInteger haveSon = 0;
            LineageCellView *cell;
            CGFloat x;
            NSMutableArray<LineageDatalistModel *> *sonArr = [@[] mutableCopy];
            for (id key in self.dic) {
                LineageDatalistModel *model1 = (LineageDatalistModel *)self.dic[key];
                if (sortedArray[i].userid == model1.parentid && sortedArray[i].userid != model1.userid) {
                    //haveSon++;
                    [sonArr addObject:model1];
                }
            }
            if (sonArr.count != 0) {
                if (sonArr.count == 1) {
                    UIView *view = [self.backV viewWithTag:sonArr.firstObject.userid];
                    x = view.frame.origin.x;
                }else{
                    if (sonArr.count%2 == 1) {
                        UIView *view = [self.backV viewWithTag:sonArr[sonArr.count/2+1].userid];
                        x = view.frame.origin.x;
                    }else{
                        UIView *view = [self.backV viewWithTag:sonArr[sonArr.count/2].userid];
                        x = view.frame.origin.x+cellXSpace;
                    }
                }
                cell = [[LineageCellView alloc]initWithFrame:CGRectMake(x, cellYSpace * self.isWritingLayer + cell_height * (self.isWritingLayer-1), cell_width, cell_height)];
            }else{
                //没有儿子的
                //前一个view
                if (i == 0) {
                    cell = [[LineageCellView alloc]initWithFrame:CGRectMake(cellXSpace, cellYSpace * self.isWritingLayer + cell_height * (self.isWritingLayer-1), cell_width, cell_height)];
                }else{
                    UIView *lastView = [self.backV viewWithTag:sortedArray[i-1].userid];
                    cell = [[LineageCellView alloc]initWithFrame:CGRectMake(CGRectX(lastView)+cell_width+cellXSpace, cellYSpace * self.isWritingLayer + cell_height * (self.isWritingLayer-1), cell_width, cell_height)];
                }
                
            }
            cell.model = sortedArray[i];
            cell.tag = sortedArray[i].userid;
            [self.backV addSubview:cell];
            //选定为红色
            if (cell.model.userid == self.selectedusr) {
                cell.nameLB.textColor = [UIColor redColor];
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.center.x-Screen_width/2, self.scrollView.center.y-Screen_height/2)];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                if (![self.lock tryLock]) {
                    return ;
                }
                [self startMusic];
                [self downloadRelative:cell.model.userid];
            }];
            [cell addGestureRecognizer:tap];

            }
        
    }
}

//播放音效
-(void)startMusic{
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"clicksxt" withExtension:@"wav"];
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//重新写个方法
-(void)buildNewView{
    [self.lock tryLock];
    for (UIView *view in [self.backV subviews]) {
        [view removeFromSuperview];
    }
    //确定滚动图范围
    NSInteger maxLayers = 0;
    NSInteger minLayers = 100;
    NSInteger seqs = 0;
    for (id key in self.dic) {
        LineageDatalistModel *model = (LineageDatalistModel *)self.dic[key];
        if (model.layers > maxLayers) {
            maxLayers = model.layers;
        }
        if (model.layers < minLayers) {
            minLayers = model.layers;
        }
        if (model.seq > seqs) {
            seqs = model.seq;
        }
    }
    self.layers = maxLayers - minLayers+1;
    MYLog(@"总代数%ld",self.layers);
    MYLog(@"总排序位置%ld",seqs);
    
    self.scrollView.contentSize = CGSizeMake(cell_width*seqs+100>self.scrollView.bounds.size.width?(cell_width*seqs+100):self.scrollView.bounds.size.width, cell_height*self.layers+100>self.scrollView.bounds.size.height?(cell_height*self.layers+100):self.scrollView.bounds.size.height);
    self.backIV.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    self.backV.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    self.scrollView.contentOffset = CGPointMake((self.scrollView.contentSize.width-Screen_width)/2, (self.scrollView.contentSize.height-self.backV.frame.size.height)/2);
    //    MYLog(@"横向%lf,纵向%lf",self.scrollView.contentOffset,(self.scrollView.contentSize.height-self.backV.frame.size.height)/2);
    //MYLog(@"%lf",self.scrollView.contentSize.height);
    
    //
    for (int i = (short)maxLayers ;i > minLayers-1; i--) {
        self.isWritingLayer = i - minLayers + 1;
        //如果是最后一排
        for (id key in self.dic) {
            LineageDatalistModel *model = (LineageDatalistModel *)self.dic[key];
            
        }
    }
    
    //排序
    for (int i = (short)maxLayers ;i > minLayers-1; i--) {
        self.isWritingLayer = i - minLayers+1;
        NSMutableArray *arr = [@[] mutableCopy];
        for (id key in self.dic) {
            LineageDatalistModel *model = (LineageDatalistModel *)self.dic[key];
            if (model.layers == i) {
                [arr addObject:model];
            }
        }
        //放图
        [self buildSameLayer:[arr copy]];
    }
}

-(void)buildNewOne{
    
}


-(void)drawRelation{
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectW(self.backV), CGRectH(self.backV))];
    self.lineView.userInteractionEnabled = NO;
    [self.backV addSubview:self.lineView];
    for (LineageCellView *view in [self.backV subviews]) {
        if ([view isKindOfClass:[LineageCellView class]]) {
            //判断父亲位置
            if (view.model.parentid != 0 && [self.view viewWithTag:view.model.parentid]) {
                CGPoint point1 = CGPointMake(CGRectX(view)+CGRectW(view)/2, CGRectY(view));
                CGPoint point2 = CGPointMake(point1.x, point1.y-cellYSpace/2);
                CGPoint point3;
                CGPoint point4;
                //右边
                if ([self.view viewWithTag:view.model.parentid].frame.origin.x > view.frame.origin.x) {
                    point3 = CGPointMake([self.view viewWithTag:view.model.parentid].frame.origin.x+cell_width/2, point2.y);
                }
                if ([self.view viewWithTag:view.model.parentid].frame.origin.x < view.frame.origin.x) {
                    point3 = CGPointMake([self.view viewWithTag:view.model.parentid].frame.origin.x+cell_width/2, point2.y);
                }
                if ([self.view viewWithTag:view.model.parentid].frame.origin.x == view.frame.origin.x) {
                    point3 = point2;
                }
                point4 = CGPointMake(point3.x, point3.y-cellYSpace/2);
                [self drawLine:[UIColor blackColor] point1:point1 point2:point2 point3:point3 point4:point4];
            }
        }
    }
    [self.lock unlock];
}


-(void)drawLine:(UIColor *)lineColor point1:(CGPoint)p1 point2:(CGPoint)p2 point3:(CGPoint)p3 point4:(CGPoint)p4{
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath = CGPathCreateMutable();
    [solidShapeLayer setFillColor:[UIColor clearColor].CGColor];
    [solidShapeLayer setStrokeColor:lineColor.CGColor];
    solidShapeLayer.lineWidth = 1.0f;
    CGPathMoveToPoint(solidShapePath, NULL, p1.x, p1.y);
    CGPathAddLineToPoint(solidShapePath, NULL, p2.x, p2.y);
    CGPathAddLineToPoint(solidShapePath, NULL, p3.x, p3.y);
    CGPathAddLineToPoint(solidShapePath, NULL, p4.x, p4.y);
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [self.lineView.layer addSublayer:solidShapeLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.5f];
    pathAnimation.toValue = [NSNumber numberWithFloat:0.8f];
    [solidShapeLayer addAnimation:pathAnimation forKey:nil];
    
}



#pragma makr - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    MYLog(@"%lf",scrollView.contentOffset);
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.backV;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat xcenter = scrollView.center.x,ycenter =scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2:xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height?scrollView.contentSize.height/2:ycenter;
    [self.backV setCenter:CGPointMake(xcenter, ycenter)];
}



#pragma mark - getData
-(void)downloadRelative:(NSInteger )userid{
    self.selectedusr = userid;
    WK(weakSelf)
//    NSDictionary *logDic = @{@"genid":[WFamilyModel shareWFamilModel].myFamilyId,
//                             @"userid":@(userid),
//                             @"gentions":@1,
//                             @"loginid":GetUserId};
    NSDictionary *logDic = @{@"genid":@10000,
                            @"userid":@(userid),
                            @"gentions":@1,
                             @"loginid":@""};
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodequerytreebygenid success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            weakSelf.lineageModel = [LineageModel modelWithJSON:jsonDic[@"data"]];
            //weakSelf.totalArr = weakSelf.lineageModel.datalist;
            NSArray *arr = weakSelf.lineageModel.datalist;
            self.dic = [NSMutableDictionary dictionary];
            for (LineageDatalistModel *model in arr) {
                [weakSelf.dic setObject:model forKey:[NSString stringWithFormat:@"%ld",(long)model.userid]];
            }
//            MYLog(@"啦啦%@",weakSelf.dic[@"1002726"]);
            [weakSelf buildView];
            [weakSelf drawRelation];
            
//            [weakSelf buildNewView];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark *** 选择右上角家谱后的更新UI ***
-(void)CommonNavigationViews:(CommonNavigationViews *)comView selectedFamilyId:(NSString *)famId{
    NSLog(@"选择了这个家谱id-%@", famId);
//    [WFamilyModel shareWFamilModel].myFamilyId = famId;
//    [self downloadRelative:self.selectedusr];
}


#pragma mark - lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _scrollView.contentSize = CGSizeMake(self.backIV.bounds.size.width, self.backIV.bounds.size.height);
        _scrollView.delegate=self;
        _scrollView.maximumZoomScale=2.0;
        _scrollView.minimumZoomScale=0.5;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

-(UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectW(self.scrollView), CGRectH(self.scrollView))];
        _backIV.image = MImage(@"bg1");
        _backIV.contentMode = UIViewContentModeScaleToFill;
        _backIV.userInteractionEnabled = YES;
    }
    return _backIV;
}

-(UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectW(self.backIV), CGRectY(self.backIV))];
        _backV.backgroundColor = [UIColor clearColor];
    }
    return _backV;
}

-(NSLock *)lock{
    if (!_lock) {
        _lock = [[NSLock alloc]init];
    }
    return _lock;
}


@end
