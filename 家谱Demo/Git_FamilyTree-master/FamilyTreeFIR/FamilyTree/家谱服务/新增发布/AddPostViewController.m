//
//  AddPostViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/29.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "AddPostViewController.h"

@interface AddPostViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
/** 背景滚动图*/
@property (nonatomic, strong) UIScrollView *backSV;
/** 项目类型后的白色背景*/
@property (nonatomic, strong) UIView *firstBackView;
/** 项目类型按钮*/
@property (nonatomic, strong) UIButton *projectTypeBtn;
/** 项目类型数组*/
@property (nonatomic, strong) NSArray<NSString * > *projectTypeStrArr;
/** 项目类型选择表*/
@property (nonatomic, strong) UITableView *projectTypeSelectTB;
/** 项目名称文本框*/
@property (nonatomic, strong) UITextField *projectNameTF;
/** 项目金额文本框*/
@property (nonatomic, strong) UITextField *projectMoneyTF;
/** 项目期限按钮*/
@property (nonatomic, strong) UIButton *projectDeadlineBtn;
/** 项目期限数组*/
@property (nonatomic, strong) NSArray<NSString *> *projectDeadlineStrArr;
/** 项目期限选择表*/
@property (nonatomic, strong) UITableView *projectDeadLineSelectTB;
/** 项目介绍文本视图*/
@property (nonatomic, strong) UITextView *projectInfoTV;

