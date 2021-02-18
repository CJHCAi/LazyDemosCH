//
//  AddMenberView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "AddMenberView.h"

@interface AddMenberView()

@end

@implementation AddMenberView
- (instancetype)initWithFrame:(CGRect)frame
{
    //改变某是否结婚控件的位置
    _inputViewDown = YES;
    self.backView.hidden = YES;
    
    self = [super initWithFrame:frame];
    if (self) {

        [self getAllDetailDataCallBack:^{
            [self initAddUI];
            self.backView.hidden = false;
        }];
        
        
    }
    return self;
}
-(void)initAddUI{
    
    
    self.generationLabel.frame = CGRectMake(-100, CGRectYH(self.selfYear), 0, 0);
    
    self.gennerationNex.frame = CGRectMake(CGRectXW(self.generationLabel)+10, CGRectYH(self.selfYear), 0, 0);
    
    [self.backView addSubview:self.name];
    
    
    
    
    self.fatheView = [self creatLabelTextWithTitle:@"父亲:" TitleFrame:CGRectMake(20, CGRectYH(self.name)+GapOfView, 55, InputView_height) inputViewLength:75 dataArr:[[WIDModel sharedWIDModel].fatherDic allKeys] inputViewLabel:@"" FinText:nil withStar:false];
    [self.backView addSubview:self.fatheView];
    
//    self.motherView = [self creatLabelTextWithTitle:@"母亲:" TitleFrame:CGRectMake(Screen_width-350*AdaptationWidth(), CGRectYH(self.name)+GapOfView, 55, InputView_height) inputViewLength:75 dataArr:@[@"郭小妹",@"郭二妹",@"速度"] inputViewLabel:@"不详" FinText:nil withStar:YES];
    
    
    
    [self.backView addSubview:self.motherView];
    [self.backView addSubview:self.sexInView];
    
    
    
    
    self.idView = [self creatLabelTextWithTitle:@"身份:" TitleFrame:CGRectMake(CGRectXW(self.sexInView)+20*AdaptationWidth(), self.sexInView.frame.origin.y, 50, InputView_height) inputViewLength:50 dataArr:[[WIDModel sharedWIDModel].idDic allKeys] inputViewLabel:@"嫡出" FinText:nil withStar:NO];
    
    
    [self.backView addSubview:self.idView];
    [self.backView addSubview:self.famousPerson];
    

    //字辈代数和排行
    NSMutableArray *allGenNum = [@[] mutableCopy];
    NSMutableArray *allPaihang = [@[] mutableCopy];
    for (int idx = 0; idx<[[WIDModel sharedWIDModel].ds allKeys].count; idx++) {
        NSArray *dsArr = [[[WIDModel sharedWIDModel].ds allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
             return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        
        NSString *str = [NSString stringWithFormat:@"第%@代",dsArr[idx]];
        [allGenNum addObject:str];
        [allPaihang addObject:[NSString stringWithFormat:@"%d",idx+1]];
        
    }
    
    
    self.gennerNum   = [self creatLabelTextWithTitle:@"家族第几代:" TitleFrame:CGRectMake(20, CGRectYH(self.sexInView)+GapOfView, 0.25*Screen_width, InputView_height) inputViewLength:0.2*Screen_width dataArr:allGenNum inputViewLabel:@"第1代" FinText:nil withStar:YES];
    self.gennerNum.delegate = self;
    [self.backView addSubview:self.gennerNum];
    
    //字辈
    NSString *genNumber = [self.gennerNum.inputLabel.text stringByReplacingOccurrencesOfString:@"第" withString:@""];
    NSString *finStr = [genNumber stringByReplacingOccurrencesOfString:@"代" withString:@""];
    NSArray *zbArr = [WIDModel sharedWIDModel].ds[finStr];
    self.gennerZB = [self creatLabelTextWithTitle:@"            字辈:" TitleFrame:CGRectMake(20, CGRectYH(self.gennerNum)+GapOfView, 0.25*Screen_width, 40) inputViewLength:50 dataArr:zbArr inputViewLabel:zbArr[0] FinText:nil withStar:NO];
    
    [self.backView addSubview:self.gennerZB];
    
    self.rankingView = [self creatLabelTextWithTitle:@"            排行:" TitleFrame:CGRectMake(20, CGRectYH(self.gennerZB)+GapOfView, 0.25*Screen_width, 40) inputViewLength:50 dataArr:allPaihang    inputViewLabel:@"1" FinText:nil withStar:YES];
    self.rankingView.inputLabel.textAlignment = 0;
    
    [self.backView addSubview:self.rankingView];
    
    [self updateBackViewSubViewsLayout];
    
    
}
/** 设置层级关系 */
-(void)updateBackViewSubViewsLayout{
    
    [self.backView bringSubviewToFront:self.sexInView];
    [self.backView bringSubviewToFront:self.rankingView];
    [self.backView bringSubviewToFront:self.gennerZB];
    [self.backView bringSubviewToFront:self.gennerNum];
    [self.backView bringSubviewToFront:self.idView];
    [self.backView bringSubviewToFront:self.fatheView];
    [self.backView bringSubviewToFront:self.motherView];
}

//获取父亲，身份类型，代数字辈

-(void)getAllDetailDataCallBack:(void (^)())back{
    [TCJPHTTPRequestManager POSTWithParameters:@{@"GeId":[WFamilyModel shareWFamilModel].myFamilyId} requestID:GetUserId requestcode:kRequestCodegetgenalldata success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
//            NSLog(@"%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
            
            NSDictionary *dic = [NSString jsonDicWithDic:jsonDic[@"data"]];
            
            [[WIDModel sharedWIDModel] setValue:dic[@"sf"] forKey:@"sf"];
            [[WIDModel sharedWIDModel] setValue:dic[@"ds"] forKey:@"ds"];
            [[WIDModel sharedWIDModel] setValue:dic[@"gemedata"] forKey:@"gemedata"];
            
//            NSLog(@"%@", [WIDModel sharedWIDModel].gemedata[0][@"GemeName"]);
            
            //存进单例
            NSArray *fathArr = [WIDModel sharedWIDModel].gemedata;
            NSMutableDictionary *fatherDic= [NSMutableDictionary dictionary];
            [fathArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [fatherDic setObject:obj[@"GemeId"] forKey:obj[@"GemeName"]];
            }];
            
            NSArray *sfArr = [WIDModel sharedWIDModel].sf;
            NSMutableDictionary *sfDic = [NSMutableDictionary dictionary];
            [sfArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [sfDic setObject:obj[@"AlId"] forKey:obj[@"AlName"]];
            }];
            
            [WIDModel sharedWIDModel].fatherDic = fatherDic;
            [WIDModel sharedWIDModel].idDic = sfDic;
            //拿到的字典是乱序，排序一下
            NSArray *arr = [[WIDModel sharedWIDModel].ds allKeys];
            NSArray *finArr = [arr sortedArrayUsingSelector:@selector(compare:)];
            
            [WIDModel sharedWIDModel].genDic = [WIDModel sharedWIDModel].ds;
            
            
            back();
        }
    } failure:^(NSError *error) {
//        NSLog(@"shibai");
    }];
}

