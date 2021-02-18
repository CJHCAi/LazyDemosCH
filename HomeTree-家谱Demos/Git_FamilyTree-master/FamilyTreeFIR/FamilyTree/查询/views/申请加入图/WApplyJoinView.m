//
//  WApplyJoinView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/14.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WApplyJoinView.h"
@interface WApplyJoinView()<UITextFieldDelegate>
{
    /** 是否点击了父亲生日 */
    BOOL _clickedFatherBirthView;
}
/**填写背景图*/
@property (nonatomic,strong) UIImageView *backImageView;
/**姓名*/
@property (nonatomic,strong) UITextField *nameTF;
/**字辈*/
@property (nonatomic,strong) UITextField *zbTF;
/**代数*/
@property (nonatomic,strong) UITextField *genNumTF;
/**父亲*/
@property (nonatomic,strong) UITextField *fatherTF;

/**父亲生日*/
@property (nonatomic,strong) UIButton *fatherBirthBtn;

/**生日选择器*/
@property (nonatomic,strong) UIDatePicker *birthDatePicker;


@end
@implementation WApplyJoinView
- (instancetype)initWithFrame:(CGRect)frame checkType:(WApplyJoinViewNeedCheckType)checktype
{
    self = [super initWithFrame:frame];
    if (self) {
        self.checkType = checktype;
        [self addSubview:self.backImageView];
        [self initFiveItem];
        [self initApplyAndCancelBtn];
        
    }
    return self;
}
/** 初始化5个控件 */
-(void)initFiveItem{
    NSArray *titleArr = @[@"姓名：",@"字辈：",@"代数：",@"父亲：",@"父亲生日："];

    [titleArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:AdaptationFrame(30, 145+idx*75, 195, 50)];
        label.textAlignment = 2;
        label.font = WFont(35);
        label.text = obj;
        [self.backImageView addSubview:label];
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectXW(label)+5, CGRectY(label), 351*AdaptationWidth(), 50*AdaptationWidth())];
        textField.font = WFont(35);
        textField.layer.borderColor = BorderColor;
        textField.layer.borderWidth = 1.0f;
        textField.placeholder = @"必填";
        textField.text = @"";
        if (idx==2) {
            textField.placeholder = @"选填";
        }
        [self.backImageView addSubview:textField];
        if (idx == 0) {
            self.nameTF = textField;
        }else if(idx==1){
            self.zbTF = textField;
        }else if(idx==2){
            self.genNumTF = textField;
            self.genNumTF.delegate = self;
        }else if(idx==3){
            self.fatherTF = textField;
        }else {
            
            [textField removeFromSuperview];
            self.fatherBirthBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectXW(label)+5, CGRectY(label), 351*AdaptationWidth(), 50*AdaptationWidth())];
            self.fatherBirthBtn.titleLabel.font = WFont(35);
            self.fatherBirthBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.fatherBirthBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -155*AdaptationWidth(), 0, 0);
            self.fatherBirthBtn.layer.borderColor = BorderColor;
            self.fatherBirthBtn.layer.borderWidth = 1.0f;
            [self.fatherBirthBtn setTitle:@"必填" forState:UIControlStateNormal];
            [self.fatherBirthBtn setTitleColor:LH_RGBCOLOR(215, 215, 215) forState:UIControlStateNormal];
            [self.fatherBirthBtn addTarget:self action:@selector(respondsFatherBirTFTapGues) forControlEvents:UIControlEventTouchUpInside];
            [self.backImageView addSubview:self.fatherBirthBtn];
        }
  
    }];
    
}
/** 初始化申请和退出按钮 */
-(void)initApplyAndCancelBtn{
    NSArray *title = @[@"申请",@"退出"];
    NSArray *colorArr = @[LH_RGBCOLOR(227, 0, 36),LH_RGBCOLOR(75, 88, 91)];
    
    [title enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc] initWithFrame:AdaptationFrame(126+230*idx, 550, 160, 67)];
        [btn setTitle:title[idx] forState:0];
        btn.backgroundColor = colorArr[idx];
        [btn addTarget:self action:@selector(respondsToApplyAndCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:btn];
    }];
}
#pragma mark *** events ***
/** 点击父亲生日 */
-(void)respondsFatherBirTFTapGues{
   
    MYLog(@"点击了父亲生日");
    if (!_clickedFatherBirthView) {
        self.birthDatePicker.frame = AdaptationFrame(0, 1010, Screen_width/AdaptationWidth(), 350);
        [self addSubview:self.birthDatePicker];
        if ([self.fatherBirthBtn.currentTitle isEqualToString:@""]) {
            [self.fatherBirthBtn setTitle:@"1990-01-01" forState:UIControlStateNormal];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.backImageView.frame = AdaptationFrame(30, 0, 660, 720);
            self.birthDatePicker.frame = AdaptationFrame(0, self.backImageView.bounds.size.height/AdaptationWidth(), Screen_width/AdaptationWidth(), 350);
        }];
        _clickedFatherBirthView = true;
    }
    
    

}
/** 点击申请和退出 */
-(void)respondsToApplyAndCancelBtn:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"申请"]) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backImageView.frame = AdaptationFrame(30, 150, 660, 720);
            self.birthDatePicker.frame = AdaptationFrame(0, 1010, Screen_width/AdaptationWidth(), 350);
            [self.birthDatePicker removeFromSuperview];
            _clickedFatherBirthView = false;
        } completion:^(BOOL finished) {
            if ([self.nameTF.text isEqualToString:@""]) {
                [SXLoadingView showAlertHUD:@"姓名为空！" duration:0.5];
                return;
            }
            if ([self.zbTF.text isEqualToString:@""]) {
                [SXLoadingView showAlertHUD:@"字辈为空！" duration:0.5];
                return;
            }
            if ([self.fatherTF.text isEqualToString:@""]) {
                [SXLoadingView showAlertHUD:@"父亲为空！" duration:0.5];
                return;
            }
            if ([self.fatherBirthBtn.currentTitle isEqualToString:@""]) {
                [SXLoadingView showAlertHUD:@"父亲生日为空！" duration:0.5];
                return;
            }
            NSArray *arr = @[self.nameTF.text,
                             self.zbTF.text,
                             self.genNumTF.text,
                             self.fatherTF.text,
                             self.fatherBirthBtn.currentTitle];
            
            [self joinJPWithDataArr:arr whileComplete:^(BOOL apply) {
                if (apply) {
                    [SXLoadingView showAlertHUD:@"已申请，请耐心等待" duration:1.0];
                    
                    [self removeFromSuperview];
                }
            }];
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.backImageView.frame = AdaptationFrame(30, 150, 660, 720);
            [self.birthDatePicker removeFromSuperview];
            _clickedFatherBirthView = false;

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            
        }];

       
    }
}
/** pickerEvents */
-(void)updateBirthDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [self.fatherBirthBtn setTitle:[formatter stringFromDate:self.birthDatePicker.date] forState:UIControlStateNormal];
}
#pragma mark *** 网络请求 ***