/** 项目图片后的白色背景*/
@property (nonatomic, strong) UIView *secondBackView;
/** 项目图片数组*/
@property (nonatomic, strong) NSMutableArray<UIButton *> *projectImageBtnArr;
/** 封面图按钮*/
@property (nonatomic, strong) UIButton *coverImageBtn;
/** 联系人文本框*/
@property (nonatomic, strong) UITextField *linkmanTF;
/** 电话文本框*/
@property (nonatomic, strong) UITextField *telephoneTF;
/** 提交审核按钮*/
@property (nonatomic, strong) UIButton *postBtn;
/** picker控制器*/
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
/** 用于识别点击哪个按钮的图*/
@property (nonatomic, assign) NSInteger imageTag;
/** 项目图片数组*/
@property (nonatomic, strong) NSMutableArray<NSData *> *projectImageDataArr;
/** 项目封面图*/
@property (nonatomic, strong) UIImage *coverImage;
@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - 视图初始化
-(void)initUI{
    [self.view addSubview:self.backSV];
    [self.backSV addSubview:self.firstBackView];
    self.firstBackView.sd_layout.leftSpaceToView(self.backSV,0).rightSpaceToView(self.backSV,0).topSpaceToView(self.backSV,0).heightIs(270);
    //项目类型
    UILabel *projectTypeLB = [[UILabel alloc]init];
    projectTypeLB.text = @"项目类型:";
    projectTypeLB.font = MFont(13);
    projectTypeLB.textAlignment = NSTextAlignmentLeft;
    [self.firstBackView addSubview:projectTypeLB];
    projectTypeLB.sd_layout.topSpaceToView(self.firstBackView,18).leftSpaceToView(self.firstBackView,30).widthIs(65).heightIs(30);
    
    [self.firstBackView addSubview:self.projectTypeBtn];
    self.projectTypeBtn.sd_layout.leftSpaceToView(projectTypeLB,0).topEqualToView(projectTypeLB).widthIs(85).heightIs(30);
    
    //项目名称
    UILabel *projectNameLB = [[UILabel alloc]init];
    projectNameLB.text = @"项目名称:";
    projectNameLB.font = MFont(13);
    projectNameLB.textAlignment = NSTextAlignmentLeft;
    [self.firstBackView addSubview:projectNameLB];
    projectNameLB.sd_layout.topSpaceToView(projectTypeLB,13).leftSpaceToView(self.firstBackView,30).widthIs(65).heightIs(30);
    
    [self.firstBackView addSubview:self.projectNameTF];
    self.projectNameTF.sd_layout.leftSpaceToView(projectNameLB,0).topEqualToView(projectNameLB).widthIs(175).heightIs(30);
    
    //项目金额
    UILabel *projectMoneyLB = [[UILabel alloc]init];
    projectMoneyLB.text = @"项目金额:";
    projectMoneyLB.font = MFont(13);
    projectMoneyLB.textAlignment = NSTextAlignmentLeft;
    [self.firstBackView addSubview:projectMoneyLB];
    projectMoneyLB.sd_layout.topSpaceToView(projectNameLB,13).leftSpaceToView(self.firstBackView,30).widthIs(65).heightIs(30);
    
    [self.firstBackView addSubview:self.projectMoneyTF];
    self.projectMoneyTF.sd_layout.leftSpaceToView(projectMoneyLB,0).topEqualToView(projectMoneyLB).widthIs(85).heightIs(30);
    
    UILabel *yuanLB = [[UILabel alloc]init];
    yuanLB.text = @"元";
    yuanLB.font = MFont(13);
    [self.firstBackView addSubview:yuanLB];
    yuanLB.sd_layout.leftSpaceToView(self.projectMoneyTF,0).topEqualToView(self.projectMoneyTF).widthIs(20).heightIs(30);
    
    //项目期限
    UILabel *projectDeadlineLB = [[UILabel alloc]init];
    projectDeadlineLB.text = @"项目期限:";
    projectDeadlineLB.font = MFont(13);
    projectDeadlineLB.textAlignment = NSTextAlignmentLeft;
    [self.firstBackView addSubview:projectDeadlineLB];
    projectDeadlineLB.sd_layout.topSpaceToView(projectMoneyLB,13).leftSpaceToView(self.firstBackView,30).widthIs(65).heightIs(30);
    
    [self.firstBackView addSubview:self.projectDeadlineBtn];
    self.projectDeadlineBtn.sd_layout.leftSpaceToView(projectDeadlineLB,0).topEqualToView(projectDeadlineLB).widthIs(50).heightIs(30);
    
    UILabel *dayLB = [[UILabel alloc]init];
    dayLB.text = @"周";
    dayLB.font = MFont(13);
    [self.firstBackView addSubview:dayLB];
    dayLB.sd_layout.leftSpaceToView(self.projectDeadlineBtn,0).topEqualToView(self.projectDeadlineBtn).widthIs(20).heightIs(30);
    
    //项目介绍
    UILabel *projectInfoLB = [[UILabel alloc]init];
    projectInfoLB.text = @"项目介绍:";
    projectInfoLB.font = MFont(13);
    projectInfoLB.textAlignment = NSTextAlignmentLeft;
    [self.firstBackView addSubview:projectInfoLB];
    projectInfoLB.sd_layout.topSpaceToView(projectDeadlineLB,13).leftSpaceToView(self.firstBackView,30).widthIs(65).heightIs(30);
    
    [self.firstBackView addSubview:self.projectInfoTV];
    self.projectInfoTV.sd_layout.leftSpaceToView(projectInfoLB,0).topEqualToView(projectInfoLB).rightSpaceToView(self.firstBackView,10).heightIs(60);
    
    //第二块白
    [self.backSV addSubview:self.secondBackView];
    self.secondBackView.sd_layout.leftSpaceToView(self.backSV,0).topSpaceToView(self.firstBackView,8).rightSpaceToView(self.backSV,0).heightIs(380);
    
    //项目图片
    UILabel *projectImageLB = [[UILabel alloc]init];
    projectImageLB.text = @"项目图片:";
    projectImageLB.font = MFont(13);
    projectImageLB.textAlignment = NSTextAlignmentLeft;
    [self.secondBackView addSubview:projectImageLB];
    projectImageLB.sd_layout.topSpaceToView(self.secondBackView,23).leftSpaceToView(self.secondBackView,30).widthIs(65).heightIs(30);
    
    for (int i = 0; i < 6; i++) {
        UIButton *projectImageBtn = [[UIButton alloc]init];
        [projectImageBtn setBackgroundImage:MImage(@"xinJianMuYuan_add") forState:UIControlStateNormal];
        projectImageBtn.tag = 111+i;
        [projectImageBtn addTarget:self action:@selector(clickToSelectProjectImage:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(projectImageBtnLongPress:)];
        longPress.minimumPressDuration = 2;
        [projectImageBtn addGestureRecognizer:longPress];
        [self.secondBackView addSubview:projectImageBtn];
        [self.projectImageBtnArr addObject:projectImageBtn];
        }
    for (int i = 0; i < 6; i++) {
        if (i == 0) {
            self.projectImageBtnArr[i].sd_layout.leftSpaceToView(projectImageLB,0).topEqualToView(projectImageLB).widthIs(60).heightIs(60);
        }else if (i == 3){
            self.projectImageBtnArr[i].sd_layout.leftEqualToView(self.projectImageBtnArr[0]).topSpaceToView(self.projectImageBtnArr[0],8).widthIs(60).heightIs(60);
        }else{
            self.projectImageBtnArr[i].sd_layout.leftSpaceToView(self.projectImageBtnArr[i-1],8).topEqualToView(self.projectImageBtnArr[i-1]).widthIs(60).heightIs(60);
        }
    }
    
    
    
    //长按删除的提示
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"(长按2秒删除图片)";
    tipLabel.font = MFont(13);
    [self.secondBackView addSubview:tipLabel];
    tipLabel.sd_layout.leftEqualToView(self.projectImageBtnArr.firstObject).topSpaceToView(self.projectImageBtnArr.firstObject,70).heightIs(30).widthIs(165);
    //封面图
    UILabel *coverImageLB = [[UILabel alloc]init];
    coverImageLB.text = @"封面图:";
    coverImageLB.font = MFont(13);
    coverImageLB.textAlignment = NSTextAlignmentCenter;
    [self.secondBackView addSubview:coverImageLB];
    coverImageLB.sd_layout.topSpaceToView(tipLabel,10).leftSpaceToView(self.secondBackView,35).widthIs(45).heightIs(30);
    
    [self.secondBackView addSubview:self.coverImageBtn];
    self.coverImageBtn.sd_layout.leftEqualToView(self.projectImageBtnArr[0]).topEqualToView(coverImageLB).widthIs(60).heightIs(60);
    //联系人
    UILabel *linkmanLB = [[UILabel alloc]init];
    linkmanLB.text = @"联系人:";
    linkmanLB.font = MFont(13);
    linkmanLB.textAlignment = NSTextAlignmentCenter;
    [self.secondBackView addSubview:linkmanLB];
    linkmanLB.sd_layout.topSpaceToView(coverImageLB,50).leftSpaceToView(self.secondBackView,35).widthIs(45).heightIs(30);
    
    [self.secondBackView addSubview:self.linkmanTF];
    self.linkmanTF.sd_layout.leftEqualToView(self.coverImageBtn).topEqualToView(linkmanLB).widthIs(175).heightIs(30);
    //电话
    UILabel *telephoneLB = [[UILabel alloc]init];
    telephoneLB.text = @"电话:";
    telephoneLB.font = MFont(13);
    telephoneLB.textAlignment = NSTextAlignmentCenter;
    [self.secondBackView addSubview:telephoneLB];
    telephoneLB.sd_layout.topSpaceToView(linkmanLB,13).leftSpaceToView(self.secondBackView,47).widthIs(30).heightIs(30);
    
    [self.secondBackView addSubview:self.telephoneTF];
    self.telephoneTF.sd_layout.leftEqualToView(self.linkmanTF).topEqualToView(telephoneLB).widthIs(175).heightIs(30);
    
    //提交审核
    [self.backSV addSubview:self.postBtn];
    self.postBtn.sd_layout.topSpaceToView(self.secondBackView,14).leftSpaceToView(self.backSV,10).rightSpaceToView(self.backSV,10).heightIs(40);
}

#pragma mark - 点击方法
-(void)clickProjectTypeBtn:(UIButton *)sender{
    MYLog(@"项目类型");
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.firstBackView addSubview:self.projectTypeSelectTB];
        self.projectTypeSelectTB.sd_layout.topSpaceToView(self.projectTypeBtn,0).leftEqualToView(self.projectTypeBtn).widthIs(85).heightIs(100);
    }else{
       [self.projectTypeSelectTB removeFromSuperview];
    }
    
}