#pragma mark *** InputViewDelegate ***

-(void)InputView:(InputView *)inputView didFinishSelectLabel:(UILabel *)inputLabel{
    [super InputView:inputView didFinishSelectLabel:inputLabel];
    
    if (inputView == self.gennerNum) {
        //字辈
        NSString *genNumber = [self.gennerNum.inputLabel.text stringByReplacingOccurrencesOfString:@"第" withString:@""];
        NSString *finStr = [genNumber stringByReplacingOccurrencesOfString:@"代" withString:@""];
        NSArray *zbArr = [WIDModel sharedWIDModel].ds[finStr];
        self.gennerZB.dataArr = zbArr;
        self.gennerZB.inputLabel.text = zbArr[0];
        
        [self.gennerZB reloadInputViewData];
    }
}


#pragma mark *** getters ***
-(DiscAndNameView *)name{
    if (!_name) {
        _name = [[DiscAndNameView alloc] initWithFrame:CGRectMake(20,40+GapOfView, Screen_width-45, InputView_height) title:@"姓名:" detailCont:@"" isStar:YES];
        
    }
    return _name;
}

-(InputView *)sexInView{
    if (!_sexInView) {
        _sexInView = [[InputView alloc] initWithFrame:CGRectMake(20, CGRectYH(self.fatheView)+GapOfView, 50, InputView_height) Length:50 withData:@[@"男",@"女"]];
        _sexInView.inputLabel.text = @"男";
        
    }
    return _sexInView;
}

-(ClickRoundView *)famousPerson{
    if (!_famousPerson) {
        _famousPerson = [[ClickRoundView alloc] initWithFrame:CGRectMake(CGRectXW(self.idView), self.idView.frame.origin.y, 50, 40) withTitle:@"家族名人" isStar:YES];
    }
    return _famousPerson;
}

-(UITextField *)motherView{
    if (!_motherView) {
        
        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_width-350*AdaptationWidth(), CGRectYH(self.name)+GapOfView, 55, InputView_height)];
        theLabel.text = @"母亲";
        theLabel.font = WFont(33);
        [self.backView addSubview:theLabel];
        
        UITextField *inputView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectXW(theLabel), theLabel.frame.origin.y, 75+10, InputView_height)];
        inputView.text = @"";
        inputView.layer.borderColor = BorderColor;
        inputView.layer.borderWidth = 1.0f;
        inputView.textAlignment = 1;
        
        UILabel *finLabel = [UILabel new];
        finLabel.text = @"";
        [self.backView addSubview:finLabel];
        
        finLabel.sd_layout.leftSpaceToView(inputView,5).topEqualToView(theLabel).bottomEqualToView(theLabel).widthIs(20);
        
            UILabel *starLabel = [UILabel new];
            starLabel.font = MFont(16);
            starLabel.text = @"*";
            starLabel.textColor = [UIColor redColor];
            [self.backView addSubview:starLabel];
            starLabel.sd_layout.leftSpaceToView(inputView,5).widthIs(10).heightIs(InputView_height).topEqualToView(inputView);
        
        _motherView = inputView;
    }
    return _motherView;
}

@end
