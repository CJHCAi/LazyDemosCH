
//
//  CreateCemViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/14.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CreateCemViewController.h"
#import "CemeteryModel.h"

@interface CreateCemViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic,strong) UIScrollView *backScroView; /*背景滚动*/

@property (nonatomic,strong) UIButton *addCemBtn; /*添加墓园照片*/


@property (nonatomic,strong) UITextField *cemName; /*墓园名称*/
@property (nonatomic,strong) UITextField *cemMaster; /*墓主人*/
/** 称谓*/
@property (nonatomic, strong) UITextField *cemTitle;
@property (nonatomic,strong) UITextField *cemSaying; /*墓志铭*/
@property (nonatomic,strong) UIButton *cemBir; /*生辰*/
/** 忌日*/
@property (nonatomic, strong) UIButton *cemDead;
/** 生平简介*/
@property (nonatomic,strong) UITextView *cemInfoTV;
/** 生辰日期选择器*/
@property (nonatomic, strong) UIDatePicker *birDatePicker;
/** 忌日日期选择器*/
@property (nonatomic, strong) UIDatePicker *deadDatePicker;
@end

@implementation CreateCemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MYLog(@"%ld",(long)self.CeId);
    [self initData];
    [self initUI];
}
#pragma mark *** 初始化数据 ***
-(void)initData{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self.view addSubview:self.backScroView];
    [self addCemImage];
    [self addFiveLabelTextView];
    [self createCemBtn];
    //如果是修改墓园，显示信息
    if (!self.creatOrEditStr) {
        [self getCemeteryData];
    }
}

