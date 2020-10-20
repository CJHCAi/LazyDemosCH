//
//  BackScrollAndDetailView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscAndNameView.h"

#define GapOfView 15
#define ScrollContentHeight 1150
#define FirstViewFrameOfheight 315+GapOfView

@class BackScrollAndDetailView;
@protocol BackScrollAndDetailViewDelegate <NSObject>

-(void)BackScrollAndDetailViewDidTapCreateButton;

@end

@interface BackScrollAndDetailView : UIView<UITextFieldDelegate,InputViewDelegate>

{
    UIImagePickerController *_imagePickerController;
    BOOL _inputViewDown;//判断是否结婚的位置
}

@property (nonatomic,strong) InputView *inputView; /*是否结婚*/

@property (nonatomic,strong) UITextField *parnName; /*配偶名*/

@property (nonatomic,strong) UIImageView *selecProtrai; /*选择头像*/

@property (nonatomic,strong) UIScrollView *backView; /*滚动背景*/

@property (nonatomic,strong) UIView *whiteBack; /*半透明背景*/

@property (nonatomic,strong) UIButton *createBtn; /*创建按钮*/

//配偶
@property (nonatomic,strong) InputView *birthLabel; /*生辰年*/

@property (nonatomic,strong) InputView *monthLabel; /*月*/

@property (nonatomic,strong) InputView *dayLabel; /*日*/

@property (nonatomic,strong) InputView *birtime; /*出生时间段*/

@property (nonatomic,strong) InputView *liveNowLabel; /*是否健在*/

//个人年月日
@property (nonatomic,strong) InputView *selfYear;
@property (nonatomic,strong) InputView *selfMonth;
@property (nonatomic,strong) InputView *selfDay;

@property (nonatomic,strong) InputView *generationLabel; /*字辈*/

@property (nonatomic,strong) UITextField *gennerationNex; /*字辈后面那块*/

@property (nonatomic,strong) UITextView *selfTextView; /*个人简介*/

@property (nonatomic,strong) UIButton *uploadImageBtn; /*上传图片*/

@property (nonatomic,strong) UIButton *uploadVideoBtn; /*上传影音资料*/

@property (nonatomic,strong) UITextField *moveCity; /*迁移者居住地*/

@property (nonatomic,strong) NSMutableArray *gennerNexArr; /*字辈arr*/

@property (nonatomic,weak) id<BackScrollAndDetailViewDelegate> delegate; /*代理人*/

@property (nonatomic,assign) BOOL zbLegal; /*字辈格式是否合法*/

/**上传的图片*/
@property (nonatomic,strong) UIImage *mutilpleImage;

//创建labelText
-(InputView *)creatLabelTextWithTitle:(NSString *)title
                           TitleFrame:(CGRect)frame
                      inputViewLength:(NSInteger)length
                              dataArr:(NSArray *)dataArr
                       inputViewLabel:(NSString *)labelText
                              FinText:(NSString *)finStr
                             withStar:(BOOL)star;


@end
