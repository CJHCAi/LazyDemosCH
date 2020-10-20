//
//  SDDecorateFunctionViewController.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDDecorateFunctionViewController.h"
#import "SDDecorateEditImageViewModel.h"

#import "SDDecorateEditPhotoControllerItemsView.h"
#import "SDRevealView.h"

#import "SDDecorateFunctionModel.h"

#import "SDPasterView.h"

#import "AppFileComment.h"

#import "SDTagView.h"

#import "SDInputTagContentView.h"

@interface SDDecorateFunctionViewController ()<SDPasterViewDelegate>

@property (nonatomic, strong) SDDecorateEditImageViewModel * decorateViewModel;

@property (nonatomic, weak) SDDecorateEditPhotoControllerItemsView * decorateView;

@property (nonatomic, weak) SDRevealView * theRevealView;

//@property (nonatomic, weak) SDPasterView * pasterView;

@property (nonatomic, strong) NSMutableArray * pasterViewList;

@property (nonatomic, strong) SDTagView * current_edit_tagView;

@property (nonatomic, weak) SDInputTagContentView * input_tag_content_view;


@end

@implementation SDDecorateFunctionViewController

- (instancetype)initWithFinishBlock:(SDDiyImageFinishBlock)finishBlock
{
    self = [super initWithFinishBlock:finishBlock];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self sd_configView];
    
    [self sd_configData];
    
    [self registeredKeyboardNotification];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sd_configView
{
    [self decorateView];
    
    self.decorateView.frame = (CGRect){{0,SCREENH_HEIGHT - self.decorateView.frame.size.height},self.decorateView.frame.size};
    
    [self theRevealView];
    
    self.theRevealView.revealImage = self.showImageView;
}

- (void)sd_configData
{
    self.decorateViewModel = (SDDecorateEditImageViewModel *)[SDDecorateEditImageViewModel modelViewController:self];
    
    self.decorateView.cancelModel = self.decorateViewModel.cancelModel;
    self.decorateView.sureModel = self.decorateViewModel.sureModel;
    self.decorateView.decorateModel = self.decorateViewModel.decorateModel;
    
    self.decorateView.tagModel = self.decorateViewModel.tagModel;
    
    self.decorateView.decorateList = self.decorateViewModel.decorateList;
    
    
    [self monitorResetFunctionModel];
    
    
}

#pragma mark - done action

- (void)onSureAction
{
    [self.pasterViewList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SDPasterView class]]) {
            SDPasterView * pasterView = obj;
            [pasterView hiddenBtn];
        }else if ([obj isKindOfClass:[SDTagView class]]){
            SDTagView * tagView = obj;
            [tagView hideTagLine];
        }
    }];
    
    UIImage * image = [UIImage makeImageFromShowView:self.theRevealView.theRevealView];
    
    
    if (self.diyFinishBlock) {
        self.diyFinishBlock(image);
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
}

- (void)monitorResetFunctionModel
{
    SDDecorateFunctionModel * resetFunctionModel = [self.decorateViewModel.decorateList firstObject];
    @weakify_self;
    [resetFunctionModel.done_subject subscribeNext:^(id x) {
        @strongify_self;
        
        [self.pasterViewList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView * tagView = obj;
            [tagView removeFromSuperview];
        }];
        
        [self.pasterViewList removeAllObjects];
        
        [self ChangeResetFunctionModel];
        
    }];
}

- (void)ChangeResetFunctionModel
{
    SDDecorateFunctionModel * resetFunctionModel = [self.decorateViewModel.decorateList firstObject];
    
    if (self.pasterViewList.count > 0) {
        resetFunctionModel.isSelected = YES;
    }else{
        resetFunctionModel.isSelected = NO;
    }
    
    
}
//TODO:1. 被通知Controller 添加 贴纸
- (void)addDecorateModelForView:(SDDecorateFunctionModel *)model
{
    NSString * imageLink = model.imageLink;
    
    imageLink = [AppFileComment imagePathStringWithImagename:imageLink];
    
    UIImage * image = [UIImage imageNamed:imageLink];

    SDPasterView * pasterView = [[SDPasterView alloc] initWithFrame:CGRectMake(0, 0, defaultPasterViewW_H, defaultPasterViewW_H)];
    
    
    [self.theRevealView addTargetView:pasterView];
    
    pasterView.center = CGPointMake(self.theRevealView.theRevealView.frame.size.width / 2.f, self.theRevealView.theRevealView.frame.size.height / 2.f);
    pasterView.delegate = self;
    pasterView.pasterImage = image;
    
    NSInteger count = self.pasterViewList.count;
    
    pasterView.index = count + 1;
    
    [self.pasterViewList addObject:pasterView];
    
    [self ChangeResetFunctionModel];
    
}
//TODO: 2. 通知Controller 添加标签
- (void)addTagModelForView:(SDDecorationTagModel)tagModel;
{
    SDTagView * tagView = [[SDTagView alloc] initWithFrame:CGRectMake(0, 0, defaultPasterViewW_H * 2, defaultPasterViewW_H ) DecorationFunction:tagModel];
    tagView.center = CGPointMake(self.theRevealView.theRevealView.frame.size.width / 2.f, self.theRevealView.theRevealView.frame.size.height / 2.f);
    tagView.delegate = self;
    
    [self.theRevealView addTargetView:tagView];
    [self.pasterViewList addObject:tagView];
    [self ChangeResetFunctionModel];
    
}