-(void)clickProjectDeadlineBtn:(UIButton *)sender{
    MYLog(@"项目期限");
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.firstBackView addSubview:self.projectDeadLineSelectTB];
        self.projectDeadLineSelectTB.sd_layout.topSpaceToView(self.projectDeadlineBtn,0).leftEqualToView(self.self.projectDeadlineBtn).widthIs(50).heightIs(100);
    }else{
        [self.self.projectDeadLineSelectTB removeFromSuperview];
    }

}


-(void)clickToSelectProjectImage:(UIButton *)sender{
    self.imageTag = sender.tag;
    [self projectImageAction];
    
}

//长按删除
-(void)projectImageBtnLongPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        MYLog(@"长按");
        UIButton *newBTN =(UIButton *)longPress.view;
        [newBTN setBackgroundImage:MImage(@"xinJianMuYuan_add") forState:UIControlStateNormal];
    }
    
}


- (void)projectImageAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:@"获取图片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开 图片编辑器 用相机的形式打开
        [self chooseProjectImage:(UIImagePickerControllerSourceTypeCamera)];
    }];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开 图片编辑器 用相册的形式打开
        [self chooseProjectImage:(UIImagePickerControllerSourceTypePhotoLibrary)];
    }];
    
    [alert addAction:cancel];
    [alert addAction:camera];
    [alert addAction:photoLibrary];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)chooseProjectImage:(UIImagePickerControllerSourceType)type {
    //类型 是 相机  或  相册
    self.imagePickerController.sourceType = type;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}

