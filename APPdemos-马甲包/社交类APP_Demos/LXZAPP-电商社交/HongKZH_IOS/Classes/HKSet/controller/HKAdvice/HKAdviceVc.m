//
//  HKAdviceVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAdviceVc.h"
#import "HK_PickerCell.h"
#import "HK_BaseRequest.h"
#import "HK_NetWork.h"
#import "HKDateTool.h"
#import "ImageUtil.h"
@interface HKAdviceVc ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UIView *commitView;
@property (nonatomic, strong)UIView *photoView;
@property (nonatomic, strong)UIButton *subMitBtn;
@property (nonatomic, strong)UITextView *textView;
/** collectionV*/
@property(nonatomic,strong)UICollectionView * collectionView;
/** 图片数组*/
@property(nonatomic,strong)NSMutableArray *pickerImageArr;
@end
@implementation HKAdviceVc

/** 文本输入框*/
-(UIView *)commitView {
    if (!_commitView) {
        _commitView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,200)];
        _commitView.backgroundColor =[UIColor whiteColor];
        UITextView * textV =[[UITextView alloc] initWithFrame:CGRectMake(15,15,kScreenWidth-30,180)];
        textV.backgroundColor =[UIColor clearColor];
        textV.returnKeyType =UIReturnKeyDone;
        textV.delegate =self;
        UILabel *placeHolderLabel=[[UILabel alloc] init];
        placeHolderLabel.text =@"写下乐小转的功能建议或发现的系统问题,么么哒!";
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
        _photoView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.commitView.frame)+10,kScreenWidth,150)];
        _photoView.backgroundColor =[UIColor whiteColor];
        UILabel * tipsOne=[[UILabel alloc] initWithFrame:CGRectMake(15,15,300,10)];
        [AppUtils getConfigueLabel:tipsOne font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(102,102,102) text:@"添加图片证据"];
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
        [AppUtils getButton:_subMitBtn font:PingFangSCRegular16 titleColor:[UIColor whiteColor] title:@"提交反馈"];
        _subMitBtn.frame =CGRectMake(30,kScreenHeight-StatusBarHeight-NavBarHeight-30-49-SafeAreaBottomHeight,kScreenWidth-60,49);
        _subMitBtn.layer.cornerRadius =5;
        _subMitBtn.layer.masksToBounds = YES;
        _subMitBtn.enabled = NO;
        _subMitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        [_subMitBtn addTarget:self action:@selector(subComplains) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subMitBtn;
}
#pragma mark 提交反馈
-(void)subComplains {
    [Toast loading];
    [HK_NetWork uploadEditImageURL:get_userFeedback parameters:@{kloginUid:HKUSERLOGINID,@"content":self.textView.text} images:self.pickerImageArr name:@"imgs" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:nil specifications:nil progress:^(NSProgress *progress) {
    } callback:^(id responseObject, NSError *error) {
        [Toast loaded];
        if (error) {
            [EasyShowTextView showText:@"提交失败"];
        }else {
            if ([[responseObject objectForKey:@"code"] integerValue]==0) {
                [self.navigationController popViewControllerAnimated:YES];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"意见反馈";
    self.showCustomerLeftItem = YES;
    [self.view addSubview:self.commitView];
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.subMitBtn];

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
