//
//  WPersonInfoViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WPersonInfoViewController.h"
#import "WPersonInfoHeaderView.h"
#import "WphotosView.h"
#import "WAllGenView.h"
@interface WPersonInfoViewController ()
/**头部信息view*/
@property (nonatomic,strong) WPersonInfoHeaderView *headView;
/**个人的所有上传图片*/
@property (nonatomic,strong) WphotosView *photosView;
/**所有家谱*/
@property (nonatomic,strong) WAllGenView *allGenView;
/**专属家谱按钮*/
@property (nonatomic,strong) UIButton *priBtn;



@end

@implementation WPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    
}
#pragma mark *** 初始化数据 ***
-(void)initData{
    
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    
    UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar-135*AdaptationWidth())];
    backGroundImage.image = MImage(@"gr_bg");
    [self.view addSubview:backGroundImage];
    
    [self.view sd_addSubviews:@[self.headView,self.photosView,self.allGenView,self.priBtn]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *** getters ***
-(WPersonInfoHeaderView *)headView{
    if (!_headView) {
        _headView = [[WPersonInfoHeaderView alloc] initWithFrame:AdaptationFrame(0, 64/AdaptationWidth(), Screen_width/AdaptationWidth(), 295)];
        
        //赋值
        if (self.infoModel.photo && self.infoModel.photo.length!=0) {
            _headView.headImage.imageURL = [NSURL URLWithString:self.infoModel.photo];
        }
        if (self.infoModel.name && self.infoModel.name.length!=0) {
            _headView.nameLabel.text = self.infoModel.name;
        }
        _headView.sexImage.image = [self.infoModel.sex isEqualToString:@"1"]?MImage(@"gr_boy"):MImage(@"gr_girl");
        _headView.timeLabel.text = self.infoModel.hour;
        if (self.infoModel.qm && self.infoModel.qm.length!=0) {
            _headView.signatureLabel.text = self.infoModel.qm;
        }
        if (self.infoModel.ah && self.infoModel.ah.length!=0) {
            _headView.intertsLabel.text = self.infoModel.ah;
        }
    }
    return _headView;
}
-(WphotosView *)photosView{
    if (!_photosView) {
        NSArray *urlArr = @[];
        if (self.infoModel.pic && self.infoModel.pic.count!=0) {
            urlArr = self.infoModel.pic;
        }else{
            urlArr = @[@"http://59.53.92.160:1080/upload/image/201607/20160721_150808_108318.jpg",@"http://59.53.92.160:1080/upload/image/201607/20160721_150808_108318.jpg",@"http://59.53.92.160:1080/upload/image/201607/20160721_150808_108318.jpg",@"http://59.53.92.160:1080/upload/image/201607/20160721_150808_108318.jpg"];
        }
        _photosView = [[WphotosView alloc] initWithFrame:AdaptationFrame(0, CGRectYH(self.headView)/AdaptationWidth(), Screen_width/AdaptationWidth(), 190) photosUrlStringArray:urlArr];
        _photosView.backgroundColor = LH_RGBCOLOR(224, 224, 224);
    }
    return _photosView;
}
-(WAllGenView *)allGenView{
    if (!_allGenView) {
        
        _allGenView = [[WAllGenView alloc] initWithFrame:CGRectMake(0, CGRectYH(self.photosView), Screen_width, 316*AdaptationWidth()) model:self.infoModel];
        _allGenView.sex = [self.infoModel.sex isEqualToString:@"1"]?true:false;
    }
    return _allGenView;
}
-(UIButton *)priBtn{
    if (!_priBtn) {
        UIView *greView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectYH(self.allGenView), Screen_width, 20*AdaptationWidth())];
        greView.backgroundColor = LH_RGBCOLOR(228, 228, 228);
        greView.alpha = 0.6;
        [self.view addSubview:greView];
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectYH(greView), Screen_width, 50*AdaptationWidth())];
        whiteView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [self.view addSubview:whiteView];
        _priBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectYH(whiteView), Screen_width, 200*AdaptationWidth())];
        [_priBtn setBackgroundImage:MImage(@"gr_dis") forState:0];
    }
    return _priBtn;
}
@end
