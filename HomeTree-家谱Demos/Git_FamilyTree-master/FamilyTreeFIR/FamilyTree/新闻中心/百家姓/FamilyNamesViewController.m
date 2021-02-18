//
//  FamilyNamesViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "FamilyNamesViewController.h"
#import "NameBeginView.h"
#import "ZSZPView.h"
#import "HundredNameInfoModel.h"

@interface FamilyNamesViewController ()<UIScrollViewDelegate>
/** 背景滚动视图*/
@property (nonatomic, strong) UIScrollView *backSV;
/** 滚动背景图片视图*/
@property (nonatomic, strong) UIImageView *backIV;
/** 白色背景视图*/
@property (nonatomic, strong) UIView *whiteBackV;
/** 图腾视图*/
@property (nonatomic, strong) UIImageView *totemIV;
/** 始祖简介标题标签*/
@property (nonatomic, strong) UILabel *ancestorsInfoTitleLB;
/** 始祖简介详情标签*/
@property (nonatomic, strong) UILabel *ancestorsInfoLB;
/** 图腾释义标题标签*/
@property (nonatomic, strong) UILabel *totemTitleLB;
/** 图腾释义详情标签*/
@property (nonatomic, strong) UILabel *totemInfoLB;
/** 姓氏起源标题标签*/
@property (nonatomic, strong) UILabel *nameBeginTitleLB;
/** 姓氏起源视图数组*/
@property (nonatomic, strong) NSMutableArray<NameBeginView *> *nameBeginViewArr;
/** 姓氏起源详情组*/
@property (nonatomic, strong) NSArray<NSString *> *nameBeginStrArr;
/** 迁徙分布标题标签*/
@property (nonatomic, strong) UILabel *moveTitleLB;
/** 迁徙分布详情标签*/
@property (nonatomic, strong) UILabel *moveInfoLB;
/** 宗室支派标题数组*/
@property (nonatomic, strong) NSArray<NSString *> *ZSZPTitleArr;
/** 宗室支派详情数组*/
@property (nonatomic, strong) NSArray<NSString *> *ZSZPStrArr;
/** 宗室支派视图数组*/
@property (nonatomic, strong) NSMutableArray<ZSZPView *> *ZSZPViewArr;
/** 百家姓详情模型*/
@property (nonatomic, strong) HundredNameInfoModel *hundredNameInfoModel;

@end

@implementation FamilyNamesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    //[self initUI];
}

-(void)getData{
    NSDictionary *logDic = @{@"FaId":@(self.FaId)};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeGetFamilyNamesDetail success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic[@"data"]);
        if (succe) {
            weakSelf.hundredNameInfoModel = [HundredNameInfoModel modelWithJSON:jsonDic[@"data"]];
            [weakSelf initUI];
        }
    } failure:^(NSError *error) {
        
    }];

    
}

#pragma mark - 视图初始化
-(void)initUI{
    [self.view addSubview:self.backSV];
    [self.backSV addSubview:self.backIV];
    [self.backSV addSubview:self.whiteBackV];
    [self.whiteBackV addSubview:self.totemIV];
    [self.whiteBackV addSubview:self.ancestorsInfoTitleLB];
    [self.whiteBackV addSubview:self.ancestorsInfoLB];
    [self.whiteBackV addSubview:self.totemTitleLB];
    [self.whiteBackV addSubview:self.totemInfoLB];
    [self.whiteBackV addSubview:self.nameBeginTitleLB];
    [self initNameBeginInfoLBs];
    [self.whiteBackV addSubview:self.moveTitleLB];
    self.moveTitleLB.sd_layout.topSpaceToView(self.nameBeginViewArr.lastObject,20).leftSpaceToView(self.whiteBackV,0).heightIs(32*AdaptationWidth()).widthIs(166*AdaptationWidth());
    [self.whiteBackV addSubview:self.moveInfoLB];
    self.moveInfoLB.sd_layout.topSpaceToView(self.moveTitleLB,24*AdaptationWidth()).leftEqualToView(self.totemInfoLB).rightSpaceToView(self.whiteBackV,10).heightIs(CGRectH(self.moveInfoLB));
    
    [self initZSZPLBs];

}
-(void)initNameBeginInfoLBs{
    for (int i = 0; i < self.hundredNameInfoModel.yl.count; i++) {
        NameBeginView *nameBeginView = [[NameBeginView alloc]initWithFrame:CGRectMake(34*AdaptationWidth(), CGRectYH(self.nameBeginTitleLB)+28*AdaptationWidth(), 592*AdaptationWidth(), 200) Index:i+1 text:self.hundredNameInfoModel.yl[i]];
        if (i == self.hundredNameInfoModel.yl.count-1) {
            nameBeginView.lineView.backgroundColor = [UIColor clearColor];
        }
        [self.nameBeginViewArr addObject:nameBeginView];
        [self.whiteBackV addSubview:nameBeginView];
        
        if (i == 0) {
            nameBeginView.sd_layout.topSpaceToView(self.nameBeginTitleLB,10).leftEqualToView(self.totemInfoLB).rightSpaceToView(self.whiteBackV,0).heightIs(CGRectYH(nameBeginView.infoLB));
        }else{
            nameBeginView.sd_layout.topSpaceToView(self.nameBeginViewArr[i-1],20).leftEqualToView(self.totemInfoLB).rightSpaceToView(self.whiteBackV,0).heightIs(CGRectYH(nameBeginView.infoLB));
        }
    }

    
}

