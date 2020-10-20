//
//  PersonalCenterInfoView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PersonalCenterInfoView.h"
#import "UIView+getCurrentViewController.h"
#import "EditHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PersonalCenterInfoView()<EditHeadViewDelegate>

/** 当前家谱信息标签数组*/
@property (nonatomic, strong) NSMutableArray<UILabel *> *currentFamilyTreeInfoLBsArr;
/** 经处理过的家谱数据数组*/
@property (nonatomic, strong) NSArray *hyjpArrC;

/** 切换家谱标签用于类似按钮操作*/
@property (nonatomic, strong) UILabel *changeFamilyTreeLB;

/** 当前族谱标签*/
@property (nonatomic, strong) UILabel *currentFamilyTreeNameLB;
/** 弹出切换家谱视图*/
@property (nonatomic, strong) UIScrollView *changeFamilyTreeSV;


@end

@implementation PersonalCenterInfoView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, CGRectH(self))];
        bgIV.image = MImage(@"gr_ct_qieHuanJiaPu_bg");
        [self addSubview:bgIV];
        //头像
        [self initHeadIV];
        //4个信息标签
        [self initFourLBs];
        //当前家谱名标签和切换家谱按钮
        [self initFamilyTreeNameLBAndChangeFamilyTreeLB];
        //设置弹出切换家谱界面
        [self addSubview:self.changeFamilyTreeSV];
    }
    return self;
}

#pragma mark - 视图初始化
-(void)initHeadIV{
    
    
    self.headIV = [[HeadImageView alloc]initWithFrame:CGRectMake(0.0469*CGRectW(self), 0.1533*CGRectH(self), 0.2344*CGRectW(self), 0.5474*CGRectH(self))];
    self.headIV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(clickHeadIV)];
    [self.headIV addGestureRecognizer:tap];
    [self addSubview:self.headIV];
}

-(void)initFourLBs{
    self.currentFamilyTreeInfoLBsArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = MFont(16);
        [self.currentFamilyTreeInfoLBsArr addObject:label];
        [self addSubview:label];
    }
}

-(void)initFamilyTreeNameLBAndChangeFamilyTreeLB{
    self.currentFamilyTreeNameLB = [[UILabel alloc]init];
    self.currentFamilyTreeNameLB.font = MFont(12);
    self.currentFamilyTreeNameLB.textColor = [UIColor whiteColor];
    self.currentFamilyTreeNameLB.numberOfLines = 4;
    [self addSubview:self.currentFamilyTreeNameLB];
    
    //切换家谱
    self.changeFamilyTreeLB = [[UILabel alloc]init];
    self.changeFamilyTreeLB.font = MFont(12);
    self.changeFamilyTreeLB.text = @"切\n换\n家\n谱";
    [self labelHeightToFit:self.changeFamilyTreeLB andFrame:CGRectMake(0.9259*Screen_width, 0.2174*CGRectH(self), 0.0469*Screen_width, 200)];
    [self addSubview:self.changeFamilyTreeLB];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickChangeFamilyTreeName:)];
    self.changeFamilyTreeLB.userInteractionEnabled = YES;
    [self.changeFamilyTreeLB addGestureRecognizer:tap];
    
}

-(void)initFamilyTreeNameBtns{
    //self.changeFamilyTreeSV.backgroundColor = [UIColor random];
    if (self.hyjpArrC.count < 9 ) {
        self.changeFamilyTreeSV.frame = CGRectMake(Screen_width - 0.1001*Screen_width*self.hyjpArrC.count-0.1219*CGRectW(self), 0, 0.1001*Screen_width*self.hyjpArrC.count, CGRectH(self));
    }
    self.changeFamilyTreeSV.contentSize = CGSizeMake(0.1001*Screen_width*self.hyjpArrC.count, CGRectH(self));
    for (int i = 0; i < self.hyjpArrC.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.changeFamilyTreeSV.contentSize.width-(0.0938*Screen_width+0.0063*Screen_width)*(i+1), 0, 0.0938*Screen_width, CGRectH(self))];
        [btn setBackgroundImage:MImage(@"gr_ct_qieHuanJiaPu_bg_a") forState:UIControlStateNormal];
        if (i < self.hyjpArrC.count) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 40, 0);
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.font = MFont(12);
            [btn setTitle: self.hyjpArrC[i][@"jpname"] forState:UIControlStateNormal];
        }
        btn.tag = 51+i;
        [btn addTarget:self action:@selector(clickFamilyTreeNameToChange:) forControlEvents:UIControlEventTouchUpInside];
        btn.userInteractionEnabled = YES;
        [self.changeFamilyTreeSV addSubview:btn];
    }
}

#pragma mark - lazyLoad
-(UIView *)changeFamilyTreeSV{
    if (!_changeFamilyTreeSV) {
        _changeFamilyTreeSV = [[UIScrollView alloc]init];
        _changeFamilyTreeSV.backgroundColor = [UIColor clearColor];
    }
    return _changeFamilyTreeSV;
}