- (void)swtichToTagController
{
    self.decorateView.decorateList = self.decorateViewModel.tagList;
}
- (void)swtichToDecorateController
{
    self.decorateView.decorateList = self.decorateViewModel.decorateList;
}

- (void)hideInputTagViewWithInput:(BOOL)tag withText:(NSString *)text
{
    [self.input_tag_content_view.inputTextField resignFirstResponder];
    if (tag) {
        self.current_edit_tagView.tag_string = text;
    }
    [self.input_tag_content_view removeFromSuperview];
    
    _input_tag_content_view = nil;
    
}

- (void)showInputTagView:(NSString * )content
{
    self.input_tag_content_view.inputTextField.text = content;
    
    [self.input_tag_content_view.inputTextField becomeFirstResponder];
}

#pragma mark - 检测监听keyboard
- (void)registeredKeyboardNotification{
    NSNotificationCenter *notic=[NSNotificationCenter defaultCenter];
    
    @weakify_self
    [[notic rac_addObserverForName:UIKeyboardDidShowNotification
                            object:nil] subscribeNext:^(NSNotification * notification) {
        NSDictionary * userInfo = [notification userInfo];
        @strongify_self
        CGRect rect = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        [self keyboardWillAppear:rect.size.height];
        
    }];
    
    [[notic rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * notification) {
        @strongify_self;
        [self keyboardDidDisAppear];
    }];
}

#pragma mark - keyboard 显示
- (void)keyboardWillAppear:(CGFloat)height{
    
    CGFloat origin_y = SCREENH_HEIGHT - height - self.input_tag_content_view.frame.size.height;
   

    [UIView animateWithDuration:0.25 animations:^{
        self.input_tag_content_view.frame = (CGRect){{self.input_tag_content_view.frame.origin.x,origin_y},self.input_tag_content_view.frame.size};
    }];
    
    
}
#pragma mark - keyboard 消失
- (void)keyboardDidDisAppear{
    
}


#pragma mark - SDPasterViewDelegate

- (void)deleteThePaster:(UIView *)target
{
    // 删除
    NSInteger index = -1;
    
    index = [self.pasterViewList indexOfObject:target];
    
    if (index != -1) {
        // 根据地址查询的
        [self.pasterViewList removeObjectAtIndex:index];
        [self ChangeResetFunctionModel];
        
    }
}

- (void)SimplpTapForTagContentWithIndex:(NSInteger)index inView:(UIView *)target
{
    if ([target isKindOfClass:[SDTagView class]]) {
        _current_edit_tagView = (SDTagView *)target;
        [self showInputTagView:self.current_edit_tagView.tag_string];
    }
}


#pragma mark - getter

- (SDDecorateEditPhotoControllerItemsView *)decorateView
{
    if (!_decorateView) {
        SDDecorateEditPhotoControllerItemsView * theView = [[SDDecorateEditPhotoControllerItemsView alloc] init];
        [self.view addSubview:theView];
        _decorateView = theView;
    }
    return _decorateView;
}
- (SDRevealView *)theRevealView
{
    if (!_theRevealView) {
        SDRevealView * theView = [[SDRevealView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT - MAXSize(466))];
        [self.view addSubview:theView];
        _theRevealView = theView;
    }
    return _theRevealView;
}

- (SDInputTagContentView *)input_tag_content_view
{
    if (!_input_tag_content_view) {
        SDInputTagContentView * theView = [[SDInputTagContentView alloc] init];
        [theView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:theView];
        _input_tag_content_view = theView;
        
        _input_tag_content_view.doneBlock = ^(NSString *object) {
            if (object == nil) {
                // 取消
                [self hideInputTagViewWithInput:false withText:object];
            }else{
                //确认
                [self hideInputTagViewWithInput:true withText:object];
            }
        };
    }
    return _input_tag_content_view;
}

- (NSMutableArray *)pasterViewList
{
    if (!_pasterViewList) {
        _pasterViewList = [[NSMutableArray alloc] init];
    }
    return _pasterViewList;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