//添加墓园照片
-(void)addCemImage{
    
    UIView *whiteView = [[UIView alloc] initWithFrame:AdaptationFrame(0, 0, Screen_width/AdaptationWidth(), 375)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.backScroView addSubview:whiteView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:AdaptationFrame(269, 70, 178, 178)];
    [btn setImage:MImage(@"xinJianMuYuan_add") forState:0];
    [btn addTarget:self action:@selector(respondsToAddCemImage:) forControlEvents:UIControlEventTouchUpInside];
    self.addCemBtn = btn;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectX(btn), CGRectYH(btn)+20*AdaptationWidth(), btn.bounds.size.width, 40*AdaptationWidth())];
    if (self.creatOrEditStr) {
        label.text = @"添加墓园照片";
    }else{
        label.text = @"修改墓园照片";
    }
    
    label.textAlignment = 1;
    label.font = MFont(28*AdaptationWidth());
    
    [self.backScroView addSubview:btn];
    [self.backScroView addSubview:label];
    
}
//添加5个控件 墓园名称--生平简介
-(void)addFiveLabelTextView{
    UIView *whiteView = [[UIView alloc] initWithFrame:AdaptationFrame(0, 390, Screen_width/AdaptationWidth(), 660)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.backScroView addSubview:whiteView];
    
    NSArray *titleArr = @[@"墓园名称：",@"墓主人：",@"称谓：",@"墓志铭：",@"生辰忌日：",@"生平简介："];
    
    self.cemName = [self createLabelAndTextViewWithFrame:AdaptationFrame(74, 40, 130, 50) title:titleArr[0] toView:whiteView];
    //self.cemName.text = @"";
    self.cemMaster = [self createLabelAndTextViewWithFrame:AdaptationFrame(74, 40+1*75, 130, 50) title:titleArr[1] toView:whiteView];
    //self.cemMaster.text = @"";
    self.cemTitle = [self createLabelAndTextViewWithFrame:AdaptationFrame(74, 40+2*75, 130, 50) title:titleArr[2] toView:whiteView];
    //self.cemTitle.text = @"";
    self.cemSaying = [self createLabelAndTextViewWithFrame:AdaptationFrame(74, 40+3*75, 130, 50) title:titleArr[3] toView:whiteView];
    //self.cemSaying.text = @"";
    //生辰忌日
    UILabel *birDeadLabel = [[UILabel alloc]initWithFrame:AdaptationFrame(74, 40+4*75, 130, 50)];
    birDeadLabel.text = titleArr[4];
    birDeadLabel.textAlignment = NSTextAlignmentRight;
    birDeadLabel.font = MFont(25*AdaptationWidth());
    [whiteView addSubview:birDeadLabel];

    self.cemBir = [[UIButton alloc]initWithFrame:CGRectMake(CGRectXW(birDeadLabel), (40+4*75)*AdaptationWidth(), 170*AdaptationWidth(), 50*AdaptationWidth())];
    self.cemBir.layer.borderColor = BorderColor;
    [self.cemBir setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cemBir setTitle:@"" forState:UIControlStateNormal];
    self.cemBir.layer.borderWidth = 1.0f;
    self.cemBir.titleLabel.font = MFont(12);
    self.cemBir.userInteractionEnabled = YES;
    [self.cemBir addTarget:self action:@selector(clickToSelectBirTime:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.cemBir];
    
    self.cemDead = [[UIButton alloc]initWithFrame:CGRectMake(CGRectXW(self.cemBir)+10*AdaptationWidth(), (40+4*75)*AdaptationWidth(), 170*AdaptationWidth(), 50*AdaptationWidth())];
    [self.cemDead setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cemDead setTitle:@"" forState:UIControlStateNormal];
    self.cemDead.layer.borderColor = BorderColor;
    self.cemDead.layer.borderWidth = 1.0f;
    self.cemDead.titleLabel.font = MFont(12);
    [self.cemDead addTarget:self action:@selector(clickToSelectDeadTime:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.cemDead];
    //生平简介
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:AdaptationFrame(74, 40+5*75, 130, 50)];
    infoLabel.text = titleArr[5];
    infoLabel.textAlignment = NSTextAlignmentRight;
    infoLabel.font = MFont(25*AdaptationWidth());
    [whiteView addSubview:infoLabel];
    
    self.cemInfoTV = [[UITextView alloc]initWithFrame:CGRectMake(CGRectXW(infoLabel), (40+5*75)*AdaptationWidth(), 350*AdaptationWidth(), 240*AdaptationWidth())];
    self.cemInfoTV.text = @"";
    self.cemInfoTV.layer.borderColor = BorderColor;
    self.cemInfoTV.layer.borderWidth = 1;
    self.cemInfoTV.delegate = self;
    [whiteView addSubview:self.cemInfoTV];
}

-(void)createCemBtn{
    //创建btn
    UIButton *createCemBtn = [[UIButton alloc] initWithFrame:AdaptationFrame(25, 854+220, 675, 90)];
    createCemBtn.backgroundColor = LH_RGBCOLOR(74, 88, 91);
    createCemBtn.layer.cornerRadius = 3;
    if (self.creatOrEditStr) {
        [createCemBtn setTitle:@"建园" forState:0];
    }else{
        [createCemBtn setTitle:@"确认修改" forState:0];
    }
    
    [createCemBtn addTarget:self action:@selector(respondsToCreateCemBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backScroView addSubview:createCemBtn];
    
}


#pragma mark *** events ***
//修改墓园把信息显示出来   
-(void)getCemeteryData{
    NSDictionary *logDic = @{@"CeId":@(self.CeId)};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeCemeterDetail success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            CemeteryModel *cemeteryModel = [CemeteryModel modelWithJSON:jsonDic[@"data"]];
            weakSelf.cemName.text = cemeteryModel.CeName;
            weakSelf.cemMaster.text = cemeteryModel.CeMaster;
            weakSelf.cemTitle.text = cemeteryModel.CeTitle;
            weakSelf.cemSaying.text = cemeteryModel.CeEpitaph;
            [weakSelf.cemBir setTitle:[cemeteryModel.CeScjr substringToIndex:10] forState:UIControlStateNormal];
            [weakSelf.cemDead setTitle:[cemeteryModel.CeScjr substringFromIndex:14] forState:UIControlStateNormal];
            weakSelf.cemInfoTV.text = cemeteryModel.CeBrief;
            [weakSelf.addCemBtn setBackgroundImageWithURL:[NSURL URLWithString:cemeteryModel.CePhoto] forState:UIControlStateNormal placeholder:MImage(@"xinJianMuYuan_add")];
        }
    } failure:^(NSError *error) {
        
    }];
}