-(void)clickToPost{
    MYLog(@"提交");
    if (IsNilString(self.projectNameTF.text) ) {
        [SXLoadingView showAlertHUD:@"请填写项目名称" duration:0.5];
    }else if (self.coverImage == nil){
        [SXLoadingView showAlertHUD:@"请选择项目封面" duration:0.5];
    }else if ([self.projectTypeBtn.currentTitle isEqualToString:@"赏金寻亲"]||[self.projectTypeBtn.currentTitle isEqualToString:@"募捐圆梦"]){
        if (IsNilString(self.projectMoneyTF.text) ) {
            [SXLoadingView showAlertHUD:@"请填写项目金额" duration:0.5];
        }else{
            [self postData];
        }
    }else{
        [self postData];
    }
}


#pragma mark - 提交数据
-(void)postData{
    NSString *zqType = @"";
    if ([self.projectTypeBtn.currentTitle isEqualToString:@"赏金寻亲"]) {
        zqType = @"SJXQ";
    }else if ([self.projectTypeBtn.currentTitle isEqualToString:@"募捐圆梦"]){
         zqType = @"MJYM";
    }else if ([self.projectTypeBtn.currentTitle isEqualToString:@"我需要"]){
         zqType = @"WXY";
    }else {
         zqType = @"WTG";
    }
    
    NSDictionary *logDic = @{@"ZqMeid":GetUserId,
                             @"ZqGeid":@"",
                             @"ZqGemeid":@"",
                             @"ZqType":zqType,
                             @"ZqTitle":self.projectNameTF.text,
                             @"ZqBrief":self.projectInfoTV.text,
                             @"ZqMoney":@([self.projectMoneyTF.text integerValue]),
                             @"Sx":@([self.projectDeadlineBtn.currentTitle integerValue]*7),
                             @"ZqContacts":self.linkmanTF.text,
                             @"ZqTel":self.telephoneTF.text,
                             @"ZqSignificance":@""
                             };
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeCreateZqhz success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"11%@",jsonDic);
        if (succe) {
            [SXLoadingView showAlertHUD:jsonDic[@"message"] duration:0.5];
            [weakSelf uploadImage:[jsonDic[@"data"] integerValue]];
        }else{
            [SXLoadingView showAlertHUD:jsonDic[@"message"] duration:0.5];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)uploadImage:(NSInteger)zqid{
    //封面照片
        NSData *imageData = UIImageJPEGRepresentation(self.coverImage, 0.5);
        NSString *encodeimageStr =[imageData base64EncodedString];
        NSDictionary *params =@{@"userid":GetUserId,
                                @"zqid":@(zqid),
                                @"uploadtype":@"FM",
                                @"imgArray":@[@{@"imgVal":encodeimageStr}]};
        [TCJPHTTPRequestManager POSTWithParameters:params requestID:GetUserId requestcode:kRequestCodeUploadClan success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            MYLog(@"%@",jsonDic);
            if (succe) {
                
            }
        } failure:^(NSError *error) {
            
        }];
    //项目图片
    //判断图片是否被添加
    NSData *originalData = UIImagePNGRepresentation(MImage(@"xinJianMuYuan_add"));
    for (int i = 0; i < 6; i++) {
        NSData *currentData = UIImagePNGRepresentation(self.projectImageBtnArr[i].currentBackgroundImage);
        if (![currentData isEqual:originalData]) {
            NSData *currentData1 = UIImageJPEGRepresentation(self.projectImageBtnArr[i].currentBackgroundImage, 0.1);
            [self.projectImageDataArr addObject:currentData1];
        }
    }
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 0; i < self.projectImageDataArr.count; i++) {
        NSString *encodeimageStr =[self.projectImageDataArr[i] base64EncodedString];
        NSDictionary *dic = @{@"imgVal":encodeimageStr};
        [array addObject:dic];
    }
    
    NSDictionary *params1 =@{@"userid":GetUserId,
                            @"zqid":@(zqid),
                            @"uploadtype":@"ZP",
                            @"imgArray":array};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:params1 requestID:GetUserId requestcode:kRequestCodeUploadClan success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];

    

}

