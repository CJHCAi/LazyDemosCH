//
//  CliffordViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/19.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CliffordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CliffordEndViewController.h"
#import "TributeSelectView.h"
#import "CliffordTributeModel.h"
#import "JossSelectViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CliffordViewController()<TributeSelectViewDelegate,JossSelectViewControllerDelegate>
/** 背景视图*/
@property (nonatomic, strong) UIImageView *backIV;
/** 帘子视图*/
@property (nonatomic, strong) UIImageView *curtainIV;
/** 开场动画按钮*/
@property (nonatomic, strong) UIButton *beginBtn;
/** 佛像*/
@property (nonatomic, strong) UIImageView *jossIV;
/** 左烛台*/
@property (nonatomic, strong) UIImageView *leftCandleHolderIV;
/** 右烛台*/
@property (nonatomic, strong) UIImageView *rightCandleHolderIV;
/** 香炉*/
@property (nonatomic, strong) UIImageView *burnerIV;
/** 拜佛按钮*/
@property (nonatomic, strong) UIButton *worshipJossBtn;
/** 点击弹出贡品的视图*/
@property (nonatomic, strong) UIView *clickView;
/** 获取贡品的三种商品数组*/
@property (nonatomic, strong) NSArray<CliffordTributeModel *> *tributeArr;
/** 已经购买的贡品的名字*/
@property (nonatomic, strong) NSString *alreadyBuyTributeStr;
/** 贡品盘上的贡品视图*/
@property (nonatomic, strong) NSMutableArray<UIImageView *> *tributePlateIVArr;
/** 播放器*/
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation CliffordViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    //播放音效
    [self startMusicWithName:@"qifukaichang"];
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.curtainIV];
    [self.curtainIV addSubview:self.beginBtn];
    [self.backIV addSubview:self.jossIV];
    [self.backIV addSubview:self.leftCandleHolderIV];
    [self.backIV addSubview:self.rightCandleHolderIV];
    [self.backIV addSubview:self.burnerIV];
    [self.backIV addSubview:self.worshipJossBtn];
    //四个贡品盘视图
    [self initFourTributePlateIV];
    //支持摇一摇
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    [self.backIV addSubview:self.clickView];
    [self getQFShopData];
    
}

#pragma mark - 音效播放
-(void)startMusicWithName:(NSString *)str{
    NSURL *url = [[NSBundle mainBundle]URLForResource:str withExtension:@"mp3"];
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = -1;
    [self.player play];
}

#pragma mark - 视图初始化
-(void)initFourTributePlateIV{
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.07188*CGRectW(self.backIV)+0.2469*CGRectW(self.backIV)*i, 0.6616*CGRectH(self.backIV), 0.1375*CGRectW(self.backIV), 0.0681*CGRectH(self.backIV))];
        //imageView.backgroundColor = [UIColor redColor];
        //因设计图盘子位置不是等距，所以调整距离
        if (i == 2) {
            imageView.frame = CGRectMake(0.07188*CGRectW(self.backIV)+0.2469*CGRectW(self.backIV)*i-0.02*CGRectW(self.backIV), 0.6616*CGRectH(self.backIV), 0.1375*CGRectW(self.backIV), 0.0681*CGRectH(self.backIV));
        }
        if (i == 3) {
             imageView.frame = CGRectMake(0.07188*CGRectW(self.backIV)+0.2469*CGRectW(self.backIV)*i-0.025*CGRectW(self.backIV), 0.6616*CGRectH(self.backIV), 0.1375*CGRectW(self.backIV), 0.0681*CGRectH(self.backIV));
        }
        [self.tributePlateIVArr addObject:imageView];
        [self.backIV addSubview:imageView];
    }
}

#pragma mark - 数据获取
//获取所有贡品数据(现有3条)
-(void)getQFShopData{
    NSDictionary *logDic = @{
                             @"pagenum":@1,
                             @"pagesize":@1999,
                             @"type":@"",
                             @"label":@"",
                             @"coname":@"",
                             @"qsj":@"",
                             @"jwj":@"",
                             @"shoptype":@"QF",
                             @"px":@"",
                             @"issx":@""
                             };
    WK(weakSelf);
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getcomlist" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"数据%@",jsonDic[@"data"]);
        MYLog(@"%@",jsonDic[@"message"]);
        if (succe) {
            NSDictionary *dic = [NSDictionary DicWithString:jsonDic[@"data"]];
            weakSelf.tributeArr = [NSArray modelArrayWithClass:[CliffordTributeModel class] json:dic[@"datalist"]];
            [weakSelf getQFAlreadyBuyData];
            MYLog(@"%@",weakSelf.tributeArr);
        }
        
        
    }failure:^(NSError *error) {
        
    }];
    
}