-(void)joinJPWithDataArr:(NSArray *)dataArr whileComplete:(void (^)(BOOL apply))back{
    if (self.checkType == WApplyJoinViewNeedCheck) {
        [TCJPHTTPRequestManager POSTWithParameters:@{@"geid":[WSearchModel shardSearchModel].selectedFamilyID,
                                                     @"name":dataArr[0],
                                                     @"father":dataArr[3],
                                                     @"zb":dataArr[1],
                                                     @"ds":dataArr[2],
                                                     @"sr":dataArr[4]
                                                     } requestID:GetUserId requestcode:kRequestCodeapplyjoingen success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                         if (succe) {
                                                             back(true);
                                                         }else{
                                                             [SXLoadingView showAlertHUD:jsonDic[@"message"] duration:0.5];
                                                         }
                                                     } failure:^(NSError *error) {
                                                         back(false);
                                                     }];
    }else{
        [TCJPHTTPRequestManager POSTWithParameters:@{@"geid":[WFamilyModel shareWFamilModel].myFamilyId,
                                                    @"name":dataArr[0],
                                                    @"father":dataArr[3],
                                                    @"zb":dataArr[1],
                                                    @"ds":dataArr[2],
                                                    @"sr":dataArr[4]
                                                    } requestID:GetUserId requestcode:kRequestCodejoingen success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                        if (succe) {
                                                            back(true);
                                                        }else{
                                                            if ([jsonDic[@"message"] isEqualToString:@"系统错误"]) {
                                                                [SXLoadingView showAlertHUD:@"信息填写有误！" duration:0.5];
                                                            }
                                                            
                                                        }
                                                    } failure:^(NSError *error) {
                                                        back(false);
                                                    }];
    }
    
    
}

#pragma  mark - UITextFieldDelegate
//金额跟电话限制为数字输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.genNumTF]) {
        return [NSString validateNumber:string];
    }else{
        return YES;
    }
}


#pragma mark *** getters ***
-(UIImageView *)backImageView{
    if (!_backImageView) {
        //半黑色透明
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6;
        [self addSubview:backView];
        
        _backImageView = [[UIImageView alloc] initWithFrame:AdaptationFrame(30, 150, 660, 720)];
        _backImageView.image = MImage(@"txxx_bg");
        _backImageView.userInteractionEnabled = true;
        UILabel *label = [[UILabel alloc] initWithFrame:AdaptationFrame(96, 72, 530, 50)];
        label.font = WFont(35);
        label.text = @"请填写相关验证信息：";
        label.textAlignment = 0;
        [_backImageView addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [self endEditing:YES];
        }];
        [_backImageView addGestureRecognizer:tap];
    }
    return _backImageView;
}
-(UIDatePicker *)birthDatePicker{
    if (!_birthDatePicker) {
        _birthDatePicker = [[UIDatePicker alloc] initWithFrame:AdaptationFrame(0, self.backImageView.bounds.size.height/AdaptationWidth(), Screen_width/AdaptationWidth(), 350)];
        _birthDatePicker.datePickerMode = UIDatePickerModeDate;
        
        [_birthDatePicker addTarget:self action:@selector(updateBirthDate) forControlEvents:UIControlEventValueChanged];
        _birthDatePicker.backgroundColor = [UIColor whiteColor];
        _birthDatePicker.date = [NSDate dateWithString:@"1990-01-01" format:@"yyyy-MM-dd"];
        
    }
    return _birthDatePicker;
}
@end