-(void)initZSZPLBs{
    for (int i = 0; i < 4; i++) {
        ZSZPView *zszpView = [[ZSZPView alloc]initWithFrame:CGRectMake(100, 100, 100, 100) Title:self.ZSZPTitleArr[i] Text:self.ZSZPStrArr[i]];
        [self.ZSZPViewArr addObject:zszpView];
        [self.whiteBackV addSubview:zszpView];
        if (i == 0) {
            zszpView.sd_layout.topSpaceToView(self.moveInfoLB,45*AdaptationWidth()).leftSpaceToView(self.whiteBackV,24*AdaptationWidth()).rightSpaceToView(self.whiteBackV,24*AdaptationWidth()).heightIs(CGRectYH(zszpView.textLB)).minHeightIs(50*AdaptationWidth());
        }else{
            zszpView.sd_layout.topSpaceToView(self.ZSZPViewArr[i-1],40*AdaptationWidth()).leftSpaceToView(self.whiteBackV,24*AdaptationWidth()).rightSpaceToView(self.whiteBackV,24*AdaptationWidth()).heightIs(CGRectYH(zszpView.textLB)).minHeightIs(50*AdaptationWidth());
        }
    }
}

#pragma mark - UIScrollViewDelegate
//动态修改滚动图的高度
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGRect frame = self.whiteBackV.frame;
    frame.size.height = CGRectYH(self.ZSZPViewArr.lastObject)+10;
    self.whiteBackV.frame = frame;
    CGSize size = self.backSV.contentSize;
    size.height = CGRectYH(self.whiteBackV)+10;
    self.backSV.contentSize = size;
    self.backIV.frame = CGRectMake(0, 0, Screen_width, self.backSV.contentSize.height);
}

#pragma mark - lazyLoad
-(UIScrollView *)backSV{
    if (!_backSV) {
        _backSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-self.tabBarController.tabBar.bounds.size.height)];
        _backSV.contentSize = CGSizeMake(Screen_width, 3592*AdaptationWidth());
        _backSV.bounces = NO;
        _backSV.delegate = self;
    }
    return _backSV;
}

-(UIView *)whiteBackV{
    if (!_whiteBackV) {
        _whiteBackV = [[UIView alloc]initWithFrame:AdaptationFrame(32, 32, 662, 3534)];
        _whiteBackV.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
    }
    return _whiteBackV;
}

-(UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.backSV.contentSize.height)];
        _backIV.image = MImage(@"baijiaxing_background_s");
    }
    return _backIV;
}

-(UIImageView *)totemIV{
    if (!_totemIV) {
        _totemIV = [[UIImageView alloc]initWithFrame:AdaptationFrame(23, 109, 128, 128)];
        //_totemIV.image = MImage(@"baijiaxing_logo");
        [_totemIV setImageWithURL:[NSURL URLWithString:self.hundredNameInfoModel.data.FaLogo] placeholder:MImage(@"baijiaxing_logo")];
    }
    return _totemIV;
}

-(UILabel *)ancestorsInfoTitleLB{
    if (!_ancestorsInfoLB) {
        _ancestorsInfoTitleLB = [[UILabel alloc]initWithFrame:AdaptationFrame(175, 22, 200, 42)];
        _ancestorsInfoTitleLB.text = @"始祖简介";
        _ancestorsInfoTitleLB.font = WFont(33);
    }
    return _ancestorsInfoTitleLB;
}

-(UILabel *)ancestorsInfoLB{
    if (!_ancestorsInfoLB) {
        _ancestorsInfoLB =[[UILabel alloc]initWithFrame:CGRectMake(CGRectX(self.ancestorsInfoTitleLB), CGRectYH(self.ancestorsInfoTitleLB), 470*AdaptationWidth(),414*AdaptationWidth())];
        //_ancestorsInfoLB.text = @"宋穆公为穆姓的得姓始祖。\n宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与宋穆公是宋宣公的胞弟，宣公去世时舍太子与";
        _ancestorsInfoLB.text = self.hundredNameInfoModel.data.FaBrief;
        _ancestorsInfoLB.font = WFont(25);
        _ancestorsInfoLB.numberOfLines = 0;
        [_ancestorsInfoLB sizeToFit];
    }
    return _ancestorsInfoLB;
}