//获取已经购买的贡品
-(void)getQFAlreadyBuyData{
    NSDictionary *logDic = @{@"userid":GetUserId};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getmyqifu" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"已经购买的%@",jsonDic[@"data"]);
        if (succe) {
            weakSelf.alreadyBuyTributeStr = jsonDic[@"data"];
            int index = -1;
            for (int i = 0; i < 3; i++) {
                if ([[NSString stringWithFormat:@"\"%@\"",weakSelf.tributeArr[i].CoConame] isEqualToString:weakSelf.alreadyBuyTributeStr]) {
                    index = i;
                                   }
            }
            if (index != -1) {
                [self setPlateTribute:index];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 点击事件
-(void)clickToBegin{
    [self startCurtainAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player stop];
        [self startMusicWithName:@"qf"];
    });
    
}

-(void)clickToPushTributeView{
   if (self.tributePlateIVArr.firstObject.image) {
        [SXLoadingView showAlertHUD:@"一天只允许购买一次贡品" duration:0.5];
        return;
    }
    MYLog(@"弹出贡品视图");
    TributeSelectView *tributeSelectView = [[TributeSelectView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, CGRectH(self.backIV))];
    tributeSelectView.tributeArr = self.tributeArr;
    tributeSelectView.delegate = self;
    [self.backIV addSubview:tributeSelectView];
}

-(void)clickBtnToSelectJoss{
    JossSelectViewController *jossSelectVC = [[JossSelectViewController alloc]initWithTitle:@"请佛" image:nil];
    jossSelectVC.delegate = self;
    [self.navigationController pushViewController:jossSelectVC animated:YES];
}


#pragma mark *** 摇一摇 ***
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    MYLog(@"摇一摇");
    [self worshipJossAnimation];
}

-(void)worshipJossAnimation{
    MYLog(@"叩拜动画");
    NSData *data1 = UIImagePNGRepresentation(self.jossIV.image);
    NSData *data2 = UIImagePNGRepresentation(MImage(@"qf_gy"));
    if ([data1 isEqual:data2]) {
        //[SXLoadingView showAlertHUD:@"请先请佛" duration:0.5];
        [self clickBtnToSelectJoss];
    }else{
        [self.worshipJossBtn removeFromSuperview];
        UIImageView *handIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.3125*CGRectW(self.backIV), 0.7473*CGRectH(self.backIV), 0.375*CGRectW(self.backIV), 0.1648*CGRectH(self.backIV))];
        handIV.image = MImage(@"qf_bf");
        handIV.contentMode = UIViewContentModeScaleToFill;
        
        
        
        [self.backIV addSubview:handIV];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        //添加移动
        CABasicAnimation *moveAnimation = [CABasicAnimation animation];
        moveAnimation.keyPath = @"position.y";
        moveAnimation.toValue = @(0.7473*CGRectH(self.backIV)+0.1648*CGRectH(self.backIV));
        
        //添加缩放
        CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.y";
        scaleAnimation.toValue = @(0.5);
        
        group.animations = @[moveAnimation,scaleAnimation];
        group.removedOnCompletion = NO;
        group.fillMode = @"forwards";
        group.duration = 2;
        group.repeatCount = MAXFLOAT;
        [handIV.layer addAnimation:group forKey:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [handIV removeFromSuperview];
                [self.backIV addSubview:self.worshipJossBtn];
            });
            
            CliffordEndViewController *cliffordEndVC = [[CliffordEndViewController alloc]initWithTitle:@"祈福" image:nil];
            cliffordEndVC.jossIV.image = self.jossIV.image;
            [self.navigationController pushViewController:cliffordEndVC animated:YES];
        });
        
    }
}



//帘子动画
-(void)startCurtainAnimation{
    [UIView animateWithDuration:2 animations:^{
        [self.beginBtn removeFromSuperview];
        self.curtainIV.frame = CGRectMake(0, 64, Screen_width, 0);
    } completion:^(BOOL finished) {
         [self.curtainIV removeFromSuperview];
        
    }];
}

#pragma mark - TributeSelecteViewDelegate
-(void)buyOneTribute:(CliffordTributeModel *)tributeModel{
    NSUInteger index =[self.tributeArr indexOfObject:tributeModel];
    
    MYLog(@"%ld",(unsigned long)index);
    [self setPlateTribute:index];
   
}

-(void)setPlateTribute:(NSInteger)index{
    self.burnerIV.image = MImage(@"qf_xianglu01");
    self.leftCandleHolderIV.image = MImage(@"qf_xiangzhu");
    self.rightCandleHolderIV.image = MImage(@"qf_xiangzhu");

    switch (index) {
        case 0:
            self.tributePlateIVArr[0].image = MImage(@"qf_pingguo");
            self.tributePlateIVArr[1].image = MImage(@"qf_putao");
            self.tributePlateIVArr[2].image = MImage(@"qf_xiangjiao");
            self.tributePlateIVArr[3].image = MImage(@"qf_chengzi");
            break;
        case 1:
            self.tributePlateIVArr[0].image = MImage(@"qf_shengli");
            self.tributePlateIVArr[1].image = MImage(@"qf_shengli");
            self.tributePlateIVArr[2].image = MImage(@"qf_shengli");
            self.tributePlateIVArr[3].image = MImage(@"qf_shengli");
            
            break;
        case 2:
            self.tributePlateIVArr[0].image = MImage(@"qf_yuanbao");
            self.tributePlateIVArr[1].image = MImage(@"qf_yuanbao");
            self.tributePlateIVArr[2].image = MImage(@"qf_yuanbao");
            self.tributePlateIVArr[3].image = MImage(@"qf_yuanbao");
            
            break;
        default:
            break;
    }
}

