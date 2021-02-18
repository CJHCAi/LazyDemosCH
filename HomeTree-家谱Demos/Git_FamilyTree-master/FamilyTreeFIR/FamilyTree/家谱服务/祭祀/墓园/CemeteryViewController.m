//
//  CemeteryViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

enum {
    BTNIntroTag,
    BTNJishiTag,
    BTNMianhuaiTag
};

#import "CemeteryViewController.h"
#import "CemDetailView.h"
#import "CemIntroViewController.h"
#import "CemGoodsShopView.h"
#import "InputCherishView.h"
#import "CemeteryModel.h"
#import "BarrageListModel.h"
#import "FlyBarrageTextView.h"
#import "CemGoodsShopModel.h"
#import "AllGoodsView.h"
#import "UIImageView+WebCache.h"
#import "QuartzCore/QuartzCore.h"
#import <AVFoundation/AVFoundation.h>

#define bacheight (Screen_height-self.tabBarController.tabBar.bounds.size.height-64)
@interface CemeteryViewController ()<InputCherishViewDelegate,UITextViewDelegate,CemGoodsShopViewDelegate>
{
    BOOL _selectedMianhuaiBtn;
}
@property (nonatomic,strong) UIScrollView *scrollView; /*背景滚动图*/

@property (nonatomic,strong) UIImageView *cemImageView; /*背景图*/

@property (nonatomic,strong) CemDetailView *detailView; /*详细墓碑内容*/

@property (nonatomic,strong) CemGoodsShopView *goodsView; /*祭祀商品*/

@property (nonatomic,strong) InputCherishView *inputView; /*输入缅怀语*/


/** 墓园详情模型*/
@property (nonatomic, strong) CemeteryModel *cemeteryModel;
/** 墓园弹幕模型(包括祭品)*/
@property (nonatomic, strong) BarrageListModel *barrageListModel;
/** 弹幕数组*/
@property (nonatomic, strong) NSMutableArray *barragesArr;
/** 弹幕颜色数组*/
@property (nonatomic, strong) NSArray *colorArray;
/** 定时器数组*/
@property (nonatomic, strong) NSMutableArray *timersArr;
/** 祭祀贡品商店物品数组*/
@property (nonatomic, strong) NSArray *goodsArr;
/** 已经购买的祭祀贡品数组*/
@property (nonatomic, strong) NSMutableArray *currentCemGoodsArr;
/** 用来显示已经购买的祭祀贡品视图*/
@property (nonatomic, strong) UIView *goodsBackView;
/** 播放器*/
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation CemeteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //音效
    [self startMusic];
    [self initUI];
    [self getCemeteryData];
    [self getCemeteryBarrageList];
    [self getCemeteryJSShopData];
    self.goodsBackView = [[UIView alloc]initWithFrame:AdaptationFrame(0, 760, 1.4*bacheight/AdaptationWidth(), 280)];
    [self.scrollView addSubview:self.goodsBackView];
    
    
}

#pragma mark - 添加音效
-(void)startMusic{
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"jisi" withExtension:@"mp3"];
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = -1;
    [self.player play];

}

#pragma mark *** 初始化数据 ***
-(void)getCemeteryData{
    NSDictionary *logDic = @{@"CeId":@(self.CeId)};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeCemeterDetail success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            weakSelf.cemeteryModel = [CemeteryModel modelWithJSON:jsonDic[@"data"]];
            weakSelf.detailView.cemeteryModel = weakSelf.cemeteryModel;
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)getCemeteryBarrageList{
    NSDictionary *logDic = @{@"CeId":@(self.CeId)};
    WK(weakSelf);
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeBarrageList success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic[@"data"]);
        if (succe) {
            weakSelf.barrageListModel = [BarrageListModel modelWithJSON:jsonDic[@"data"]];
            for (int i = 0; i < weakSelf.barrageListModel.dm.count; i++) {
                [weakSelf.barragesArr addObject:weakSelf.barrageListModel.dm[i].BaContent];
            }
            //让弹幕滚动起来
            [weakSelf makeBarrageListAnimation:weakSelf.barragesArr];
            //让贡品陈列出来
            [weakSelf.currentCemGoodsArr addObjectsFromArray:weakSelf.barrageListModel.js];
            [weakSelf putCemGoodsWithArr];
            
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)getCemeteryJSShopData{
    NSDictionary *logDic = @{
                             @"pagenum":@1,
                             @"pagesize":@1999,
                             @"type":@"",
                             @"label":@"",
                             @"coname":@"",
                             @"qsj":@"",
                             @"jwj":@"",
                             @"shoptype":@"JS",
                             @"px":@"",
                             @"issx":@""
                             };
    WK(weakSelf);
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getcomlist" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"数据%@",jsonDic);
        if (succe) {
            NSDictionary *dic = [NSDictionary DicWithString:jsonDic[@"data"]];
            weakSelf.goodsArr = [NSArray modelArrayWithClass:[CemGoodsShopModel class] json:dic[@"datalist"]];
            
            //把贡品图片放到缓存中
            for (CemGoodsShopModel *goods in weakSelf.goodsArr) {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:goods.CoCover]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            [[SDImageCache sharedImageCache] storeImage:image forKey:goods.CoConame];
                                        }
                                    }];
                
            }
            
            
            MYLog(@"%@",weakSelf.goodsArr);
        }
    } failure:^(NSError *error) {
        
    }];

}

