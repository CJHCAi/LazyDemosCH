//
//  PortraitAndNameViews.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PortraitAndNameViews.h"
#import "NewInfoViewController.h"

@interface PortraitAndNameViews()<UIScrollViewDelegate>
{
    NSTimer *_timer;
    NSInteger _contentOffsetX;
}

@property (nonatomic,strong) UIScrollView *backNesScrollView; /*背景滚动*/
@property (nonatomic,strong) UIImageView *imageViews; /*头像*/
@property (nonatomic,strong) UILabel *label; /*名字*/

@end

@implementation PortraitAndNameViews
-(void)dealloc{
    //销毁定时器
    [_timer invalidate];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initDataSource];
        [self addSubview:self.backNesScrollView];
        [self initImageAndName];
        
        
    }
    return self;
}

-(void)initDataSource{
//    _imageNames = @[@"news_touxiang",@"news_touxiang",@"news_touxiang",@"news_touxiang",@"news_touxiang",@"news_touxiang",@"news_touxiang",@"news_touxiang"];
//    _imageForName = @[@"段正淳",@"段执行",@"段誉",@"段成功",@"段正淳",@"段执行",@"段誉",@"段成功"];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(respondsTotimer) userInfo:nil repeats:YES];
    [_timer fireDate];
    _contentOffsetX = 5;
}

-(void)setMRZJArr:(NSArray<FamilyDTModel *> *)MRZJArr{
    _MRZJArr = MRZJArr;
    [self initImageAndName];
     self.backNesScrollView.contentSize = AdaptationSize(self.MRZJArr.count*171-13, self.bounds.size.height);
}

#pragma mark *** ScrolleViewDelegate ***


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x>=scrollView.contentSize.width-self.bounds.size.width) {
        _contentOffsetX = -5;
    }
    if (scrollView.contentOffset.x<=0) {
        _contentOffsetX = 5;
    }
    
}
#pragma mark *** Events ***
-(void)respondsTotimer{
    CGPoint contenOff = self.backNesScrollView.contentOffset;
    [self.backNesScrollView setContentOffset:CGPointMake(contenOff.x+_contentOffsetX, 0) animated:YES];
}
#pragma mark *** 初始化 ***
-(void)initImageAndName{
//    [self addSubview:self.backNesScrollView];
//        for (int idx = 0; idx<_imageNames.count; idx++) {
//        UIImageView *image = [[UIImageView alloc] initWithFrame:AdaptationFrame(idx*171, 0, 158, 172)];
//        image.image = MImage(_imageNames[idx]);
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(idx*171*AdaptationWidth(), CGRectYH(image)+15*AdaptationWidth(), image.bounds.size.width, 23*AdaptationWidth())];
//        label.font = MFont(15);
//        label.textAlignment = 1;
//        label.text = _imageForName[idx];
//        
//        [self.backNesScrollView addSubview:image];
//        [self.backNesScrollView addSubview:label];
//    }
    
    for (int i = 0; i<self.MRZJArr.count; i++) {
                UIImageView *image = [[UIImageView alloc] initWithFrame:AdaptationFrame(i*171, 0, 158, 172)];
        image.userInteractionEnabled = YES;
        [image setImageWithURL:[NSURL URLWithString:self.MRZJArr[i].ArCover] placeholder:MImage(@"news_touxiang")];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            NewInfoViewController *newInfoVC = [[NewInfoViewController alloc]initWithTitle:@"名人传记" image:nil];
            newInfoVC.arId = self.MRZJArr[i].ArId;
            [[self viewController].navigationController pushViewController:newInfoVC animated:YES];
            
        }];
        [image addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*171*AdaptationWidth(), CGRectYH(image)+15*AdaptationWidth(), image.bounds.size.width, 23*AdaptationWidth())];
        label.font = MFont(15);
        label.textAlignment = 1;
        label.text = self.MRZJArr[i].ArTitle;
        
        [self.backNesScrollView addSubview:image];
        [self.backNesScrollView addSubview:label];
            }

    
}

-(UIScrollView *)backNesScrollView{
    if (!_backNesScrollView) {
        _backNesScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        _backNesScrollView.contentSize = AdaptationSize(_imageNames.count*171-13, self.bounds.size.height);
       
        _backNesScrollView.delegate = self;
        MYLog(@"滚动图长%lf",_backNesScrollView.contentSize.width);
    }
    return _backNesScrollView;
}

@end
