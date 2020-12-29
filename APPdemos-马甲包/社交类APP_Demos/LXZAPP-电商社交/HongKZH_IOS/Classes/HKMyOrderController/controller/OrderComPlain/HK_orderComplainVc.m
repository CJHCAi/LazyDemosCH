//
//  HK_orderComplainVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_orderComplainVc.h"
#import "HK_SingleColumnPickerView.h"
#import "ImageUtil.h"
#import "HK_PickerCell.h"
#import "HK_BaseRequest.h"
#import "AFNetworking.h"
#import "HK_NetWork.h"
#import "HKDateTool.h"
@interface HK_orderComplainVc ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray  * _resonArr;
}
@property (nonatomic, strong)UIView * topInfoView;

@property (nonatomic, strong)UIView *commitView;
@property (nonatomic, strong)UIView *photoView;
@property (nonatomic, strong)UIButton *subMitBtn;
@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)UILabel * tipsLabel;
/** collectionV*/
@property(nonatomic,strong)UICollectionView * collectionView;
/** 图片数组*/
@property(nonatomic,strong)NSMutableArray *pickerImageArr;
//举证或者投诉的地址
@property (nonatomic, copy) NSString *api;

@end

@implementation HK_orderComplainVc
#pragma  mark 根据类型 选择是投诉还是举证
-(void)initNav {
    if (self.type==1) {
            self.title =@"投诉";
        self.api =get_userOrderComplaint;
    }else {
            self.title =@"举证";
        self.api =get_mediaShopbuyerProof;
    }
    [self setShowCustomerLeftItem:YES];
    [AppUtils addBarButton:self title:@"取消" action:@selector(pushSearchVc) position:PositionTypeRight];
    
}
-(void)pushSearchVc {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
/** 文本输入框*/
-(UIView *)commitView {
    if (!_commitView) {
        _commitView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topInfoView.frame)+10,kScreenWidth,200)];
        _commitView.backgroundColor =[UIColor whiteColor];
        UITextView * textV =[[UITextView alloc] initWithFrame:CGRectMake(15,15,kScreenWidth-30,180)];
       textV.backgroundColor =[UIColor clearColor];
        textV.returnKeyType =UIReturnKeyDone;
        textV.delegate =self;
        UILabel *placeHolderLabel=[[UILabel alloc] init];
        if (self.type==1) {
              placeHolderLabel.text =@"请填写投诉原因,字数控制在10-800字";
        }else{
              placeHolderLabel.text =@"请填写举证内容,字数控制在10-800字";
        }
        placeHolderLabel.numberOfLines =0;
        placeHolderLabel.textColor =[UIColor colorFromHexString:@"999999"];
        [placeHolderLabel sizeToFit];
        [textV addSubview:placeHolderLabel];
        [_commitView addSubview:textV];
        textV.font = [UIFont systemFontOfSize:15.f];
        textV.textColor =[UIColor colorFromHexString:@"333333"];
        placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
        [textV  setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        [_commitView addSubview:textV];
        self.textView =textV;
    }
    return _commitView;
}
-(UIView *)topInfoView {
      if (!_topInfoView) {
            _topInfoView =[[UIView alloc] initWithFrame:CGRectMake(0,10,kScreenWidth,60)];
          _topInfoView.backgroundColor =[UIColor whiteColor];
          NSString *title;
          if (self.type==1) {
              title =@"投诉原因";
          }else {
              title =@"举证内容";
          }
          UILabel * tipsLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,0,80,60)];
          [AppUtils getConfigueLabel:tipsLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:title];
          [_topInfoView addSubview:tipsLabel];
          UIImageView * row =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-16-15,20,16,20)];
          row.image =[UIImage imageNamed:@"list_right"];
          [_topInfoView addSubview:row];
          UILabel *resonLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(row.frame)-6-200,0,200,60)];
          [AppUtils getConfigueLabel:resonLabel font:PingFangSCRegular14 aliment:NSTextAlignmentRight textcolor:[UIColor colorFromHexString:@"666666"] text:@"其他原因"];
          self.tipsLabel = resonLabel;
          [_topInfoView addSubview:resonLabel];
          _topInfoView.userInteractionEnabled = YES;
          UITapGestureRecognizer * tapTop =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectReson)];
          [_topInfoView addGestureRecognizer:tapTop];
    }
    return _topInfoView;
}
//选取投诉原因
-(void)selectReson {
   @weakify(self)
    HK_SingleColumnPickerView *picker =[HK_SingleColumnPickerView showWithData:_resonArr callBackBlock:^(NSString *value, NSInteger index) {
        @strongify(self)
        self.tipsLabel.text =value;
    }];
    [self.navigationController.view addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    _resonArr =[NSMutableArray arrayWithObjects:@"退款未达成一致",@"退款金额未达成一致",@"退款运费未达成一致",@"假货",@"其他原因", nil];
    
    
    [self.view addSubview:self.topInfoView];
    [self.view addSubview:self.commitView];
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.subMitBtn];
  
}