-(void)respondsToCreateCemBtn:(UIButton *)sender{
    if (self.creatOrEditStr) {
        if (!IsNilString(self.cemName.text)) {
            NSDictionary *dic = @{@"CeName":self.cemName.text,
                                  @"CeMaster":self.cemMaster.text,
                                  @"CeEpitaph":self.cemSaying.text,
                                  @"CeDeathday":self.cemDead.currentTitle,
                                  @"CeBrief":self.cemInfoTV.text,
                                  @"CeType":@"PRI",
                                  @"CeMeid":GetUserId,
                                  @"CeBrithday":self.cemBir.currentTitle,
                                  @"CeTitle":self.cemTitle.text
                                  };
            WK(weakSelf)
            [TCJPHTTPRequestManager POSTWithParameters:dic requestID:GetUserId requestcode:kRequestCodecreatecemetery success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                weakSelf.tabBarController.tabBar.hidden = NO;
                if (succe) {
                    NSDictionary *dic = [NSDictionary DicWithString:jsonDic[@"data"]];
                    MYLog(@"%@", dic[@"CeId"]);
                    if (![weakSelf.addCemBtn.imageView.image isEqual:MImage(@"xinJianMuYuan_add")]) {
                       [weakSelf uploadWorshipImageWithID:[dic[@"CeId"] intValue]];
                    }
                    
                    [SXLoadingView showAlertHUD:@"创建成功" duration:0.5];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSError *error) {
                MYLog(@"失败");
            }];

        }else{
            [SXLoadingView showAlertHUD:@"请至少填写墓园名字" duration:0.5];
        }
        
    }
    
    else{
        //修改墓园信息
        if (!IsNilString(self.cemName.text)) {
        NSDictionary *dic = @{@"CeName":self.cemName.text,
                              @"CeMaster":self.cemMaster.text,
                              @"CeEpitaph":self.cemSaying.text,
                              @"CeDeathday":self.cemDead.currentTitle,
                              @"CeBrief":self.cemInfoTV.text,
                              @"CeId":@(self.CeId),
                              @"CeBrithday":self.cemBir.currentTitle,
                              @"CeTitle":self.cemTitle.text
                              };
        WK(weakSelf)
        [TCJPHTTPRequestManager POSTWithParameters:dic requestID:GetUserId requestcode:kRequestCodeEditCemetery success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            self.tabBarController.tabBar.hidden = NO;
            if (succe) {
                
                [weakSelf uploadWorshipImageWithID:self.CeId];
                
                [SXLoadingView showAlertHUD:@"修改成功" duration:0.5];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            MYLog(@"失败");
        }];
        }else{
            [SXLoadingView showAlertHUD:@"请至少填写墓园名字" duration:0.5];
        }
        
    }
}

//上传or修改墓园图片
-(void)uploadWorshipImageWithID:(NSInteger)CeId{
    UIImage *cemeteryImage = self.addCemBtn.imageView.image;
    NSData *imageData = UIImageJPEGRepresentation(cemeteryImage, 0.5);
    NSString *encodeimageStr =[imageData base64EncodedString];
    NSDictionary *params =@{@"userid":GetUserId,@"imgbt":encodeimageStr,@"uploadtype":@"ZP",@"ceid":@(CeId)};
    [TCJPHTTPRequestManager POSTWithParameters:params requestID:GetUserId requestcode:kRequestCodeUploadCefm success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            MYLog(@"墓园图片上传成功%@", jsonDic[@"data"]);
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)respondsToAddCemImage:(UIButton *)sender{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        _imagePickerController.mediaTypes = @[mediaTypes[0]];
        _imagePickerController.allowsEditing = YES;
        
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
}
#pragma mark *** UIImagePickerControllerDelegate ***

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self.addCemBtn setImage:info[UIImagePickerControllerEditedImage] forState:0];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//创建label+边框textView
-(UITextField *)createLabelAndTextViewWithFrame:(CGRect)frame title:(NSString *)title toView:(UIView *)backView{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentRight;
    label.text = title;
    label.font = MFont(25*AdaptationWidth());
    [backView addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectXW(label), frame.origin.y, 350*AdaptationWidth(), 50*AdaptationWidth())];
    textField.layer.borderColor = BorderColor;
    textField.layer.borderWidth = 1.0f;
    textField.font = MFont(14);
    textField.text = @"";
    textField.delegate = self;
    [backView addSubview:textField];
    return textField;
}

