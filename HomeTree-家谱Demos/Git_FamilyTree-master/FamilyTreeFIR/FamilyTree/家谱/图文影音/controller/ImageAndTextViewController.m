//
//  ImageAndTextViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/5/31.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ImageAndTextViewController.h"
#import "CommonNavigationViews.h"
#import "SelectMyFamilyView.h"
#import "GenealogyInfoModel.h"
#import "NSString+addLineBreakOrSpace.h"

@interface ImageAndTextViewController()<UITableViewDelegate,UITableViewDataSource,CommandNavigationViewsDelegate,SelectMyFamilyViewDelegate>
/** 书视图*/
@property (nonatomic, strong) UIImageView *bookImageView;
/** 左侧表视图*/
@property (nonatomic, strong) UITableView *leftTableView;
/** 正文底部视图*/
@property (nonatomic, strong) UIView *contentView;
/** 时间标签*/
@property (nonatomic, strong) UILabel *timeLB;
/** 正文滚动图*/
@property (nonatomic, strong) UIScrollView *contentSV;
/** 正文图下面的标签*/
@property (nonatomic, strong) UILabel *contentUnderImageLB;
/** 正文右侧视图*/
@property (nonatomic, strong) UIView *rightView;
/** 正文右侧视图标签a*/
@property (nonatomic, strong) UILabel *rightViewLBA;
/** 正文右侧视图标签b*/
@property (nonatomic, strong) UILabel *rightViewLBB;
/** 正文右侧视图标签c*/
@property (nonatomic, strong) UILabel *rightViewLBC;
/** 正文右侧视图标签d*/
@property (nonatomic, strong) UILabel *rightViewLBD;
/** 家谱选择视图*/
@property (nonatomic, strong) SelectMyFamilyView *selecMyFamView;
/** 家谱详情模型*/
@property (nonatomic, strong) GenealogyInfoModel *genealogyInfoModel;
/** 目录数组*/
@property (nonatomic, strong) NSArray *menuArr;
/** 详情数组*/
@property (nonatomic, strong) NSArray *infoArr;

@end

@implementation ImageAndTextViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    //获取数据
    [self getData:[[WFamilyModel shareWFamilModel].myFamilyId integerValue]];
    self.view.backgroundColor = [UIColor whiteColor];
    //配置导航栏
   self.comNavi.delegate = self;
    //设置背景
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    bgImageView.image = MImage(@"bg");
    [self.view addSubview:bgImageView];
    //一本书
    [self initBookImageView];
//    //左边目录
    [self initLeftTableView];
    //书正文视图
    [self initContentView];
    //self.timeLB.text = @"子次公和日";
    [self.view addSubview:self.timeLB];
    [self.view addSubview:self.contentSV];
    //[self initContentSV];
    //self.contentUnderImageLB.text = @"王氏32族谱";
    [self.view addSubview:self.contentUnderImageLB];
    //图下两条线
    //[self initLeftAndRightLineIV];
    [self.view addSubview:self.rightView];
    //右侧四个标签
    [self initRightLBs];
    //self.rightViewLBA.text = @"曾\n氏\n族\n谱";
    self.rightViewLBB.text = @"卷\n一";
//    self.rightViewLBC.text = @"一\n百\n一\n十\n二\n页";
    //self.rightViewLBD.text = @"白\n鹤\n堂";
}

#pragma mark - 网络请求数据
-(void)getData:(NSInteger)GeId{
    if (GeId != 0) {
        NSDictionary *logDic = @{@"geid":@(GeId)};
        WK(weakSelf)
        [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"querygendeta" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            MYLog(@"%@",jsonDic[@"data"]);
            if (succe) {
                weakSelf.genealogyInfoModel = [GenealogyInfoModel modelWithJSON:jsonDic[@"data"]];
                if ([self.comNavi.titleLabel.text isEqualToString:@"阅读家谱"]) {
                    weakSelf.menuArr = [weakSelf.genealogyInfoModel getTextMenuArr];
                    weakSelf.infoArr = [weakSelf.genealogyInfoModel getTextInfoArr];
                }else{
                    weakSelf.menuArr = [weakSelf.genealogyInfoModel getImageMenuArr];
                    weakSelf.infoArr = [weakSelf.genealogyInfoModel getImageInfoArr];
                }
                weakSelf.rightViewLBD.text = [NSString addLineBreaks:weakSelf.genealogyInfoModel.data.GeDisbut];
                weakSelf.rightViewLBA.text = [NSString addLineBreaks:weakSelf.genealogyInfoModel.data.GeName];
                //[weakSelf initLeftTableView];
                [weakSelf.leftTableView reloadData];
                [weakSelf initContentSV:weakSelf.infoArr.firstObject];
                //            MYLog(@"%@",weakSelf.menuArr);
                //            MYLog(@"%@",weakSelf.infoArr);
            }
        } failure:^(NSError *error) {
            
        }];

    }
    
}