-(UILabel *)totemTitleLB{
    if (!_totemTitleLB) {
        _totemTitleLB = [[UILabel alloc]init];
        if (CGRectYH(self.totemIV) < CGRectYH(self.ancestorsInfoLB)) {
            _totemTitleLB.frame = CGRectMake(0, CGRectYH(self.ancestorsInfoLB)+45*AdaptationWidth(), 166*AdaptationWidth(), 32*AdaptationWidth());
        }else{
            _totemTitleLB.frame = CGRectMake(0, CGRectYH(self.totemIV)+100*AdaptationWidth(),166*AdaptationWidth(), 32*AdaptationWidth());
        }
        //_totemTitleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(self.ancestorsInfoLB)+45*AdaptationWidth(), 166*AdaptationWidth(), 32*AdaptationWidth())];
        _totemTitleLB.text = @"图腾释义";
        _totemTitleLB.backgroundColor = LH_RGBCOLOR(56, 89, 96);
        _totemTitleLB.textAlignment = NSTextAlignmentCenter;
        _totemTitleLB.textColor = [UIColor whiteColor];
        _totemTitleLB.font = WFont(25);
    }
    return _totemTitleLB;
}

-(UILabel *)totemInfoLB{
    if (!_totemInfoLB) {
        _totemInfoLB = [[UILabel alloc]initWithFrame:CGRectMake(34*AdaptationWidth(), CGRectYH(self.totemTitleLB)+24*AdaptationWidth(), 592*AdaptationWidth(), 132*AdaptationWidth())];
        //_totemInfoLB.text = @"穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。";
        _totemInfoLB.text = self.hundredNameInfoModel.data.FaInter;
        _totemInfoLB.font = WFont(25);
        _totemInfoLB.numberOfLines = 0;
        [_totemInfoLB sizeToFit];
    }
    return _totemInfoLB;
}

-(UILabel *)nameBeginTitleLB{
    if (!_nameBeginTitleLB) {
        _nameBeginTitleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(self.totemInfoLB)+40*AdaptationWidth(), 166*AdaptationWidth(), 32*AdaptationWidth())];
        _nameBeginTitleLB.text = @"姓氏起源";
        _nameBeginTitleLB.backgroundColor = LH_RGBCOLOR(56, 89, 96);
        _nameBeginTitleLB.textAlignment = NSTextAlignmentCenter;
        _nameBeginTitleLB.textColor = [UIColor whiteColor];
        _nameBeginTitleLB.font = WFont(25);
    }
    return _nameBeginTitleLB;
}

-(NSMutableArray<NameBeginView *> *)nameBeginViewArr{
    if (!_nameBeginViewArr) {
        _nameBeginViewArr = [@[] mutableCopy];
    }
    return _nameBeginViewArr;
}
//-(NSArray<NSString *> *)nameBeginStrArr{
//    if (!_nameBeginStrArr) {
//        _nameBeginStrArr = @[@"穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。",@"穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。",@"穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。",@"穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。",@"穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。",@"穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。",@"穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。"];
//    }
//    return _nameBeginStrArr;
//}
-(UILabel *)moveTitleLB{
    if (!_moveTitleLB) {
        _moveTitleLB = [[UILabel alloc]init];
        _moveTitleLB.text = @"迁徙分布";
        _moveTitleLB.font = WFont(25);
        _moveTitleLB.backgroundColor = LH_RGBCOLOR(56, 89, 96);
        _moveTitleLB.textColor = [UIColor whiteColor];
        _moveTitleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _moveTitleLB;
}

-(UILabel *)moveInfoLB{
    if (!_moveInfoLB) {
        _moveInfoLB = [[UILabel alloc]initWithFrame:CGRectMake(34*AdaptationWidth(), 20*AdaptationWidth(), 592*AdaptationWidth(), 360*AdaptationWidth())];
//        _moveInfoLB.text = @"穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。穆，本义是禾名。本义是禾名。";
        _moveInfoLB.text = self.hundredNameInfoModel.data.FaMigration;
        _moveInfoLB.font = WFont(25);
        _moveInfoLB.numberOfLines = 0;
        [_moveInfoLB sizeToFit];
    }
    return _moveInfoLB;
}

-(NSArray<NSString *> *)ZSZPTitleArr{
    if (!_ZSZPTitleArr) {
        _ZSZPTitleArr = @[@"宗室支派：",@"郡望：",@"堂号：",@"楹联："];
    }
    return _ZSZPTitleArr;
}

-(NSArray<NSString *> *)ZSZPStrArr{
    if (!_ZSZPStrArr) {
//        _ZSZPStrArr = @[@"",@"河南浚、汝南郡、河内郡。",@"河南浚、汝南郡、河内郡。",@"外书六事;内疏四千\n外书六事;内疏四千\n外书六事;内疏四千\n外书六事;内疏四千\n外书六事;内疏四千\n外书六事;内疏四千\n外书六事;内疏四千\n"];
        _ZSZPStrArr = @[self.hundredNameInfoModel.data.FaClantribe,self.hundredNameInfoModel.data.FaCountyhall,self.hundredNameInfoModel.data.FaHall,self.hundredNameInfoModel.data.FaOther];
    }
    return _ZSZPStrArr;
}

-(NSMutableArray<ZSZPView *> *)ZSZPViewArr{
    if (!_ZSZPViewArr) {
        _ZSZPViewArr = [@[] mutableCopy];
    }
    return _ZSZPViewArr;
}
@end
