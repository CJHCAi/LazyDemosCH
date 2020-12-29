//
//  HKTagSetController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTagSetController.h"
#import "HKMyhobbyController.h"
#import "TTTagView.h"
#import "TTGroupTagView.h"
#import "HK_LoginRegesterTool.h"
@interface HKTagSetController ()<TTTagViewDelegate, TTGroupTagViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

/**
 *  记录输入标签的高度
 */
@property (assign, nonatomic) CGFloat inputHeight;
/**
 *  记录当前所选中的标签数量
 */
@property (nonatomic, strong)UILabel *currentSelectLabel;

/**
 *  输入标签的背景视图(为了改变其高度)
 */
@property (strong, nonatomic) UIView *textBgView;
/**
 *  用来展示标签列表的
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 *  存储获取的标签列表
 */
@property (strong, nonatomic) NSMutableArray *dataArr;

/**
 *  存储标签列表cell的高度
 */
@property (strong, nonatomic) NSMutableArray *heightArr;
/**
 *  记录输入框中输入的标签
 */
@property (strong, nonatomic) NSMutableArray *selectedTags;

/**
 *  记录已选择的标签数量
 */
@property (nonatomic, strong)UIView * countView;
@property (nonatomic, strong)UILabel *countLabel;
/**
 *  下一步按钮
 */
@property (nonatomic, strong)UIView *footSubmitView;
/**
 *  自定义标签 尾视图
 */
@property (nonatomic, strong)UIView *customLabelView;
@property (nonatomic, strong)UILabel *customLabel;
@property (nonatomic, strong)TTTagView * customTagView;

/**
 *  记录初始数据源数组
 */
@property (nonatomic, strong)NSMutableArray * userprierArr;
@property (nonatomic, strong)UIButton *finishBtn;


@end

@implementation HKTagSetController
{
    /**
     *  输入标签view
     */
    TTTagView *inputTagView;
}
#pragma mark - 懒加载数据
- (UIView *)textBgView {
    if (_textBgView == nil) {
        _textBgView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.countView.frame),kScreenWidth,self.inputHeight)];
        
        _textBgView.backgroundColor =[UIColor whiteColor];
        inputTagView =[[TTTagView alloc] initWithFrame:CGRectMake(0, 0,self.view.width ,self.inputHeight)];
        inputTagView.type = TTTagView_Type_Display;
        inputTagView.translatesAutoresizingMaskIntoConstraints=YES;
        {// 这些属性有默认值, 可以不进行设置
            inputTagView.inputBgColor = [UIColor whiteColor];
            inputTagView.bgColor = RGB(255,103,88);
            inputTagView.textColor = [UIColor whiteColor];
            inputTagView.selBgColor = RGB(255,103,88);
            inputTagView.selTextColor = [UIColor whiteColor];
        }
        // KVO监测其高度是否发生改变(改变的话就需要修改下边的所有控件的frame)
        [inputTagView addObserver:self forKeyPath:@"changeHeight" options:NSKeyValueObservingOptionNew context:nil];
        [_textBgView addSubview:inputTagView];
        // 这里刷新是为了如果没有已经存在的标签(bqlabStr)传进来的话就会出问题
        [inputTagView layoutTagviews];
        [inputTagView resignFirstResponder];
    }
    return _textBgView;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.inputHeight+CGRectGetHeight(self.countView.frame), kScreenWidth , kScreenHeight - (NavBarHeight+StatusBarHeight + self.inputHeight+CGRectGetHeight(self.countView.frame)+60+SafeAreaBottomHeight)) style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.showsVerticalScrollIndicator =NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        UIView * head=[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
        head.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        self.tableView.tableHeaderView =head;
    }
    return _tableView;
}
-(UIView *)countView {
    if (!_countView) {
        _countView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,40)];
        _countView.backgroundColor =[UIColor whiteColor];
        [_countView addSubview:self.countLabel];
    }
    return _countView;
}
-(UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(10,15,300,20)];
        [AppUtils getConfigueLabel:_countLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
    }
    return _countLabel;
}