#pragma mark *** UIImagePickerControllerDelegate ***

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (self.imageTag != 111+6) {
      [self.projectImageBtnArr[self.imageTag-111] setBackgroundImage:info[UIImagePickerControllerEditedImage] forState:0];
    }else{
        [self.coverImageBtn setBackgroundImage:info[UIImagePickerControllerEditedImage] forState:0];
        self.coverImage = info[UIImagePickerControllerEditedImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.projectTypeSelectTB]) {
        return self.projectTypeStrArr.count;
    }else{
        return self.projectDeadlineStrArr.count;
    }
    
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addPostCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addPostCell"];
    }
    if ([tableView isEqual:self.projectTypeSelectTB]) {
        cell.textLabel.text = self.projectTypeStrArr[indexPath.row];
    }else{
        cell.textLabel.text = self.projectDeadlineStrArr[indexPath.row];
    }
    cell.textLabel.font = MFont(12);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        {
            if ([tableView isEqual:self.projectTypeSelectTB]) {
                [self.projectTypeBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                self.projectTypeBtn.selected = NO;
            }else{
                [self.projectDeadlineBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                self.projectDeadlineBtn.selected = NO;
            }
            
            [tableView removeFromSuperview];

        }
    }];
    [cell addGestureRecognizer:tap];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma  mark - UITextFieldDelegate
//金额跟电话限制为数字输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.projectMoneyTF]||[textField isEqual:self.telephoneTF]) {
        return [NSString validateNumber:string];
    }else{
        return YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    MYLog(@"将要开始编辑");
    if ([textField isEqual:self.linkmanTF]||[textField isEqual:self.telephoneTF]) {
        if (self.backSV.frame.origin.y == 64) {
            [UIView animateWithDuration:1 animations:^{
                CGRect frame =  self.backSV.frame;
                frame.origin.y = 64-216+20;
                self.backSV.frame = frame;
            }];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextView *)textField{
    MYLog(@"结束编辑");
    if ([textField isEqual:self.linkmanTF]||[textField isEqual:self.telephoneTF]){
    if (self.backSV.frame.origin.y !=64) {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame =  self.backSV.frame;
            frame.origin.y = 64;
            self.backSV.frame = frame;
        }];
        }
    }
}



#pragma mark - lazyLoad
-(UIScrollView *)backSV{
    if (!_backSV) {
        _backSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _backSV.backgroundColor = LH_RGBCOLOR(236, 236, 236);
        _backSV.contentSize = CGSizeMake(Screen_width, 750);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [self.view endEditing:YES];
        }];
        [_backSV addGestureRecognizer:tap];
    }
    return _backSV;
}

-(UIView *)firstBackView{
    if (!_firstBackView) {
        _firstBackView = [[UIView alloc]init];
        _firstBackView.backgroundColor = [UIColor whiteColor];
    }
    return _firstBackView;
}