#pragma mark - lazyLoad
-(UIScrollView *)backScroView{
    if (!_backScroView) {
        _backScroView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
        _backScroView.backgroundColor = LH_RGBCOLOR(236, 236, 236);
        _backScroView.contentSize = CGSizeMake(Screen_width, 700);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
        [_backScroView addGestureRecognizer:tap];
    }
    return _backScroView;
}


//关键盘
-(void)closeKeyboard{
    [self.birDatePicker removeFromSuperview];
    [self.deadDatePicker removeFromSuperview];
    [self.cemName resignFirstResponder];
    [self.cemMaster resignFirstResponder];
    [self.cemSaying resignFirstResponder];
    [self.cemInfoTV resignFirstResponder];
    self.tabBarController.tabBar.hidden = NO;
    self.cemBir.userInteractionEnabled = YES;
    self.cemDead.userInteractionEnabled = YES;
}

-(void)clickToSelectBirTime:(UIButton *)sender{
    self.tabBarController.tabBar.hidden = YES;
    self.cemBir.userInteractionEnabled = NO;
    
    [self.cemName resignFirstResponder];
    [self.cemMaster resignFirstResponder];
    [self.cemSaying resignFirstResponder];
    [self.cemInfoTV resignFirstResponder];
    
    self.birDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0.7*Screen_height, Screen_width, 0.3*Screen_height)];
    self.birDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.birDatePicker addTarget:self action:@selector(changeBirTime:) forControlEvents:UIControlEventValueChanged];
    self.birDatePicker.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.birDatePicker];
}

-(void)clickToSelectDeadTime:(UIButton *)sender{
    self.tabBarController.tabBar.hidden = YES;
    self.cemBir.userInteractionEnabled = NO;
    [self.cemName resignFirstResponder];
    [self.cemMaster resignFirstResponder];
    [self.cemSaying resignFirstResponder];
    [self.cemInfoTV resignFirstResponder];
    self.deadDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0.7*Screen_height, Screen_width, 0.3*Screen_height)];
    self.deadDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.deadDatePicker addTarget:self action:@selector(changeDeadTime:) forControlEvents:UIControlEventValueChanged];
    self.deadDatePicker.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.deadDatePicker];
}


//弹键盘
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    MYLog(@"将要开始编辑");
    if (self.backScroView.frame.origin.y == 64) {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame =  self.backScroView.frame;
            frame.origin.y = 64-216+20;
            self.backScroView.frame = frame;
        }];
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.backScroView.frame.origin.y !=64) {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame =  self.backScroView.frame;
            frame.origin.y = 64;
            self.backScroView.frame = frame;
        }];
    }

}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    MYLog(@"将要开始编辑");
    if (self.backScroView.frame.origin.y == 64) {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame =  self.backScroView.frame;
            frame.origin.y = 64-216+20;
            self.backScroView.frame = frame;
        }];
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    MYLog(@"结束编辑");
    if (self.backScroView.frame.origin.y !=64) {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame =  self.backScroView.frame;
            frame.origin.y = 64;
            self.backScroView.frame = frame;
        }];
    }
}


-(void)changeBirTime:(UIDatePicker *)datePicker{
    NSDate *pickerDate = [datePicker date];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    [self.cemBir setTitle:[pickerFormatter stringFromDate:pickerDate] forState:UIControlStateNormal];
}

-(void)changeDeadTime:(UIDatePicker *)datePicker{
    NSDate *pickerDate = [datePicker date];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    [self.cemDead setTitle:[pickerFormatter stringFromDate:pickerDate] forState:UIControlStateNormal];
}

@end