#pragma mark - 加载数据
-(void)reloadData:(NSArray<MemallInfoHyjpModel *> *)hyjpArr{
    if (hyjpArr.count != 0) {
        self.changeFamilyTreeLB.userInteractionEnabled = YES;
        self.hyjpArrC = [self addlineBreaksWithArr:hyjpArr];
        self.currentFamilyTreeNameLB.text = self.hyjpArrC[0][@"jpname"];
        self.currentFamilyTreeInfoLBsArr[3].text = self.hyjpArrC[0][@"jphyname"];
        self.currentFamilyTreeInfoLBsArr[2].text = self.hyjpArrC[0][@"jpdai"];
        self.currentFamilyTreeInfoLBsArr[1].text = self.hyjpArrC[0][@"jpzb"];
        self.currentFamilyTreeInfoLBsArr[0].text = self.hyjpArrC[0][@"jpph"];
    }else{
        self.changeFamilyTreeLB.userInteractionEnabled = NO;
        self.currentFamilyTreeNameLB.text = @"";
        self.currentFamilyTreeInfoLBsArr[3].text = @"";        self.currentFamilyTreeInfoLBsArr[2].text = @"";
        self.currentFamilyTreeInfoLBsArr[1].text = @"";        self.currentFamilyTreeInfoLBsArr[0].text = @"";
        
    }
    [self labelHeightToFit:self.currentFamilyTreeNameLB andFrame:CGRectMake(0.8113*Screen_width, 0.1674*CGRectH(self), 0.0469*Screen_width, 50)];
    for (int i = 0; i < 4; i++) {
        [self labelHeightToFit:self.currentFamilyTreeInfoLBsArr[i] andFrame:CGRectMake(0.380*Screen_width+(0.0938*Screen_width+0.0063*Screen_width)*i, 0.1530*CGRectH(self), 0.0938*Screen_width, 50)];
    }
    
//    [self.headIV.headInsideIV setImageWithURL:[USERDEFAULT valueForKey:@"MeExtension"] placeholder:[UIImage imageNamed:@"headImage.png"]];
}


#pragma mark - 点击事件
-(void)clickChangeFamilyTreeName:(UILabel *)sender{
   
    //设置切换家谱弹出动画
    WK(weakSelf);
    if (self.changeFamilyTreeSV.frame.size.width == 0) {
        self.changeFamilyTreeSV.frame = CGRectMake(0.8781*Screen_width,0,0,CGRectH(self));
        [UIView animateWithDuration:1 animations:^{
            [weakSelf addSubview:weakSelf.changeFamilyTreeSV];
            weakSelf.changeFamilyTreeSV.frame = CGRectMake(0, 0, 0.8781*Screen_width, CGRectH(weakSelf));
            [weakSelf initFamilyTreeNameBtns];
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            weakSelf.changeFamilyTreeSV.frame = CGRectMake(0.8781*Screen_width,0,0,CGRectH(weakSelf));
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.changeFamilyTreeSV removeFromSuperview];
        });
    }
}

-(void)clickFamilyTreeNameToChange:(UIButton *)sender{
    self.currentFamilyTreeNameLB.text = self.hyjpArrC[sender.tag-51][@"jpname"];
    self.currentFamilyTreeInfoLBsArr[3].text = self.hyjpArrC[sender.tag-51][@"jphyname"];
    self.currentFamilyTreeInfoLBsArr[2].text = self.hyjpArrC[sender.tag-51][@"jpdai"];
    self.currentFamilyTreeInfoLBsArr[1].text = self.hyjpArrC[sender.tag-51][@"jpzb"];
    self.currentFamilyTreeInfoLBsArr[0].text = self.hyjpArrC[sender.tag-51][@"jpph"];

    
    WK(weakSelf);
    [UIView animateWithDuration:1 animations:^{
        weakSelf.changeFamilyTreeSV.frame = CGRectMake(0.8781*Screen_width,0,0,CGRectH(self));
    }];
}

-(void)clickHeadIV{
    MYLog(@"点击头像修改");
    EditHeadView *editHeadView = [[EditHeadView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    editHeadView.delegate = self;
    [[self viewController].view addSubview:editHeadView];
}

#pragma mark - EditHeadViewDelegate
-(void)editHeadView:(EditHeadView *)editHeadView HeadInsideImage:(UIImage *)headInsideImage{
    self.headIV.headInsideIV.image = headInsideImage;
    MYLog(@"跳转回来了");
}

//对数据进行加换行符和加文字处理
-(NSMutableArray *)addlineBreaksWithArr:(NSArray<MemallInfoHyjpModel *> *)arr{
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[NSString addLineBreaks:arr[i].jpname] forKey:@"jpname"];
        [dic setValue:[NSString addLineBreaks:arr[i].jphyname] forKey:@"jphyname"];
        [dic setObject:[NSString addLineBreaks:[NSString stringWithFormat:@"第%@代",[NSString translation:(long)arr[i].jpdai]]] forKey:@"jpdai"];
        [dic setObject:[NSString addLineBreaks:[NSString stringWithFormat:@"字辈 %@",arr[i].jpzb]] forKey:@"jpzb"];
        [dic setObject:[NSString addLineBreaks:[NSString stringWithFormat:@"排行%@",[NSString translation:(long)arr[i].jpph]]] forKey:@"jpph"];
        [mutableArr addObject:dic];
    }
    return [mutableArr copy];
}

//高度自适应
-(void)labelHeightToFit:(UILabel *)label andFrame:(CGRect)frame{
    label.numberOfLines = 7;//根据最大行数需求来设置
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(100, 50);//labelsize的最大值
    //关键语句
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    label.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width, expectSize.height);

}



@end