-(UIView *)footSubmitView {
    if (!_footSubmitView) {
        _footSubmitView =[[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight-60-NavBarHeight-StatusBarHeight-SafeAreaBottomHeight,kScreenWidth,60)];
        _footSubmitView.layer.borderWidth=1;
        _footSubmitView.layer.borderColor =[[UIColor groupTableViewBackgroundColor] CGColor];
        _footSubmitView.backgroundColor = MainColor
        UIButton *finish =[UIButton buttonWithType:UIButtonTypeCustom];
        self.finishBtn  =finish;
        finish.frame =CGRectMake(30,6,kScreenWidth-60,48);
        [_footSubmitView addSubview:finish];
        [AppUtils getButton:finish font:PingFangSCRegular15 titleColor:[UIColor whiteColor] title:@"下一步"];
        finish.backgroundColor = [UIColor colorFromHexString:@"cccccc"];
        finish.enabled = NO;
        finish.layer.cornerRadius =5;
        finish.layer.masksToBounds =YES; 
        [finish addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footSubmitView;
}
#pragma mark 自定义标签尾视图
-(UIView *)customLabelView {
    if (!_customLabelView) {
        _customLabelView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,90)];
        _customLabelView.backgroundColor =[UIColor whiteColor];
        [_customLabelView addSubview:self.customLabel];
        [_customLabelView addSubview:self.customTagView];
    }
    return _customLabelView;
}
-(UILabel *)customLabel {
    if (!_customLabel) {
        _customLabel =[[UILabel alloc] initWithFrame:CGRectMake(10,15,300,20)];
        [AppUtils getConfigueLabel:_customLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"自定义标签"];
    }
    return _customLabel;
}
-(TTTagView *)customTagView {
    
    if (!_customTagView) {
        _customTagView =[[TTTagView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.customLabel.frame),CGRectGetMaxY(self.countLabel.frame),kScreenWidth,50)];
        _customTagView.backgroundColor =[UIColor whiteColor];
        _customTagView.translatesAutoresizingMaskIntoConstraints=YES;
        _customTagView.delegate =self;
        {// 这些属性有默认值, 可以不进行设置
            _customTagView.inputTextColor =RGB(132,132,132);
            _customTagView.inputPlaceHolderTextColor =RGB(132,132,132);
            _customTagView.inputBgColor =RGB(237,237, 237);
             _customTagView.bgColor =RGB(237,237, 237);
            _customTagView.textColor =RGB(132,132,132);
            _customTagView.selBgColor =RGB(237,237, 237);
            _customTagView.selTextColor = RGB(132,132,132);
        }
    }
    return _customTagView;
}

-(NSMutableArray *)userprierArr {
    if (!_userprierArr) {
        _userprierArr =[[NSMutableArray alloc] init];
    }
    return _userprierArr;
}
//保存选择标签 下一步.....
-(void)finished {
    if (!self.selectedTags.count) {
        [EasyShowTextView showText:@"还未选择标签"];
        return;
    }
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
    
    [HK_LoginRegesterTool saveUserTagListWithSelectTagArr:self.selectedTags succeessBlock:^{
        [SVProgressHUD dismiss];
        
        HKMyhobbyController *hobyVc =[[HKMyhobbyController alloc] init];
        [self.navigationController pushViewController:hobyVc animated:YES];
        
    } andFail:^(NSString *error) {
          [EasyShowTextView showText:error];
        
    }];
}
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)heightArr {
    if (_heightArr == nil) {
        _heightArr = [NSMutableArray array];
    }
    return _heightArr;
}