#pragma mark - 视图初始化
//一本书
-(void)initBookImageView{
    _bookImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 64+50, 0.95*Screen_width, 0.66*Screen_height)];
    _bookImageView.image = MImage(@"book");
    [self.view addSubview:_bookImageView];
}
//左边目录
-(void)initLeftTableView{
//    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectX(_bookImageView)+10, CGRectY(_bookImageView)+35, 0.2*CGRectW(_bookImageView)+20, CGRectH(_bookImageView)-75) style:UITableViewStylePlain];
//    _leftTableView.backgroundColor = [UIColor clearColor];
//    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//     _leftTableView.showsVerticalScrollIndicator = NO;
//    _leftTableView.bounces = NO;
//    _leftTableView.delegate = self;
//    _leftTableView.dataSource = self;
   [self.view addSubview:self.leftTableView];
}
//正文视图
-(void)initContentView{
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0.3*CGRectW(_bookImageView), CGRectY(_bookImageView)+25, 0.65*CGRectW(_bookImageView), 0.88*CGRectH(_bookImageView)-5)];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.layer.borderColor = [UIColor blackColor].CGColor;
    _contentView.layer.borderWidth = 1;
    [self.view addSubview:_contentView];
}
//图下两条线
//-(void)initLeftAndRightLineIV{
//    UIImageView *leftLineIV =[[UIImageView alloc]initWithFrame:CGRectMake(CGRectX(_contentSV),CGRectY(_contentUnderImageLB)+7, 0.33*CGRectW(_contentSV), 5)];
//    leftLineIV.image = MImage(@"ht_bt");
//    [self.view addSubview:leftLineIV];
//    UIImageView *rightLineIV =[[UIImageView alloc]initWithFrame:CGRectMake(CGRectX(_contentSV)+0.67*CGRectW(_contentSV), CGRectY(_contentUnderImageLB)+7, 0.33*CGRectW(_contentSV), 5)];
//    rightLineIV.image = MImage(@"ht_bt");
//    [self.view addSubview:rightLineIV];
//}
//四个标签
-(void)initRightLBs{
    _rightViewLBA = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(_rightView), CGRectY(_rightView), CGRectW(_rightView), 0.5*CGRectH(_rightView))];
    _rightViewLBA.font = MFont(12);
    _rightViewLBA.numberOfLines = 10;
    _rightViewLBA.textAlignment = NSTextAlignmentCenter;
    _rightViewLBA.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _rightViewLBA.layer.borderWidth = 1;
    [self.view addSubview:_rightViewLBA];
    UIImageView *angelIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectX(_rightView), CGRectYH(_rightViewLBA)+1, CGRectW(_rightView), 7)];
    angelIV.image = MImage(@"zp_top");
    [self.view addSubview:angelIV];
    UIImageView *cakeIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectX(_rightView)+2, CGRectYH(_rightViewLBA)+8, CGRectW(_rightView)-4, 35)];
    cakeIV.image = MImage(@"jz_bg");
    [self.view addSubview:cakeIV];
    _rightViewLBB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(_rightView)+3, CGRectY(cakeIV)+3, CGRectW(_rightView)-6, 30)];
    _rightViewLBB.font = MFont(12);
    _rightViewLBB.textColor = [UIColor whiteColor];
    _rightViewLBB.numberOfLines = 0;
    _rightViewLBB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_rightViewLBB];
    _rightViewLBC = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(_rightView), CGRectY(_rightView)+0.6*CGRectH(_rightView), CGRectW(_rightView), 0.25*CGRectH(_rightView))];
    _rightViewLBC.font = MFont(11);
    _rightViewLBC.numberOfLines = 0;
    _rightViewLBC.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_rightViewLBC];
    _rightViewLBD = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(_rightView), CGRectY(_rightView)+0.8*CGRectH(_rightView), CGRectW(_rightView), 0.2*CGRectH(_rightView))];
    _rightViewLBD.font = MFont(11);
    //_rightViewLBD.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    _rightViewLBD.numberOfLines = 0;
    _rightViewLBD.textAlignment = NSTextAlignmentCenter;
    _rightViewLBD.layer.borderWidth = 1;
    
    [self.view addSubview:_rightViewLBD];
    
}

