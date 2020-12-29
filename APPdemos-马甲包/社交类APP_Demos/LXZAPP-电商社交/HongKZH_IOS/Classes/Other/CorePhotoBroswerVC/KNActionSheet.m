//
//  KNActionSheet.m
//  KNActionSheet
//
//  Created by LuKane on 16/9/5.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "KNActionSheet.h"

#ifndef ScreenWidth
    #define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
    #define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

@interface KNActionSheet()

@property (nonatomic, copy) ActionBlock ActionBlock;

@property (nonatomic, copy) DismissBlock DismissBlock;


@end


@implementation KNActionSheet{
    NSString *_cancelBtnTitle;
    NSString *_destructiveBtnTitle;
    NSArray  *_otherBtnTitlesArr;
    
    UIView   *_bgView; // 存放子控件的View
    UIView   *_coverView; // 背景遮盖
}

static id ActionSheet;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!ActionSheet){
            ActionSheet = [super allocWithZone:zone];
        }
    });
    return ActionSheet;
}

- (instancetype)initWithCancelBtnTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherBtnTitlesArr:(NSArray *)otherBtnTitlesArr actionBlock:(ActionBlock)ActionBlock{
    if(self = [super init]){
        _cancelBtnTitle = cancelBtnTitle;
        _destructiveBtnTitle = destructiveBtnTitle;
        
        NSMutableArray *titleArr = [NSMutableArray array];
        if(_destructiveBtnTitle.length){
            [titleArr addObject:_destructiveBtnTitle];
        }
        
        [titleArr addObjectsFromArray:otherBtnTitlesArr];
        _otherBtnTitlesArr = [NSArray arrayWithArray:titleArr];
        _ActionBlock = ActionBlock;
        [self setupSubViews];
    }
    return self;
}


- (instancetype)initWithCancelBtnTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherBtnTitlesArr:(NSArray *)otherBtnTitlesArr actionBlock:(ActionBlock)ActionBlock dismissBlock:(DismissBlock )DismissBlock{
    if(self = [super init]){
        _cancelBtnTitle = cancelBtnTitle;
        _destructiveBtnTitle = destructiveBtnTitle;
        
        NSMutableArray *titleArr = [NSMutableArray array];
        if(_destructiveBtnTitle.length){
            [titleArr addObject:_destructiveBtnTitle];
        }
        
        [titleArr addObjectsFromArray:otherBtnTitlesArr];
        _otherBtnTitlesArr = [NSArray arrayWithArray:titleArr];
        _ActionBlock = ActionBlock;
        _DismissBlock= DismissBlock;
        [self setupSubViews];
    }
    return self;
}

#pragma mark - 初始化 子控件
- (void)setupSubViews{
    [self setFrame:[[UIScreen mainScreen] bounds]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setHidden:YES];
    
    UIView *coverView = [[UIView alloc] initWithFrame:[self bounds]];
    _coverView = coverView;
    [coverView setBackgroundColor:[UIColor colorWithRed:30/255.f green:30/255.f blue:30/255.f alpha:1.f]];
    [coverView setAlpha:0.f];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [self addSubview:coverView];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1.f]];
    _bgView = bgView;
    [self addSubview:bgView];
    
    for (NSInteger i = 0; i < _otherBtnTitlesArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if ([_otherBtnTitlesArr[i] isKindOfClass:[NSMutableAttributedString class]]) {
            [button setAttributedTitle:_otherBtnTitlesArr[i] forState:UIControlStateNormal];
        } else {
            [button setTitle:_otherBtnTitlesArr[i] forState:UIControlStateNormal];
        }
        
        if ((_destructiveBtnTitle.length) && (i==0) && ([_destructiveBtnTitle rangeOfString:@"银行卡"].location !=NSNotFound)) {
            
            button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            button.titleLabel.numberOfLines=0;
            button.titleLabel.textAlignment=1;
//            []
//            [button setTitleColor:[] forState:UIControlStateNormal];

        }else{
            button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }
        
        button.backgroundColor = [UIColor whiteColor];
        

//        if (i==0 && _destructiveBtnTitle.length) {
//            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        }
        
//        UIImage *image = [UIImage imageNamed:@"KNActionSheet.bundle/actionSheetHighLighted.png"];
//        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        
        button.backgroundColor=[UIColor whiteColor];
        
        [button addTarget:self action:@selector(buttonIndexClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonY = 49 * i;
        button.frame = CGRectMake(0, buttonY, ScreenWidth, 49);
        [_bgView addSubview:button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1.f];
        line.frame = CGRectMake(0, buttonY, ScreenWidth, 0.5);
        
        [_bgView addSubview:line];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = _otherBtnTitlesArr.count;
    [cancelButton setTitle:_cancelBtnTitle?_cancelBtnTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    UIImage *image = [UIImage imageNamed:@"KNActionSheet.bundle/actionSheetHighLighted.png"];
//    [cancelButton setBackgroundImage:image forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    CGFloat buttonY = 49 * (_otherBtnTitlesArr.count) + 5;
    cancelButton.frame = CGRectMake(0, buttonY, ScreenWidth, 49);
    [_bgView addSubview:cancelButton];
    
    CGFloat height = 49 * (_otherBtnTitlesArr.count + 1) + 5;
    _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, height);
    
}

- (void)buttonIndexClick:(UIButton *)sender{
    if(_ActionBlock){
        _ActionBlock(sender.tag);
    }
    [self dismiss];
}

- (void)show:(UIWindow *)window
{
    
    [_coverView setAlpha:0];
    [_bgView setTransform:CGAffineTransformIdentity];
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_coverView setAlpha:0.3f];
        [_bgView setTransform:CGAffineTransformMakeTranslation(0, -_bgView.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
    

}

- (void)dismiss{
    [UIView animateWithDuration:0.3f animations:^{
        [_coverView setAlpha:0];
        [_bgView setTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self removeFromSuperview];
        
        if(_DismissBlock){
            _DismissBlock();
        }
    }];
}


@end