- (NSMutableArray *)selectedTags {
    if (_selectedTags == nil) {
        _selectedTags = [NSMutableArray array];
    }
    return _selectedTags;
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
-(void)configueUI {
    self.inputHeight = 50;
    self.view.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    
    [self addSubviews];
    
    [self setData];
}
#pragma mark - 获取顾客标签的列表
- (void)setData {
    
    [HK_LoginRegesterTool getUserSetingTabLabelsSuccess:^(NSArray *array) {
       
        if (array.count) {
            
            for (NSDictionary * dic in array) {
                NSString *name =dic[@"name"];
                [self.selectedTags addObject:name];
                [self.userprierArr addObject:name];
            }
            [self->inputTagView addTags:self.selectedTags];
            self.countLabel.attributedText =[self attrbutionStrWithCount:array.count];
            
        }else {
            self.countLabel.text =@"还未选择标签";
        }
    } userSelectArr:^(NSArray * selectArr) {
        
        self.dataArr = [NSMutableArray arrayWithArray:selectArr];
        self.tableView.tableFooterView =self.customLabelView;
        [self.tableView reloadData];
    } failed:^(NSString *msg) {
        
        [EasyShowTextView showText:msg];
    }];
}
#pragma mark 根据数量获取属性字符串
-(NSMutableAttributedString *)attrbutionStrWithCount:(NSInteger)count {
    if (count) {
        NSString * countStr =[NSString stringWithFormat:@"%zd",count];
        NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已经选择标签 %@",countStr]];
        [att addAttribute:NSForegroundColorAttributeName value:RGB(255,103,88) range:NSMakeRange(7,countStr.length)];
        return  att;
    }
     NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithString:@"还未选择标签"];
    return  att;
}
#pragma mark - 加载子视图
- (void)addSubviews {
    
    [self.view addSubview:self.countView];
    [self.view addSubview:self.textBgView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footSubmitView];
    
}
-(instancetype)init {
    if (self = [super init]) {
        self.sx_disableInteractivePop =YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton =YES;
    self.title =@"我的标签";
    self.view.backgroundColor =[UIColor whiteColor];
    [AppUtils addBarButton:self title:@"跳过" action:@selector(skip) position:PositionTypeRight];
    [self configueUI];
}
//跳过
-(void)skip {
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"确定要跳过此步骤吗?"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:RGB(35,35,35) range:NSMakeRange(0, 9)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 9)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    UIAlertAction *cancleA =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancleA setValue:RGB(132,132,132) forKey:@"titleTextColor"];
    
    [alertController addAction:cancleA];
    UIAlertAction *define =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HKMyhobbyController *hobyVc =[[HKMyhobbyController alloc] init];
        [self.navigationController pushViewController:hobyVc animated:YES];
    }];
    [define setValue:RGB(233,67,48) forKey:@"titleTextColor"];
    [alertController addAction:define];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelectedTag)];
    [cell.contentView addGestureRecognizer:tap];
    [cell.contentView addSubview:[self addHistoryViewTagsWithCGRect:CGRectMake(0, 0, kScreenWidth, 44) andIndex:indexPath]];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.heightArr.count > 0) {
        return [self.heightArr[indexPath.section] floatValue];
        
    } else {
        return 44.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * v =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,1)];
    v.backgroundColor = RGB(237,237,237);
    return v;
}
#pragma mark - 返回组标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,20,200,10)];
    if (self.dataArr.count > 0) {
        HK_Systemlabels * systems =[self.dataArr objectAtIndex:section];
        label.text =systems.name;
    }
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:label];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelectedTag)];
//    [bgView addGestureRecognizer:tap];
    return bgView;
}
#pragma mark - 添加标签列表视图
- (TTGroupTagView *)addHistoryViewTagsWithCGRect:(CGRect)rect andIndex:(NSIndexPath *)indexPath{
    TTGroupTagView *tagView = [[TTGroupTagView alloc] initWithFrame:rect];
    tagView.tag = indexPath.section + 1000;
    tagView.translatesAutoresizingMaskIntoConstraints=YES;
    tagView.delegate = self;
    tagView.changeHeight = 0;
    tagView.backgroundColor = [UIColor clearColor];
    {// 这些属性颜色有默认值, 可以设置也可以不设置
        tagView.bgColor =RGB(237,237, 237);
        tagView.textColor =RGB(132,132,132);
        tagView.selBgColor =RGB(255,103,88);
        tagView.selTextColor = [UIColor whiteColor];
    }
    if (self.dataArr.count > 0) {
      HK_Systemlabels * systems =[self.dataArr objectAtIndex:indexPath.section];
      
        NSMutableArray *tagStrArr =[[NSMutableArray alloc] init];
        
        for (HK_Childrenlabels * child in systems.childrenlabels) {
            [tagStrArr addObject:child.name];
        }
        [tagView addTags:(NSArray *)tagStrArr];
    }
    // 这里存储tagView的最大高度, 是为了设置cell的行高
    [self.heightArr addObject:[NSString stringWithFormat:@"%f", tagView.changeHeight]];
    // 在这里处理上下标签的对应关系, 上边出现的标签如果下边也有的话就要修改其状态(改为选中状态)
    {
        
        if (self.selectedTags.count != 0) {
            NSArray *tags = self.selectedTags;
            [inputTagView addTags:tags];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < tags.count; i ++) {
                
                NSArray *result = [tagView.tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tags[i]]];
                
                if (result.count != 0) {
                    [arr addObject:tags[i]];
                    
                }
            }
            [tagView setTagStringsSelected:arr];
        }
    }
    
    return tagView;
    
}