-(void)uploadCemPhoto:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *encodeimageStr =[imageData base64EncodedString];
    NSDictionary *params =@{@"userid":GetUserId,@"imgbt":encodeimageStr,@"uploadtype":@"FM",@"ceid":@(self.CeId)};
    [TCJPHTTPRequestManager POSTWithParameters:params requestID:GetUserId requestcode:kRequestCodeUploadCefm success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            MYLog(@"墓园封面图上传成功%@", jsonDic[@"data"]);
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.cemImageView];
    [self initXiangLu];
    [self.scrollView addSubview:self.detailView];
    [self initRightBtn];
    
    
    
    
}
//香炉
-(void)initXiangLu{
    
    for (int idx = 0; idx<2; idx++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:AdaptationFrame((0.7*bacheight-Screen_width/2)/AdaptationWidth()+50+idx*(350+140), 520, 126, 226)];
        image.image = MImage(@"my_name_xiangLu");
        
        [self.scrollView addSubview:image];
    }
    
}


//三个btn
-(void)initRightBtn{
    NSArray *imageArr = @[@"my_name_nav_1",@"my_name_nav_2",@"my_name_nav_3"];
    for (int idx = 0; idx<3; idx++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:AdaptationFrame(Screen_width/AdaptationWidth()-130, 750+idx*130, 114, 114)];
        [btn setImage:MImage(imageArr[idx]) forState:0];
        btn.tag = idx;
        [btn addTarget:self action:@selector(respondsToCemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

//让贡品摆放出来
-(void)putCemGoodsWithArr{
    for (int i = 0; (i < self.currentCemGoodsArr.count) && (i < 39); i++) {
        UIImageView *goodsIV = [[UIImageView alloc]initWithFrame:AdaptationFrame((1.4*bacheight/AdaptationWidth()-105)/2+((i%2)?1:-1)*105*(([@[@(i),@(i-13),@(i-26)][i/13] intValue]+1)/2), 80*(i/13), 105, 80)];
        goodsIV.backgroundColor = [UIColor clearColor];
        goodsIV.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.currentCemGoodsArr[i]];
        [self.goodsBackView addSubview:goodsIV];
    }
}



//弹幕动画效果
-(void)makeBarrageListAnimation:(NSMutableArray *)barragesArray{
    self.colorArray = @[[UIColor redColor],[UIColor blackColor],[UIColor greenColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor magentaColor],[UIColor brownColor]];
    for(int i = 0 ; i < barragesArray.count; i++){
        float   tempNum     = 64 +arc4random()%200;//高
        int     tempI       = arc4random()%barragesArray.count;
        int     sleepTime   = arc4random()%8;
        int     colorNum    = arc4random()%8;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(sleepTime);
            dispatch_async(dispatch_get_main_queue(), ^{
                FlyBarrageTextView * flyView = [[FlyBarrageTextView alloc] initWithY:tempNum AndText:barragesArray[tempI] AndWordSize:12];
                flyView.textColor = self.colorArray[colorNum];
                [self.view addSubview:flyView];
                [self.timersArr addObject:flyView.timer];
            });
        });
    }
}
//单条弹幕加入滚动
-(void)makeOneBarrageAnimation:(NSString *)str{
    float   tempNum     = 64 +arc4random()%200;
    int     colorNum    = arc4random()%8;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            FlyBarrageTextView * flyView = [[FlyBarrageTextView alloc] initWithY:tempNum AndText:str AndWordSize:12];
            flyView.textColor = self.colorArray[colorNum];
            [self.view addSubview:flyView];
            [self.timersArr addObject:flyView.timer];
        });
    });
    
}


#pragma mark *** btnEvents ***

-(void)respondsToCemBtn:(UIButton *)sender{
    switch (sender.tag) {
        case BTNIntroTag:
        {
            CemIntroViewController *cemIntro = [[CemIntroViewController alloc] initWithTitle:@"墓园介绍" image:nil];
            cemIntro.cemeteryModel = self.cemeteryModel;
            [self.navigationController pushViewController:cemIntro animated:YES];
        }
            break;
        case BTNJishiTag:
        {
            [self.view addSubview:self.goodsView];
        }
            break;
        case BTNMianhuaiTag:
        {
            _selectedMianhuaiBtn = !_selectedMianhuaiBtn;
            [self.scrollView addSubview:self.inputView];

            if (_selectedMianhuaiBtn) {
                [self.scrollView addSubview:self.inputView];
            }else{
                [self.inputView removeFromSuperview];
            }
        }
            break;
        default:
            break;
    }
}