-(UIButton *)projectTypeBtn{
    if (!_projectTypeBtn) {
        _projectTypeBtn = [[UIButton alloc]init];
        _projectTypeBtn.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
        _projectTypeBtn.layer.borderWidth = 1;
        [_projectTypeBtn setTitle:@"赏金寻亲" forState:UIControlStateNormal];
        [_projectTypeBtn setImage:MImage(@"wdhz_jiantou") forState:UIControlStateNormal];
        _projectTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 65, 0, 0);
        _projectTypeBtn.titleLabel.font = MFont(12);
        _projectTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [_projectTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_projectTypeBtn addTarget:self action:@selector(clickProjectTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _projectTypeBtn;
}

-(NSArray<NSString *> *)projectTypeStrArr{
    if (!_projectTypeStrArr) {
        _projectTypeStrArr = @[@"赏金寻亲",@"募捐圆梦",@"我需要",@"我提供"];
    }
    return _projectTypeStrArr;
}

-(UITableView *)projectTypeSelectTB{
    if (!_projectTypeSelectTB) {
        _projectTypeSelectTB = [[UITableView alloc]init];
        _projectTypeSelectTB.delegate = self;
        _projectTypeSelectTB.dataSource = self;
        _projectTypeSelectTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _projectTypeSelectTB;
}


-(UITextField *)projectNameTF{
    if (!_projectNameTF) {
        _projectNameTF = [[UITextField alloc]init];
        _projectNameTF.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
        _projectNameTF.layer.borderWidth = 1;
        _projectNameTF.delegate = self;
    }
    return _projectNameTF;
}

-(UITextField *)projectMoneyTF{
    if (!_projectMoneyTF) {
        _projectMoneyTF = [[UITextField alloc]init];
        _projectMoneyTF.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
        _projectMoneyTF.layer.borderWidth = 1;
        _projectMoneyTF.delegate = self;
    }
    return _projectMoneyTF;
}

-(UIButton *)projectDeadlineBtn{
    if (!_projectDeadlineBtn) {
        _projectDeadlineBtn = [[UIButton alloc]init];
        _projectDeadlineBtn.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
        _projectDeadlineBtn.layer.borderWidth = 1;
        [_projectDeadlineBtn setTitle:@"1" forState:UIControlStateNormal];
        [_projectDeadlineBtn setImage:MImage(@"wdhz_jiantou") forState:UIControlStateNormal];
        _projectDeadlineBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        _projectDeadlineBtn.titleLabel.font = MFont(12);
        _projectDeadlineBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_projectDeadlineBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_projectDeadlineBtn addTarget:self action:@selector(clickProjectDeadlineBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _projectDeadlineBtn;
}

-(NSArray<NSString *> *)projectDeadlineStrArr{
    if (!_projectDeadlineStrArr) {
        _projectDeadlineStrArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    }
    return _projectDeadlineStrArr;
}

-(UITableView *)projectDeadLineSelectTB{
    if (!_projectDeadLineSelectTB) {
        _projectDeadLineSelectTB = [[UITableView alloc]init];
        _projectDeadLineSelectTB.dataSource = self;
        _projectDeadLineSelectTB.delegate = self;
        _projectDeadLineSelectTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _projectDeadLineSelectTB;
}

-(UITextView *)projectInfoTV{
    if (!_projectInfoTV) {
        _projectInfoTV = [[UITextView alloc]init];
        _projectInfoTV.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
        _projectInfoTV.layer.borderWidth = 1;
    }
    return _projectInfoTV;
}

-(UIView *)secondBackView{
    if (!_secondBackView) {
        _secondBackView = [[UIView alloc]init];
        _secondBackView.backgroundColor = [UIColor whiteColor];
    }
    return _secondBackView;
}

-(NSMutableArray<UIButton *> *)projectImageBtnArr{
    if (!_projectImageBtnArr) {
        _projectImageBtnArr = [@[] mutableCopy];
    }
    return _projectImageBtnArr;
}

-(UIButton *)coverImageBtn{
    if (!_coverImageBtn) {
        _coverImageBtn = [[UIButton alloc]init];
        [_coverImageBtn setBackgroundImage:MImage(@"xinJianMuYuan_add") forState:UIControlStateNormal];
        _coverImageBtn.tag = 111+6;
        [_coverImageBtn addTarget:self action:@selector(clickToSelectProjectImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverImageBtn;
}

-(UITextField *)linkmanTF{
    if (!_linkmanTF) {
        _linkmanTF = [[UITextField alloc]init];
        _linkmanTF.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
        _linkmanTF.layer.borderWidth = 1;
        _linkmanTF.delegate = self;
    }
    return _linkmanTF;
}

-(UITextField *)telephoneTF{
    if (!_telephoneTF) {
        _telephoneTF = [[UITextField alloc]init];
        _telephoneTF.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
        _telephoneTF.layer.borderWidth = 1;
        _telephoneTF.delegate = self;
    }
    return _telephoneTF;
}

-(UIButton *)postBtn{
    if (!_postBtn) {
        _postBtn = [[UIButton alloc]init];
        _postBtn.backgroundColor = LH_RGBCOLOR(74, 88, 92);
        [_postBtn setTitle:@"提交审核" forState:UIControlStateNormal];
        [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _postBtn.titleLabel.font = MFont(15);
        [_postBtn addTarget:self action:@selector(clickToPost) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

-(UIImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

-(NSMutableArray<NSData *> *)projectImageDataArr{
    if (!_projectImageDataArr) {
        _projectImageDataArr = [@[] mutableCopy];
    }
    return _projectImageDataArr;
}



@end
