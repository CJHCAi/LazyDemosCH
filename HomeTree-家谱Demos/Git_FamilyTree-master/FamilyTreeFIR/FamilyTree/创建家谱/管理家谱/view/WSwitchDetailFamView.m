//
//  WSwitchDetailFamView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/22.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WSwitchDetailFamView.h"

#define arrLenthCount (_famNamesArray.count>4?5:_famNamesArray.count+1)
@interface WSwitchDetailFamView()
@property (nonatomic,strong) UIScrollView *backScroView; /*滚动家谱*/

@end
@implementation WSwitchDetailFamView
- (instancetype)initWithFrame:(CGRect)frame famNamesArr:(NSArray *)famNames
{
    self = [super initWithFrame:frame];
    if (self) {
        _famNamesArray = famNames;
        [self initData];
        [self initUI];
        [self registrNotification];
        
    }
    return self;
}

#pragma mark *** 初始化数据 ***
-(void)initData{
    
}
-(void)getAllFamNames{
    //更新数据
    [TCJPHTTPRequestManager POSTWithParameters:@{@"query":@"",@"type":@"MyGen"} requestID:GetUserId requestcode:kRequestCodequerymygen success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSString *jsonStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"]];
            NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *allFamNams = [@[] mutableCopy];
            NSMutableArray *allFamIds = [@[] mutableCopy];
            for (NSDictionary *dic in arr) {
                [allFamNams addObject:dic[@"GeName"]];
                [allFamIds addObject:dic[@"Geid"]];
            }
            [WSelectMyFamModel sharedWselectMyFamModel].myFamArray = allFamNams;
            [WSelectMyFamModel sharedWselectMyFamModel].myFamIdArray = allFamIds;
            _famNamesArray = [WSelectMyFamModel sharedWselectMyFamModel].myFamArray;
            //更新完数据刷新界面
            [self reloadDataForUI];
        }
    } failure:^(NSError *error) {
        MYLog(@"失败");
    }];
}

-(void)registrNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllFamNames) name:kNotificationCodeManagerFam object:nil];
}

#pragma mark *** 初始化界面 ***
-(void)initUI{
    
    [self addSubview:self.backScroView];
    //卷谱
    NSMutableArray *allBtnArrs = [[WSelectMyFamModel sharedWselectMyFamModel].myFamArray mutableCopy];
    [allBtnArrs insertObject:@"切换家谱" atIndex:0];
    [allBtnArrs addObject:@"创建家谱"];
    for (int idx = 0; idx<allBtnArrs.count; idx++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:AdaptationFrame(0, idx*63, 187, 61)];
        btn.backgroundColor = [UIColor blackColor];
        btn.layer.cornerRadius = 2;
        btn.alpha = 0.8;
        [btn setTitle:allBtnArrs[idx] forState:0];
        btn.titleLabel.font = WFont(30);
        btn.tag = idx;
        [btn addTarget:self action:@selector(respondsToAllBtnArs:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == 0) {
            [self addSubview:btn];
        }else if ([btn.titleLabel.text isEqualToString:@"创建家谱"]) {
            btn.frame = AdaptationFrame(0, (arrLenthCount==0?arrLenthCount+1:arrLenthCount)*63, 187, 61);
            [self addSubview:btn];
        }else{
            
        [self.backScroView addSubview:btn];
            
        }
    }
    //新增和删除
    NSArray *addDeletArr = @[@"新增卷谱",@"删除卷谱"];
    for (int idx = 0; idx<addDeletArr.count; idx++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:AdaptationFrame(35,(arrLenthCount==0?arrLenthCount+1:arrLenthCount)*63+100+60*idx, 140, 60)];
        btn.backgroundColor = [UIColor blackColor];
        btn.layer.cornerRadius = 2;
        btn.alpha = 0.8;
        [btn setTitle:addDeletArr[idx] forState:0];
        btn.titleLabel.font = WFont(30);
        btn.tag = idx+allBtnArrs.count;
        [btn addTarget:self action:@selector(respondsToAllBtnArs:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }

}

-(void)reloadDataForUI{
    [self removeAllSubviews];
    [self.backScroView removeAllSubviews];
    //更新count不然bug
    self.backScroView.contentSize = AdaptationSize(187, (_famNamesArray.count+1)*63);
    self.backScroView.frame =AdaptationFrame(0, 0, 187, arrLenthCount*63);

    [self initUI];
    
}
#pragma mark *** events ***
-(void)respondsToAllBtnArs:(UIButton *)sender{
    
    NSInteger famRepeatCount = 0;
    NSMutableArray *arrC = [@[] mutableCopy];
    if (!([sender.titleLabel.text isEqualToString:@"新增卷谱"]||[sender.titleLabel.text isEqualToString:@"删除卷谱"])) {
        
        for (int idx = 0; idx<sender.tag-1; idx++) {
            [arrC addObject:_famNamesArray[idx]];
        }
        
        for (NSString *string in arrC) {
            if ([string isEqualToString:sender.titleLabel.text]) {
                famRepeatCount += 1;
            }
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(WswichDetailFamViewDelegate:didSelectedButton:repeatNameIndex:)]) {
        [_delegate WswichDetailFamViewDelegate:self didSelectedButton:sender repeatNameIndex:sender.tag-1];
    };
    
    
}
#pragma mark *** getters ***
-(UIScrollView *)backScroView{
    if (!_backScroView) {
        _backScroView = [[UIScrollView alloc] initWithFrame:AdaptationFrame(0, 0, 187, arrLenthCount*63)];
        _backScroView.bounces = true;
        _backScroView.contentSize = AdaptationSize(187, (_famNamesArray.count+1)*63);
    }
    return _backScroView;
}
@end