-(void)closeKeyboard{
    [self.view endEditing:YES];
}



#pragma mark *** getters ***
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, bacheight)];
        _scrollView.contentSize = CGSizeMake(1.4*bacheight, bacheight);
        _scrollView.bounces = false;
        _scrollView.contentOffset = CGPointMake(0.7*bacheight-Screen_width/2, 0);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

-(UIImageView *)cemImageView{
    if (!_cemImageView) {
        _cemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
        _cemImageView.image = MImage(@"my_name_bg.png");
        _cemImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _cemImageView;
}

-(CemDetailView *)detailView{
    if (!_detailView) {
        _detailView = [[CemDetailView alloc] initWithFrame:AdaptationFrame((0.7*bacheight-Screen_width/2)/AdaptationWidth()+243, 64/AdaptationWidth()+120, 240, 470)];
    }
    return _detailView;
}
-(CemGoodsShopView *)goodsView{
    if (!_goodsView) {
        _goodsView = [[CemGoodsShopView alloc] initWithFrame:CGRectMake(0, 64, Screen_width,Screen_height-64-self.tabBarController.tabBar.bounds.size.height)];
        ((AllGoodsView *)(_goodsView.singleGoods)).goodsArr = _goodsArr;
        _goodsView.CeId = _CeId;
        _goodsView.delegate = self;
    }
    return _goodsView;
}
-(InputCherishView *)inputView{
    if (!_inputView) {
        _inputView = [[InputCherishView alloc] initWithFrame:AdaptationFrame(540, 780, 375, 220)];
        _inputView.textView.delegate = self;
        _inputView.delegate = self;
    }
    return _inputView;
}


-(NSMutableArray *)barragesArr{
    if (!_barragesArr) {
        _barragesArr = [@[] mutableCopy];
    }
    return _barragesArr;
}

-(NSMutableArray *)timersArr{
    if (!_timersArr) {
        _timersArr = [@[] mutableCopy];
    }
    return _timersArr;
}

-(NSMutableArray *)currentCemGoodsArr{
    if (!_currentCemGoodsArr) {
        _currentCemGoodsArr = [@[] mutableCopy];
    }
    return _currentCemGoodsArr;
}

#pragma mark - InputCherishViewDelegate
-(void)inputCherishView:(InputCherishView *)inputCherishView withString:(NSString *)str{
    [self.inputView removeFromSuperview];
    _selectedMianhuaiBtn = NO;
    //上传弹幕
    MYLog(@"%@",str);
    NSDictionary *logDic = @{
                             @"BaCeid":@(self.CeId),
                             @"BaMeid":GetUserId,
                             @"BaContent":str
                             };
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeCreateBarrage success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic[@"data"]);
    } failure:^(NSError *error) {
        
    }];
    
    [self makeOneBarrageAnimation:str];
    
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    MYLog(@"将要开始编辑");
    if (self.scrollView.frame.origin.y == 64) {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame =  self.scrollView.frame;
            frame.origin.y = 64-216+20;
            self.scrollView.frame = frame;
        }];
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    MYLog(@"结束编辑");
    if (self.scrollView.frame.origin.y !=64) {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame =  self.scrollView.frame;
            frame.origin.y = 64;
            self.scrollView.frame = frame;
        }];
    }
}

#pragma  mark - 生命周期
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //上传墓园封面图片
    UIImage *image = [self getImageFromView:self.scrollView];
    [self uploadCemPhoto:image];
    //停止弹幕所有的定时器
    for (NSTimer *timer in self.timersArr) {
        [timer invalidate];
    }
}

//屏幕截图
-(UIImage *)getImageFromView:(UIScrollView *)orgView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(orgView.contentSize);
    {
        CGPoint savedContentOffset = orgView.contentOffset;
        CGRect savedFrame = orgView.frame;
        orgView.contentOffset = CGPointZero;
        orgView.frame = CGRectMake(0, 0, orgView.contentSize.width, orgView.contentSize.height);
        
        [orgView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        orgView.contentOffset = savedContentOffset;
        orgView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }
    return nil;
}

#pragma mark - CemGoodsShopViewDelegate
-(void)uploadGoodsToRefreshcemGoods:(NSArray<CemGoodsShopModel *> *)goodsArr{
    //刷新贡品摆放位置
    //MYLog(@"该刷新贡品了");
    for (int i = 0; i < goodsArr.count&& (self.currentCemGoodsArr.count<39); i++) {
        int j = i + (short)self.currentCemGoodsArr.count;
        UIImageView *goodsIV = [[UIImageView alloc]initWithFrame:AdaptationFrame((1.4*bacheight/AdaptationWidth()-105)/2+((j%2)?1:-1)*105*(([@[@(j),@(j-13),@(j-26)][j/13] intValue]+1)/2), 80*(j/13), 105, 80)];
        goodsIV.backgroundColor = [UIColor clearColor];
        goodsIV.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:goodsArr[i].CoConame];
        [self.goodsBackView addSubview:goodsIV];
    }

    
}



@end