#pragma mark - JossSelectViewControllerDelegate
-(void)chooseJossImage:(UIImage *)image{
    self.jossIV.image = image;
}

#pragma mark - lazyLoad
-(UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _backIV.userInteractionEnabled = YES;
        //_backIV.backgroundColor = [UIColor blueColor];
        _backIV.image = MImage(@"qf_bg");
    }
    return _backIV;
}


-(UIImageView *)curtainIV{
    if (!_curtainIV) {
        _curtainIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49-10)];
        _curtainIV.image = MImage(@"qf_lian");
        _curtainIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToBegin)];
        [_curtainIV addGestureRecognizer:tap];
    }
    return _curtainIV;
}

-(UIButton *)beginBtn{
    if (!_beginBtn) {
        _beginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.2063*CGRectW(self.backIV), 0.3626*CGRectH(self.backIV)-10, 0.6*CGRectW(self.backIV), 0.2537*CGRectH(self.backIV))];
        [_beginBtn setBackgroundImage:MImage(@"qf_middle") forState:UIControlStateNormal];
        _beginBtn.userInteractionEnabled = NO;
//        [_beginBtn addTarget:self action:@selector(clickToBegin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beginBtn;
}

-(UIImageView *)jossIV{
    if (!_jossIV) {
        _jossIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.2313*CGRectW(self.backIV), 0.0549*CGRectH(self.backIV), 0.5375*CGRectW(self.backIV), 0.5099*CGRectH(self.backIV))];
        //_jossIV.backgroundColor = [UIColor yellowColor];
        _jossIV.userInteractionEnabled = YES;
        _jossIV.contentMode = UIViewContentModeScaleAspectFit;
        _jossIV.image = MImage(@"qf_gy");
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBtnToSelectJoss)];
        [_jossIV addGestureRecognizer:tap];
    }
    return _jossIV;
}

-(UIImageView *)leftCandleHolderIV{
    if (!_leftCandleHolderIV) {
        _leftCandleHolderIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.1141*CGRectW(self.backIV), 0.4824*CGRectH(self.backIV), 0.1172*CGRectW(self.backIV), 0.1714*CGRectH(self.backIV))];
        //_leftCandleHolderIV.backgroundColor = [UIColor redColor];
        //_leftCandleHolderIV.contentMode = UIViewContentModeBottom;
        _leftCandleHolderIV.image = MImage(@"qf_zu");
        
    }
    return _leftCandleHolderIV;
}

-(UIImageView *)rightCandleHolderIV{
    if (!_rightCandleHolderIV) {
        _rightCandleHolderIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.7563*CGRectW(self.backIV), CGRectY(self.leftCandleHolderIV), 0.1172*CGRectW(self.backIV), 0.1714*CGRectH(self.backIV))];
        //_rightCandleHolderIV.backgroundColor = [UIColor redColor];
        //_rightCandleHolderIV.contentMode = UIViewContentModeBottom;
        _rightCandleHolderIV.image =  MImage(@"qf_zu");
    }
    return _rightCandleHolderIV;
}

-(UIImageView *)burnerIV{
    if (!_burnerIV) {
        _burnerIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.375*CGRectW(self.backIV), 0.3637*CGRectH(self.backIV), 0.2578*CGRectW(self.backIV), 0.2934*CGRectH(self.backIV))];
        //_burnerIV.backgroundColor = [UIColor redColor];
        _burnerIV.contentMode = UIViewContentModeBottom;
        _burnerIV.image = MImage(@"qf_gz");
    }
    return _burnerIV;
}

-(UIButton *)worshipJossBtn{
    if (!_worshipJossBtn) {
        _worshipJossBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.1922*CGRectW(self.backIV), 0.8525*CGRectH(self.backIV), 0.6375*CGRectW(self.backIV), 0.1323*CGRectH(self.backIV))];
        //_worshipJossBtn.backgroundColor = [UIColor whiteColor];
        [_worshipJossBtn setBackgroundImage:MImage(@"qf_wz") forState:UIControlStateNormal];
        _worshipJossBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_worshipJossBtn addTarget:self action:@selector(worshipJossAnimation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _worshipJossBtn;
}

-(UIView *)clickView{
    if (!_clickView) {
        _clickView = [[UIView alloc]initWithFrame:CGRectMake(0.0453*CGRectW(self.backIV), 0.5582*CGRectH(self.backIV), 0.9094*CGRectW(self.backIV), 0.2132*CGRectH(self.backIV))];
        _clickView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToPushTributeView)];
        [_clickView addGestureRecognizer:tap];
    }
    return _clickView;
}

-(NSMutableArray<UIImageView *> *)tributePlateIVArr{
    if (!_tributePlateIVArr) {
        _tributePlateIVArr = [@[] mutableCopy];
    }
    return _tributePlateIVArr;
}

@end