-(UIView *)photoView {
    if (!_photoView) {
        _photoView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.commitView.frame)+10,kScreenWidth,190)];
        _photoView.backgroundColor =[UIColor whiteColor];
        UILabel * tipsOne=[[UILabel alloc] initWithFrame:CGRectMake(15,15,300,10)];
        [AppUtils getConfigueLabel:tipsOne font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"666666"] text:@"上传凭证 (选填)"];
        [_photoView addSubview:tipsOne];
        UILabel *tipsTwo=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(tipsOne.frame),CGRectGetHeight(_photoView.frame)-15-CGRectGetHeight(tipsOne.frame),kScreenWidth-30,CGRectGetHeight(tipsOne.frame))];
        [_photoView addSubview:tipsTwo];
        NSString *message;
        if (self.type==1) {
            message =@"投诉内容包括但不限于商品实物凭证.沟通凭证.物流凭证等";
        }else {
            message =@"举证内容包括但不限于商品实物凭证.沟通凭证.物流凭证等";
        }
        
        [AppUtils getConfigueLabel:tipsTwo font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"cccccc"] text:message];
        UILabel *tipsThree=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(tipsTwo.frame), CGRectGetMinY(tipsTwo.frame)-10-10,CGRectGetWidth(tipsTwo.frame),CGRectGetHeight(tipsTwo.frame))
                            ];
        [_photoView addSubview:tipsThree];
        [AppUtils getConfigueLabel:tipsThree font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"cccccc"] text:@"最多5张,支持jpg,jpeg,png格式"];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 3.0;
        layout.itemSize = CGSizeMake(100, 100);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMinX(tipsOne.frame),CGRectGetMaxY(tipsOne.frame)+10,kScreenWidth-20,100) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.bounces =NO;
        self.collectionView.showsHorizontalScrollIndicator =NO;
        self.collectionView.backgroundColor =[UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.collectionView registerClass:[Hk_PickerCell class] forCellWithReuseIdentifier:@"pickerCell"];
        [_photoView addSubview:self.collectionView];

    }
    return _photoView;
    
}

-(UIButton *)subMitBtn {
    if (!_subMitBtn) {
        _subMitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [AppUtils getButton:_subMitBtn font:PingFangSCRegular16 titleColor:[UIColor whiteColor] title:@"提交"];
        _subMitBtn.frame =CGRectMake(15,kScreenHeight-StatusBarHeight-NavBarHeight-22-49-SafeAreaBottomHeight,kScreenWidth-30,49);
        _subMitBtn.layer.cornerRadius =5;
        _subMitBtn.layer.masksToBounds = YES;
        _subMitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        [_subMitBtn addTarget:self action:@selector(subComplains) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subMitBtn;
}
//提交投诉
-(void)subComplains {
    
    if (!self.pickerImageArr.count) {
        [EasyShowTextView showText:@"请先上传凭证"];
        return;
    }
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:self.orderNumber forKey:@"orderNumber"];
    if (self.type==1) {
        [params setValue:self.tipsLabel.text forKey:@"complaintReason"];
        [params setValue:self.textView.text forKey:@"complaintDesc"];
    }else {
        [params setValue:self.tipsLabel.text forKey:@"buyerProof"];
        [params setValue:self.textView.text forKey:@"buyerProofDesc"];
    }
    
#pragma mark 上传图片...
    [HK_NetWork uploadEditImageURL:self.api parameters:params images:self.pickerImageArr name:@"imgSrc" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:@"jpeg" specifications:nil progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            
             [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark 设置文本间隔
-(void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];

        if (textView.text.length) {
            self.subMitBtn.backgroundColor = [UIColor colorFromHexString:@"c5594e"];
            self.subMitBtn.enabled =YES;
        }else {
            self.subMitBtn.backgroundColor =[ UIColor colorFromHexString:@"#cccccc"];
            self.subMitBtn.enabled =NO;
        }
    if(!position) {
        //  textview 改变字体的行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;// 字体的行间距
        NSDictionary *attributes = @{
                                     
                                     NSFontAttributeName:[UIFont systemFontOfSize:15],
                                     
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     
                                     };
        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    }
}
#pragma mark 蓝加载数据
-(NSMutableArray *)pickerImageArr {
    
    if (!_pickerImageArr) {
        
        _pickerImageArr =[[NSMutableArray alloc] init];
    }
    return _pickerImageArr;
}
#pragma mark uicollectionViewDelegete 代理事件
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.pickerImageArr.count==5) {
        
        return  self.pickerImageArr.count;
    }else {
        return  self.pickerImageArr.count +1;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pickerImageArr.count) {
        //上传照片
        [self  pickImage];
    }
    else
    {
        [self deletePictureWithIndexPath:indexPath];
        //删除图片
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Hk_PickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pickerCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.pickerImageArr.count) {
        cell.iocnV.image = [UIImage imageNamed:@"picker"];
    }
    else
    {
        cell.iocnV.image = self.pickerImageArr[indexPath.row];
    }
    return cell;
}
#pragma mark 删除图片
-(void)deletePictureWithIndexPath:(NSIndexPath *)indexPath {
    //点击每一个弹出是否删除按钮
    UIAlertController * alertPicker =[UIAlertController alertControllerWithTitle:@"删除图片" message:@"删除后不可以恢复" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * defineAc =[UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //确定删除
        //移除当前数据源。刷新列表
        [self.pickerImageArr removeObjectAtIndex:indexPath.row];
        [self.collectionView reloadData];
    }];
    [alertPicker addAction:defineAc];
    UIAlertAction *cancleAc =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
        
    }];
    [alertPicker addAction:cancleAc];
    [self presentViewController:alertPicker animated:YES completion:nil];
}
//从相册里找
- (void)pickImage{

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [AppUtils openImagePicker:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *img=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    img = [ImageUtil fixImageOrientation:img];
    
    //从相册获得的照片添加到数组中
    [self.pickerImageArr addObject:img];
    [self.collectionView reloadData];
}
@end
