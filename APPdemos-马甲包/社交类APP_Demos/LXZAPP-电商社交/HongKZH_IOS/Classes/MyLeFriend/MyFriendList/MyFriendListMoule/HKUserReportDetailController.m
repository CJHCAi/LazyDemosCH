//
//  HKUserReportDetailController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUserReportDetailController.h"
#import "HK_PickerCell.h"
#import "HK_BaseRequest.h"
#import "HK_NetWork.h"
#import "HKDateTool.h"
#import "ImageUtil.h"
@interface HKUserReportDetailController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UIView *commitView;
@property (nonatomic, strong)UIView *photoView;
@property (nonatomic, strong)UIButton *subMitBtn;
@property (nonatomic, strong)UIButton *reportInfoBtn;
@property (nonatomic, strong)UITextView *textView;
/** collectionV*/
@property(nonatomic,strong)UICollectionView * collectionView;
/** 图片数组*/
@property(nonatomic,strong)NSMutableArray *pickerImageArr;
@end

@implementation HKUserReportDetailController
/** 文本输入框*/
-(UIView *)commitView {
    if (!_commitView) {
        _commitView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.photoView.frame)+10,kScreenWidth,200)];
        _commitView.backgroundColor =[UIColor whiteColor];
        UITextView * textV =[[UITextView alloc] initWithFrame:CGRectMake(15,15,kScreenWidth-30,180)];
        textV.backgroundColor =[UIColor clearColor];
        textV.returnKeyType =UIReturnKeyDone;
        textV.delegate =self;
        UILabel *placeHolderLabel=[[UILabel alloc] init];
        placeHolderLabel.text =@"备注内容(选填)";
        placeHolderLabel.numberOfLines =0;
        placeHolderLabel.textColor =RGB(204,204,204);
        [placeHolderLabel sizeToFit];
        [textV addSubview:placeHolderLabel];
        [_commitView addSubview:textV];
        textV.font = [UIFont systemFontOfSize:15.f];
        textV.textColor =[UIColor colorFromHexString:@"333333"];
        placeHolderLabel.font = [UIFont systemFontOfSize:15.f];
        [textV  setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        [_commitView addSubview:textV];
        self.textView =textV;
    }
    return _commitView;
}

-(UIView *)photoView {
    if (!_photoView) {
        _photoView =[[UIView alloc] initWithFrame:CGRectMake(0,10,kScreenWidth,150)];
        _photoView.backgroundColor =[UIColor whiteColor];
        UILabel * tipsOne=[[UILabel alloc] initWithFrame:CGRectMake(15,15,300,10)];
        [AppUtils getConfigueLabel:tipsOne font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(102,102,102) text:@"聊天证据截图"];
        [_photoView addSubview:tipsOne];
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
        _subMitBtn.frame =CGRectMake(30,CGRectGetMinY(self.reportInfoBtn.frame)-15-49,kScreenWidth-60,49);
        _subMitBtn.layer.cornerRadius =5;
        _subMitBtn.layer.masksToBounds = YES;
        _subMitBtn.enabled =NO;
        _subMitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        [_subMitBtn addTarget:self action:@selector(subComplains) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subMitBtn;
}
-(UIButton *)reportInfoBtn {
    if (!_reportInfoBtn) {
        _reportInfoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _reportInfoBtn.frame = CGRectMake(kScreenWidth/2-28,kScreenHeight-NavBarHeight-StatusBarHeight-84,56,14);
        [AppUtils getButton:_reportInfoBtn font:PingFangSCRegular14 titleColor:RGB(104,145,209) title:@"举报须知"];
        [_reportInfoBtn addTarget:self action:@selector(swichToReport) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportInfoBtn;
}
#pragma mark 跳转到举报须知道界面
-(void)swichToReport {
    [EasyShowTextView showText:@"跳转到举报须知"];
}
#pragma mark 提交举报
-(void)subComplains {
    [Toast loading];
    [HK_NetWork uploadEditImageURL:get_userFeedback parameters:@{kloginUid:HKUSERLOGINID,@"content":self.textView.text} images:self.pickerImageArr name:@"imgs" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:nil specifications:nil progress:^(NSProgress *progress) {
    } callback:^(id responseObject, NSError *error) {
        [Toast loaded];
        if (error) {
            [EasyShowTextView showText:@"提交失败"];
        }else {
            if ([[responseObject objectForKey:@"code"] integerValue]==0) {
               //举报完毕...
                [self alertSuccess];
            }else {
                [EasyShowTextView showText:responseObject[@"msg"]];
            }
        }
    }];
}
#pragma mark 设置文本间隔
-(void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (textView.text.length) {
        
        self.subMitBtn.backgroundColor = RGB(255,74,44);
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
-(void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertSuccess {
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"已提交给乐小转团队" message:@"乐小转团队会依据《乐小转用户协议》以及相关政策进行处理" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionKnow =[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
      [actionKnow setValue:keyColor forKey:@"titleTextColor"];
    [alert addAction:actionKnow];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)UIConfigue {
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.commitView];
    [self.view addSubview:self.reportInfoBtn];
    [self.view addSubview:self.subMitBtn];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    UIButton * cancelBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0,0,40,40);
    [AppUtils getButton:cancelBtn font:BoldFont16 titleColor:RGB(102,102,102) title:@"取消"];
    [cancelBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * itemMore =[[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = itemMore;
    [self UIConfigue];

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
    
    if (self.pickerImageArr.count==9) {
        
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
        cell.iocnV.image = [UIImage imageNamed:@"tjtp"];
        cell.closeBtn.hidden = YES;
    }
    else
    {
        cell.iocnV.image = self.pickerImageArr[indexPath.row];
        cell.closeBtn.hidden = NO;
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