#pragma mark 验证按钮的可用性
-(void)verfiyNextBtnAbled {
    
    if ([self.userprierArr isEqual:self.selectedTags]) {
        
        self.finishBtn.enabled =NO;
        self.finishBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
    }else {
        
        self.finishBtn.enabled =YES;
        self.finishBtn.backgroundColor = RGB(255,49,34);
    }
}
#pragma mark - TTGroupTagViewDelegate
// 点击下边的固定标签列表, 对应上边的标签是删除还是添加(通过这个代理方法实现)
- (void)buttonClick:(NSString *)string and:(BOOL)isDelete {
    if (isDelete) {// 删除
        
        inputTagView.deleteString = string;
        [self.selectedTags removeObject:string];
    } else {// 添加
        
        [inputTagView addTags:@[string]];
        [self.selectedTags addObject:string];
    }
     self.countLabel.attributedText =[self attrbutionStrWithCount:self.selectedTags.count];
    [self verfiyNextBtnAbled];
}
#pragma mark - TTTagViewDelegate
// 点击上边的输入标签并且删除之后,看下边是否有对应的标签, 有的话就修改其状态
- (void)deleteBtnClick:(NSString *)string {
    
    inputTagView.deleteString = string;
    
    [self.selectedTags removeObject:string];
    
    self.countLabel.attributedText =[self attrbutionStrWithCount:self.selectedTags.count];
    
    [inputTagView layoutTagviews];
    
    [self verfiyNextBtnAbled];
    

    // 遍历下边的固定标签, 看是否有相同的
    for (int j = 0; j < self.dataArr.count; j ++) {
        HK_Systemlabels * syetem = self.dataArr[j];
        NSMutableArray *lists =[[NSMutableArray alloc] init];
        for (HK_Childrenlabels *child in syetem.childrenlabels) {
            [lists addObject:child.name];
        }
        NSArray *result = [lists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", string]];
        
        if (result.count != 0) {
            // 获取到对应的分组标签, 改变其标签的状态
            TTGroupTagView *tagView = [self.view viewWithTag:j + 1000];
            tagView.deleteString = string;
            return;
        }
    }
}
#pragma mark - 上边的输入标签, 输入完成之后, 遍历下边的固定标签, 看是否有相同的, 如果有相同的, 就修改其状态(这里也包括刚进入这个页面的时候从上个页面传进来的标签)
- (void)finishInput:(NSString *)string {
    [inputTagView addTags:@[string]];
    [self.selectedTags addObject:string];
    self.countLabel.attributedText =[self attrbutionStrWithCount:self.selectedTags.count];
    NSMutableArray *arr = [NSMutableArray array];
    [inputTagView layoutTagviews];
    [self verfiyNextBtnAbled];
   
   
    for (int j = 0; j < self.dataArr.count; j ++) {
        HK_Systemlabels * syetem = self.dataArr[j];
        NSMutableArray *lists =[[NSMutableArray alloc] init];
        for (HK_Childrenlabels *child in syetem.childrenlabels) {
            [lists addObject:child.name];
        }
        NSArray *result = [lists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", string]];
        
        if (result.count != 0) {
            [arr addObject:string];
            TTGroupTagView *tagView = [self.view viewWithTag:j + 1000];
            // 修改对应标签的状态为选中状态
            [tagView setTagStringsSelected:arr];
            
            return;
        }
    }
}
#pragma mark - 当被观察的值发生变化，上面那个添加的观察就会生效，而生效后下一步做什么，由下面这个方法决定，下面会输出变化值，即change
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    self.inputHeight = [[change valueForKey:@"new"] floatValue];
    
    self.textBgView.frame = CGRectMake(0,self.textBgView.frame.origin.y,self.textBgView.frame.size.width,self.inputHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableView.frame = CGRectMake(0, self.inputHeight+CGRectGetMaxY(self.countView.frame), kScreenWidth, kScreenHeight - self.inputHeight - NavBarHeight-StatusBarHeight-self.countView.frame.size.height-60-SafeAreaBottomHeight);
    }];

}
#pragma mark - 添加的手势方法(用来取消inputView中的被选中的标签)
- (void)cancelSelectedTag {
    
    [inputTagView layoutTagviews];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [inputTagView layoutTagviews];
    [inputTagView endEditing:YES];
}

@end
