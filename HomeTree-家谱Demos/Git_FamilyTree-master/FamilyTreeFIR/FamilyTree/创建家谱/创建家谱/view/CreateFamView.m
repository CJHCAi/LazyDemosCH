//
//  CreateFamView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/2.
//  Copyright © 2016年 王子豪. All rights reserved.
//

typedef enum : NSUInteger {
    SelectedFamTotem,
    SelectFamHeadView,
    SelectMultipleBtn,
    
} ImagePickType;

#import "CreateFamView.h"

@interface CreateFamView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DiscAndNameViewDelegate>

@property (nonatomic,assign) ImagePickType pickType; /*区别图片选择器选择的图片*/

@end

@implementation CreateFamView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initCreatUI];
    }
    return self;
}


#pragma mark *** 初始化界面 ***
-(void)initCreatUI{
    
    [self.backView addSubview:self.famousPerson];
    [self.backView addSubview:self.famName];
    [self.backView addSubview:self.famfarName];

    NSMutableArray *allGenNum = [@[] mutableCopy];
    
    for (int idx = 1; idx<100; idx++) {
        NSString *str = [NSString stringWithFormat:@"第%d代",idx];
        [allGenNum addObject:str];
    }
    
    self.gennerNum = [self creatLabelTextWithTitle:@"祖宗是家族第几代:" TitleFrame:CGRectMake(20, CGRectYH(self.famfarName)+GapOfView, 0.4*Screen_width, InputView_height) inputViewLength:0.2*Screen_width dataArr:allGenNum inputViewLabel:@"第1代" FinText:nil withStar:YES];
    
    [self.backView addSubview:self.gennerNum];
    
    [self.backView addSubview:self.famBookName];
    
    self.famBookName.sd_layout.leftSpaceToView(self.backView,20).topSpaceToView(self.famName,GapOfView*3+2*InputView_height).heightIs(InputView_height).rightSpaceToView(self.backView,20);
    
    [self.backView addSubview:self.sexInpuView];
    
    [self.backView addSubview:self.diXiView];
    
    [self.backView bringSubviewToFront:self.gennerNum];
    
    [self.backView addSubview:self.famTotem];
    
}

#pragma mark *** Events ***
-(void)respondsToSelectHeadImage:(id)sender{
    
    if ([sender class] == [UITapGestureRecognizer class]) {
        NSLog(@"ges");
        _pickType = SelectedFamTotem;
        
    }
    if ([sender class] == [UIButton class]) {
        UIButton *btn = sender;
        if ([btn.titleLabel.text isEqualToString:@"选择头像"]) {
            _pickType = SelectFamHeadView;
        }
        if (!btn.titleLabel.text) {
            NSLog(@"上传多图");
             _pickType = SelectMultipleBtn;
        }
       
        
    }
    

    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.mediaTypes = @[mediaTypes[0]];
        _imagePickerController.allowsEditing = YES;

        [[self viewController] presentViewController:_imagePickerController animated:YES completion:nil];
        
    }
    
}


#pragma mark *** DiscAndNameViewDelegate ***
-(void)DiscAndNameView:(DiscAndNameView *)view didFinishEditDetailLabel:(UITextField *)detailLabel{
    if ([detailLabel.text isEqualToString:@""]) {
        return;
    }
    self.famBookName.text = [NSString stringWithFormat:@"%@1-5代卷谱",detailLabel.text] ;
}
#pragma mark *** UIImagePickerControllerDelegate ***

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
        
    if (_pickType == SelectedFamTotem) {
        self.famTotem.image = info[UIImagePickerControllerEditedImage];
    }else if (_pickType == SelectFamHeadView){
        self.selecProtrai.image = info[UIImagePickerControllerEditedImage];
    }else{
        //上传图片
        self.mutilpleImage = info[UIImagePickerControllerEditedImage];
    }
    
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark *** getters ***
-(DiscAndNameView *)famName{
    if (!_famName) {
        _famName = [[DiscAndNameView alloc] initWithFrame:CGRectMake(20,40+GapOfView, 0.6*Screen_width+10, InputView_height) title:@"家谱名称:" detailCont:@"" isStar:YES];
    }
    return _famName;
}

-(DiscAndNameView *)famfarName{
    if (!_famfarName) {
        _famfarName = [[DiscAndNameView alloc] initWithFrame:CGRectMake(20, CGRectYH(self.famName)+GapOfView, self.famName.bounds.size.width, InputView_height) title:@"祖宗姓名（字）:" detailCont:@"" isStar:true];
        _famfarName.delegate = self;
        
    }
    return _famfarName;
}

-(UITextField *)famBookName{
    if (!_famBookName) {
        _famBookName = [UITextField new];
        _famBookName.placeholder = @"首卷家谱名称";
        _famBookName.font = WFont(35);
        [_famBookName setTextColor:[UIColor blackColor] ];
        _famBookName.backgroundColor = [UIColor whiteColor];
        _famBookName.layer.borderColor = BorderColor;
        _famBookName.layer.borderWidth = 1.0f;
        _famBookName.textAlignment = 1;
        [_famBookName setEnabled:false];
        
    }
    return _famBookName;
}
-(InputView *)sexInpuView{
    if (!_sexInpuView) {
        _sexInpuView = [[InputView alloc] initWithFrame:CGRectMake(20, CGRectYH(self.famfarName)+GapOfView*3+InputView_height*2, 50, InputView_height) Length:50 withData:@[@"男",@"女"]];
        _sexInpuView.inputLabel.text = @"男";
        _sexInpuView.userInteractionEnabled = false;
        
    }
    return _sexInpuView;
}
-(ClickRoundView *)diXiView{
    if (!_diXiView) {
        _diXiView = [[ClickRoundView alloc] initWithFrame:CGRectMake(CGRectXW(self.sexInpuView)+0.1*Screen_width-20, self.sexInpuView.frame.origin.y, 50, InputView_height) withTitle:@"嫡系" isStar:false];
    }
    return _diXiView;
}
-(ClickRoundView *)famousPerson{
    if (!_famousPerson) {
        _famousPerson = [[ClickRoundView alloc] initWithFrame:CGRectMake(CGRectXW(self.diXiView)+0.1*Screen_width, self.diXiView.frame.origin.y, 60, 40) withTitle:@"家族名人" isStar:YES];
    }
    return _famousPerson;
}

-(UIImageView *)famTotem{
    if (!_famTotem) {
        _famTotem = [[UIImageView alloc] initWithFrame:AdaptationFrame(540, 67, 127, 327)];
        _famTotem.backgroundColor = [UIColor grayColor];
        _famTotem.userInteractionEnabled = true;
        UITapGestureRecognizer *tapGess = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSelectHeadImage:)];
        [_famTotem addGestureRecognizer:tapGess];
        
        [self.uploadImageBtn removeAllTargets];
        [self.uploadImageBtn addTarget:self action:@selector(respondsToSelectHeadImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _famTotem;
}



@end
