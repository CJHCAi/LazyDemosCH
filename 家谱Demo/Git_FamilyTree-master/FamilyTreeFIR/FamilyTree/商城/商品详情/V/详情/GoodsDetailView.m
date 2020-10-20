//
//  GoodsDetailView.m
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodsDetailView.h"
#import "GoodShopView.h"
#import "CommentCell.h"
#import "CommentPersonModel.h"


@interface GoodsDetailView()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

/**
 *  获取数据
 */
@property (strong,nonatomic) NSMutableArray *dataArr;
@property (strong,nonatomic) UIView *commentV;
@property (strong,nonatomic) GoodShopView *goodShopV;
@property (strong,nonatomic) UIView *bottomV;


@property (nonatomic) CGFloat twHeight;
@end

@implementation GoodsDetailView


#pragma mark 获取数据
- (void)getData{
    _dataArr = [NSMutableArray array];
    
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"pagenum":@"1",
                                                 @"pagesize":@"20",
                                                 @"ddh":@"10152",
                                                 @"userid":GetUserId} requestID:GetUserId requestcode:kRequestCodegetevaluate success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         NSLog(@"0.13---%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
                                                     }
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
    
    
    
    for (int i=0; i<3; i++) {
        CommentPersonModel *comModel =[[CommentPersonModel alloc]init];
        if (i==1) {
            comModel.userName = @"用户testbdb";
            comModel.date = @"2015-12-25";
            comModel.content = @"其实评加多少变化也不是特别的大过还是等吧点多吧嘟比嘟比就达不到看看看看看看那看那看那看那看那看你看看看看看看看看看看看卡";
            comModel.color = @"通用";
            comModel.size = @"L 宝宝1岁3个月";
            comModel.star = @"4";
        }else{
            comModel.userName = @"用户测试";
            comModel.date = @"2015-12-29";
            comModel.content = @"其实评加多少变化也不是特别的大";
            comModel.color = @"通用";
            comModel.size = @"L 宝宝1岁3个月";
            comModel.star = @"5";
        }
        [_dataArr addObject:comModel];
    }
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self getData];
        _twHeight = 0;
        self.userInteractionEnabled= YES;
    }
    return self;
}
#pragma mark ==更新tableview的高度==
- (void)getHeight{
    for (int i= 0; i<_dataArr.count; i++) {
        CommentPersonModel *person = _dataArr[i];
        CGFloat height = 0.0 ;
        if (person.content.length*14>__kWidth-20) {
            for (int i=1; i<person.content.length*14/(__kWidth-20)+1; i++) {
                if (person.content.length*14>(__kWidth-20)*i&&person.content.length*14<=(__kWidth-20)*(i+1)) {
                    height =(i+1)*16.0+105;
                }
            }
        }else{
            height = 120;
        }
        _twHeight += height;
    }
    _tableView.frame = CGRectMake(0, CGRectYH(_commentV), __kWidth, _twHeight+40);
}

- (void)initView{
    _chooseGood = [[GoodPayModel alloc]init];
    _goodShopV = [[GoodShopView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 200)];
    [self addSubview:_goodShopV];
    
     _commentV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectYH(_goodShopV)+10, __kWidth, 40)];
    [self addSubview:_commentV];
    _commentV.backgroundColor = [UIColor whiteColor];

    _commentNumberLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 20)];
    [_commentV addSubview:_commentNumberLb];
    _commentNumberLb.font = MFont(16);
    _commentNumberLb.backgroundColor = [UIColor clearColor];
    _commentNumberLb.textAlignment = NSTextAlignmentLeft;
    float value = 97.5;
    _commentNumberLb.text = [NSString stringWithFormat:@"%.1f%%好评",value];//假数据
    //评价星级视图。。可以用封装好的替换
     _starV = [[StarView alloc]initWithFrame:CGRectMake(CGRectXW(_commentNumberLb)+5, 13, 85, 17)];
    [_commentV addSubview:_starV];
    _starV.backgroundColor = [UIColor clearColor];
    [_starV setStar:5];//假数据

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectYH(_commentV), __kWidth, 320)];
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;


    _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 40)];
    [self addSubview:_bottomV];
    _bottomV.backgroundColor = [UIColor whiteColor];
    _bottomV.userInteractionEnabled = YES;

    UIButton* lookBtn = [[UIButton alloc]initWithFrame:CGRectMake((__kWidth-95)/2, 5, 95, 25)];
    [_bottomV addSubview:lookBtn];
    lookBtn.userInteractionEnabled = YES;
    lookBtn.backgroundColor = [UIColor whiteColor];
    lookBtn.titleLabel.font = MFont(14);
    [lookBtn setTitle:@"查看全部评价" forState:BtnNormal];
    [lookBtn setTitleColor:[UIColor redColor] forState:BtnNormal];
    lookBtn.layer.cornerRadius = 3;
    lookBtn.layer.borderColor = [UIColor redColor].CGColor;
    lookBtn.layer.borderWidth = 1;
    [lookBtn addTarget:self action:@selector(lookComment) forControlEvents:BtnTouchUpInside];

}

#pragma mark ==获取商品数据==
-(void)getGoodData:(GoodDetailModel *)sender{
    _goodShopV.goodNameLb.text = sender.goodName;
    
    _goodShopV.payMoneyLb.text = [NSString stringWithFormat:@"¥%@",sender.goodMoney];;
    _goodShopV.quoteLb.text = sender.goodQuote;
    
    NSMutableAttributedString *quoteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",_goodShopV.quoteLb.text]];
    [quoteStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle) range:NSMakeRange(0, quoteStr.length)];
    _goodShopV.quoteLb.attributedText = quoteStr;//加横线
    [_goodShopV getGoodData:sender];
    [_goodShopV updateFrame];
    _goodShopV.frame = CGRectMake(0, 0, __kWidth, _goodShopV.height);
    _goodShopV.goodPayModel.goodName=sender.goodName;
    _goodShopV.goodPayModel.goodMoney= sender.goodMoney;
    

    _chooseGood=_goodShopV.goodPayModel;

    _commentV.frame = CGRectMake(0, CGRectYH(_goodShopV)+10, __kWidth, 40);
    [self getHeight];
    _tableView.tableFooterView = _bottomV;
    [self updateframe];
}


#pragma mark ==查看全部评价==
- (void)lookComment{
    [self.delegate allCommentShow];
}


#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (!cell) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    CommentPersonModel *person = _dataArr[indexPath.row];
    cell.headIV.backgroundColor = LH_RandomColor;
    cell.nameLb.text = person.userName;
    cell.timeLb.text =person.date;
    cell.descLb.text = person.content;
    cell.infoLb.text = [NSString stringWithFormat:@"颜色：%@ 规格：%@",person.color,person.size];
    [cell.StarV setStar:[person.star integerValue]];
    [cell updateFrame];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentPersonModel *person = _dataArr[indexPath.row];
    CGFloat height = 0.0 ;
    if (person.content.length*14>__kWidth-20) {
        for (int i=1; i<person.content.length*14/(__kWidth-20)+1; i++) {
            if (person.content.length*14>(__kWidth-20)*i&&person.content.length*14<=(__kWidth-20)*(i+1)) {
                height =(i+1)*16.0+105;
            }
        }
    }else{
        height = 120;
    }
    return height;
}
#pragma mark ==计算出视图高度值==
- (void)updateframe{
    _detailH = _twHeight+10+_goodShopV.height+85;
}

@end