-(void)initContentSV:(id)content{
    [self.contentSV removeFromSuperview];
    [self.contentSV removeAllSubviews];
    if ([content isKindOfClass:[NSString class]]) {
        NSArray *vertivalStrArr = [self getVerticalStrArr:(NSString *)content];
        self.contentSV.contentSize = CGSizeMake(20*vertivalStrArr.count, CGRectY(self.contentSV));
        [self.view addSubview:self.contentSV];
        for (int i = 0; i < vertivalStrArr.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((vertivalStrArr.count-i-1)*20, 0, 20, CGRectH(self.contentSV))];
            label.text = [NSString addLineBreaks:vertivalStrArr[i]];
            label.numberOfLines = 16;
            label.font = WFont(26);
            [self labelHeightToFit:label andFrame:CGRectMake((vertivalStrArr.count-i-1)*20, 0, 20, CGRectH(self.contentSV))];
            [self.contentSV addSubview:label];
        }
    }
    
    if ([content isKindOfClass:[NSArray class]]) {
        NSArray<NSString *> *contentArr = (NSArray *)content;
        for (int i = 0; i < contentArr.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectW(self.contentSV)*i, 0, CGRectW(self.contentSV), CGRectH(self.contentSV))];
            [imageView setImageWithURL:[NSURL URLWithString:contentArr[i]] placeholder:MImage(@"bk_ye")];
            [self.contentSV addSubview:imageView];
        }
        self.contentSV.contentSize = CGSizeMake(CGRectW(self.contentSV)*contentArr.count, CGRectY(self.contentSV));
        [self.view addSubview:self.contentSV];
    }
    self.contentSV.contentOffset = CGPointMake(self.contentSV.contentSize.width-self.contentSV.frame.size.width, 0);
    
}



#pragma mark - lazyLoad
-(UILabel *)timeLB{
    if (!_timeLB) {
        _timeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(_contentView)+0.65*CGRectW(_contentView)-5, CGRectY(_contentView), 0.25*CGRectW(_contentView), 0.1*CGRectH(_contentView))];
        _timeLB.font = MFont(9);
    }
    return _timeLB;
}


-(UIScrollView *)contentSV{
    if (!_contentSV) {
        _contentSV =[[UIScrollView alloc]initWithFrame:CGRectMake(CGRectX(_contentView)+5, CGRectYH(_timeLB), 0.85*CGRectW(_contentView)-5, 0.80*CGRectH(_contentView))];
        _contentSV.bounces = NO;
    }
    return _contentSV;
}


-(UILabel *)contentUnderImageLB{
    if (!_contentUnderImageLB) {
        _contentUnderImageLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(_contentSV)+0.33*CGRectW(_contentSV), CGRectYH(_contentSV)+10, 0.34*CGRectW(_contentSV), 20)];
        _contentUnderImageLB.textColor = LH_RGBCOLOR(143, 34, 106);
        _contentUnderImageLB.textAlignment = NSTextAlignmentCenter;
        _contentUnderImageLB.font = MFont(10);
    }
    return _contentUnderImageLB;
}
-(UIView *)rightView{
    if (!_rightView) {
        _rightView = [[UIView alloc]initWithFrame:CGRectMake(CGRectX(_contentView)+0.88*CGRectW(_contentView), CGRectY(_contentView), 0.12*CGRectW(_contentView), CGRectH(_contentView))];
        _rightView.layer.borderWidth = 1;
        _rightView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _rightView;
}


-(UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectX(_bookImageView)+10, CGRectY(_bookImageView)+35, 0.2*CGRectW(_bookImageView)+20, CGRectH(_bookImageView)-75) style:UITableViewStylePlain];
        _leftTableView.backgroundColor = [UIColor clearColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.bounces = NO;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}


//-(UIView *)selecMyFamView{
//    if (!_selecMyFamView) {
//        _selecMyFamView = [[SelectMyFamilyView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
//        _selecMyFamView.delegate = self;
//    }
//    return _selecMyFamView;
//}



#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.menuArr[indexPath.row];
    cell.textLabel.font = MFont(11);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self initContentSV:self.infoArr[indexPath.row]];
    
}


#pragma mark - CommandNavigationViewsDelegate
-(void)CommonNavigationViews:(CommonNavigationViews *)comView selectedFamilyId:(NSString *)famId{
    MYLog(@"到这了%@",famId);
    [self getData:[famId integerValue]];

}


#pragma mark *** SelectMyFamViewDelegate ***

-(void)SelectMyFamilyViewDelegate:(SelectMyFamilyView *)seleMyFam didSelectItemTitle:(NSString *)title{
    NSLog(@"%@", title);
}


//对文字处理方便竖行排列
-(NSArray<NSString *> *)getVerticalStrArr:(NSString *)str{
    NSMutableArray *verticalStrArr = [@[] mutableCopy];
     NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSUInteger location = 0;
    NSUInteger length = 16;
    while ([str1 substringFromIndex:location].length > length) {
        NSString *subStr = [str1 substringWithRange:NSMakeRange(location, length)];
        if ([subStr rangeOfString:@"\n"].location != NSNotFound) {
            NSString *subStr1 = [subStr substringWithRange:NSMakeRange(0, [subStr rangeOfString:@"\n"].location)];
            location = location+[subStr rangeOfString:@"\n"].location+1;
            [verticalStrArr addObject:subStr1];
            continue;
        }
        location = location+length;
        [verticalStrArr addObject:subStr];
    }
    [verticalStrArr addObject:[str1 substringFromIndex:location]];
    
    return [verticalStrArr copy];
}



//高度自适应
-(void)labelHeightToFit:(UILabel *)label andFrame:(CGRect)frame{
    label.numberOfLines = 0;//根据最大行数需求来设置
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    label.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width, expectSize.height);
    
}



@end


