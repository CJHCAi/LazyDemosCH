//
//  FooterViewController.m
//  H850Samba
//
//  Created by zhengying on 3/25/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "FooterViewController.h"
#import "UIImage+Utility.h"

#define DEFAULT_HEIGHT 44.0

#define SPACE_LEFT 10.0
#define SPACE_RIGHT SPACE_LEFT

#define BAR_HEIGHT 48.0
#define BAR_WIDTH [UIScreen mainScreen].bounds.size.width

#define BAR_ITEM_WIDTH 0.0
#define BAR_ITEM_HEIGHT 0.0

#define DLog NSLog

@implementation FootBarItem
@end

@interface FooterViewController ()

@end

@implementation FooterViewController {
    NSMutableArray* _arrayFootBarItems;
    UIView* _customView;
    NSString* _currentSelectTag;
}

-(BOOL)existTag:(NSString*)tag {
    return ([self findFootBarItemByTag:tag] != nil);
}

-(FootBarItem*) findFootBarItemByTag:(NSString*)tag {
    FootBarItem* retItem = nil;
    
    for (FootBarItem *item in _arrayFootBarItems) {
        if ([tag isEqualToString:item.tag]) {
            retItem = item;
            break;
        }
    }
    return retItem;
}

-(void)selectBarItem:(FootBarItem*)barItem {
    
    BOOL canSelect = YES;
    
    if (barItem.preAction) {
        canSelect = barItem.preAction(barItem.tag);
    }
    
    if (!canSelect) {
        return;
    }
    
    if (barItem.notTab || barItem.isToggle) {
        barItem.action();
    } else {
        FootBarItem* preSelectItem = [self findFootBarItemByTag:_currentSelectTag];
        [preSelectItem.button setImage:preSelectItem.imageNormal forState:UIControlStateNormal];
    
        [barItem.button setImage:barItem.imageSelect forState:UIControlStateNormal];
        barItem.action();
        _currentSelectTag = barItem.tag;
    }
}

-(void)selectItemByTag:(NSString*)tag {
    for (int i = 0; i < _arrayFootBarItems.count; i++) {
        FootBarItem* barItem = _arrayFootBarItems[i];
        if ([tag isEqualToString:barItem.tag]) {
            [self selectBarItem:barItem];
        }
    }
}

-(void)selectItemForceByTag:(NSString*)tag
{
    for (int i = 0; i < _arrayFootBarItems.count; i++) {
        FootBarItem* barItem = _arrayFootBarItems[i];
        if ([tag isEqualToString:barItem.tag]) {
            if (barItem.notTab || barItem.isToggle) {
                barItem.action();
            } else {
                FootBarItem* preSelectItem = [self findFootBarItemByTag:_currentSelectTag];
                [preSelectItem.button setImage:preSelectItem.imageNormal forState:UIControlStateNormal];
                
                [barItem.button setImage:barItem.imageSelect forState:UIControlStateNormal];
                barItem.action();
                _currentSelectTag = barItem.tag;
            }
            break;
        }
    }
}

-(void)initDefaultData {
    _barHeight = DEFAULT_HEIGHT;
    _backgoundColor = [UIColor clearColor];
    _fontColor = [UIColor blackColor];
    _font = [UIFont systemFontOfSize:10];
    
    _leftSpaceWidth = _rightSpaceWidth = SPACE_LEFT;

    _barItemWidth = BAR_ITEM_WIDTH;
    _barItemHeight = BAR_ITEM_HEIGHT;
    
    _animation = YES;
    _isHidden = YES;
}

-(id)init {
    self = [super init];
    
    if (self) {
        [self initDefaultData];
    }

    return self;
}

-(id)initWithHeight:(CGFloat)height BGColor:(UIColor*)color Parent:(UIView*) parentView {
    self = [super init];
    
    if (self) {
        
        [self initDefaultData];
        _barHeight = height;
        _parentView = parentView;
        _backgoundColor = color;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(FootBarItem*)getFootBarItemByTag:(NSString*)tag {
    for (FootBarItem *item in _arrayFootBarItems) {
        if ([item.tag isEqualToString:tag]) {
            return item;
        }
    }
    return nil;
}

-(void)addCustomView:(UIView*)view {
    _customView = view;
}

-(void)addFrontFootBarItem:(FootBarItem*)footBarItem {
    
    NSAssert((footBarItem.tag != nil && [self existTag:footBarItem.tag] == NO), @"tag already exist");
    
    if (_arrayFootBarItems == nil) {
        _arrayFootBarItems = [[NSMutableArray alloc]init];
    }

    
    if (_barItemHeight == 0.0) {
        if (footBarItem.imageNormal) {
            _barItemHeight = footBarItem.imageNormal.size.height;
            _barItemWidth = footBarItem.imageNormal.size.width;
        }
    }
    
    if (footBarItem.itemShowText != nil &&
        [footBarItem.itemShowText isEqualToString:@""] != YES) {
        
        footBarItem.imageNormal = [[self class] createFooterBarItemIconByImage:footBarItem.imageNormal
                                                                          Text:footBarItem.itemShowText
                                                                          Font:_font FontColor:_fontColor];
        
        footBarItem.imageSelect = [[self class] createFooterBarItemIconByImage:footBarItem.imageSelect
                                                                          Text:footBarItem.itemShowText
                                                                          Font:_font
                                                                     FontColor:_fontColor];
        
        footBarItem.imageDisable = [[self class] createFooterBarItemIconByImage:footBarItem.imageDisable
                                                                           Text:footBarItem.itemShowText
                                                                           Font:_font
                                                                      FontColor:_fontColor];
    }
    
    [_arrayFootBarItems addObject:footBarItem];
}

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsTab:(BOOL)isTab
                                 Action:(void(^)())action
                                  {
    [self addFrontFootBarItemByImageNormal:imageNormal
                             ImageSelected:imageSelected
                                       Tag:tag
                                  ShowText:showText
                                     IsTab:isTab
                                 PreAction:nil
                                    Action:action];
}

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                 Action:(void(^)())action {
    [self addFrontFootBarItemByImageNormal:imageNormal
                             ImageSelected:imageSelected
                                       Tag:tag
                                  ShowText:showText
                                     IsTab:true
                                 PreAction:nil
                                    Action:action];
}

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                           ImageDisable:(UIImage*)imageDisable
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsTab:(BOOL)isTab
                                 Action:(void(^)())action
                                  {
    [self addFrontFootBarItemByImageNormal:imageNormal
                             ImageSelected:imageSelected
                              ImageDisable:imageDisable
                                       Tag:tag
                                  ShowText:showText
                                     IsTab:isTab
                                 PreAction:nil
                                    Action:action];
}

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                           ImageDisable:(UIImage*)imageDisable
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                               IsToggle:(BOOL)isToggle
                                 Action:(void(^)())action {
    [self addFrontFootBarItemByImageNormal:imageNormal
                         ImageSelected:imageSelected
                          ImageDisable:imageDisable
                                   Tag:tag
                              ShowText:showText
                                 IsTab:YES
                              IsToggle:isToggle
                             PreAction:nil
                                Action:action];
}

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsTab:(BOOL)isTab
                              PreAction:(BOOL(^)(NSString *strTagId))preAction
                                 Action:(void(^)())action
                                    {
 [self addFrontFootBarItemByImageNormal:imageNormal
                          ImageSelected:imageSelected
                           ImageDisable:nil
                                    Tag:tag
                               ShowText:showText
                                  IsTab:isTab
                              PreAction:preAction
                                 Action:action];
}

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                           ImageDisable:(UIImage*)imageDisable
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsTab:(BOOL)isTab
                               IsToggle:(BOOL)isToggle
                              PreAction:(BOOL(^)(NSString *strTagId))preAction
                                 Action:(void(^)())action {
    FootBarItem* item = [[FootBarItem alloc]init];
    item.imageNormal = imageNormal;
    item.imageSelect = imageSelected;
    item.imageDisable = imageDisable;
    item.preAction = preAction;
    item.action = action;
    item.tag = tag;
    item.itemShowText = showText;
    item.notTab = !isTab;
    item.isToggle = isToggle;
    
    [self addFrontFootBarItem:item];
}

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                          ImageDisable:(UIImage*)imageDisable
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsTab:(BOOL)isTab
                              PreAction:(BOOL(^)(NSString *strTagId))preAction
                                 Action:(void(^)())action {
    [self addFrontFootBarItemByImageNormal:imageNormal
                             ImageSelected:imageSelected
                              ImageDisable:imageDisable
                                       Tag:tag
                                  ShowText:showText
                                     IsTab:isTab
                                  IsToggle:NO
                                 PreAction:preAction
                                    Action:action];
}

-(void)loadView {
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, BAR_WIDTH, BAR_HEIGHT)];
}

-(void)updateLayoutBarItem {
    
    CGRect frameReal = CGRectMake(0, _parentView.frame.size.height - _barHeight, BAR_WIDTH, _barHeight);
    
    NSInteger itemCount = _arrayFootBarItems.count;
    
    NSAssert(_parentView != nil, @"parentView is not Set !!!!");

    
    if (_animation) {
        self.view.frame = CGRectMake(0, _parentView.frame.size.height, BAR_WIDTH, _barHeight);
    } else {
        self.view.frame = frameReal;
    }
    
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    DLog(@"self.view = %@", self.view);
    
    if ( _customView == nil) {
        // top bolder
        //UIView *topBolder = [[UIView alloc] initWithFrame:CGRectMake(0, 1, viewBar.frame.size.width,1)];
        //topBolder.backgroundColor = COLOR_APP_GERY_TEXT;
        //[viewBar addSubview:topBolder];
        
        for (UIView* view in self.view.subviews) {
            [view removeFromSuperview];
        }
        
        CGFloat itemY = _barHeight / 2.0 - _barItemHeight / 2.0;
        CGFloat spaceItem = 0;
        
        if (_arrayFootBarItems.count > 1) {
            spaceItem = (BAR_WIDTH - _leftSpaceWidth - _rightSpaceWidth - itemCount * _barItemWidth) / (itemCount-1);
        }

        
        for (NSInteger i = 0; i < itemCount; i++) {
            FootBarItem* item = _arrayFootBarItems[i];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _barItemWidth, _barItemHeight)];
            
            
            [btn setImage:item.imageNormal forState:UIControlStateNormal];
            
            if (item.isToggle) {
                [btn setImage:item.imageSelect forState:UIControlStateSelected];
            } else {
                [btn setImage:item.imageSelect forState:UIControlStateHighlighted];
            }

            [btn setImage:item.imageDisable forState:UIControlStateDisabled];
            
            CGRect rect_btn = btn.frame;
            
            if (_arrayFootBarItems.count == 1) {
                rect_btn.origin.x = (BAR_WIDTH-_barItemWidth)/2 ;
            } else {
                rect_btn.origin.x = (spaceItem+_barItemWidth)* i + _leftSpaceWidth;
            }
            
            rect_btn.origin.y = itemY;
            btn.frame = rect_btn;
            btn.tag = i;
            item.button = btn;
            [btn addTarget:self action:@selector(actionFootItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
    // custom view
    } else {
        CGSize sizeCustom = _customView.frame.size;
        CGSize sizeSelfView = _customView.frame.size;
        _customView.frame = CGRectMake((sizeSelfView.width-sizeCustom.width) / 2,
                                       (sizeSelfView.height - sizeCustom.height) / 2,
                                       sizeCustom.width, sizeCustom.height);
        [self.view addSubview:_customView];
    }
    
    self.view.backgroundColor = _backgoundColor;
    
    [_parentView addSubview:self.view];
}

-(void)actionFootItemClicked:(id)sender {
    UIButton* clickedButton = (UIButton*)sender;
    NSInteger index = clickedButton.tag;
    FootBarItem* item = [_arrayFootBarItems objectAtIndex:index];
    
    if (![_currentSelectTag isEqualToString:item.tag]) {
        [self selectBarItem:item];
    }
}

-(void)dismiss {
    [self dismissComplete:nil];
}

-(void)dismissComplete:(void (^)(void))completeAction {
    
    if (_parentView == nil) {
        DLog(@"ParentView not set!!!!");
        return;
    }
    
    _isHidden = YES;
    
    if (_animation) {
        CGRect rectDown = CGRectMake(0, _parentView.frame.size.height, BAR_WIDTH, _barHeight);
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = rectDown;
        }completion:^(BOOL finished) {
            if (/*finished*/1) {
                if (completeAction) {
                    [self.view removeFromSuperview];
                    completeAction();
                }
            }
        }];
    }
}

-(void)show {
    [self show:nil ];
}

-(void)show:(void (^)(void))completeAction {
    if (_parentView == nil) {
        DLog(@"ParentView not set!!!!");
        return;
    }
    
    _isHidden = NO;
    
    CGRect frameReal = CGRectMake(0, _parentView.frame.size.height - _barHeight, BAR_WIDTH, _barHeight);
    DLog(@"frameReal: x = %.2f y= %.2f w=%.2f h=%.2f", frameReal.origin.x, frameReal.origin.y, frameReal.size.width, frameReal.size.height);
    if (_animation) {
        [UIView animateWithDuration:0.3 animations:^{
            DLog(@"nextFrame%@", self.view);
            self.view.frame = frameReal;

            if (completeAction) {
                completeAction();
            }

        }];
    }
}

+(UIImage*)createFooterBarItemIconByImage:(UIImage*)image
                                     Text:(NSString*)text
                                     Font:(UIFont*)font
                                FontColor:(UIColor*)fontColor {
    
    UIImage* imageResult = nil;
    CGSize imageSize = image.size;
    CGSize stringbound = [text sizeWithAttributes:@{NSFontAttributeName:font}]; // default [UIFont systemFontOfSize:10]
    
    if (image == nil) {
        return nil;
    }
    
    imageResult = [UIImage drawText:text
                               font:font
                            inImage:image
                            atPoint:CGPointMake(imageSize.width/2 - stringbound.width/2, 28)
                              color:fontColor];
    return imageResult;
}

+(UIButton*)createFooterButtonByImage:(UIImage*)image
                          SelectImage:(UIImage*)selectImage
                         DisableImage:(UIImage*)disalbeImage
                       IsToggleButton:(BOOL)isToggleButton
                                 Font:(UIFont*)font
                            FontColor:(UIColor*)fontColor
                                 Text:(NSString*)text {
    if (text != nil &&  [text isEqualToString:@""] == NO) {
        image = [[self class]createFooterBarItemIconByImage:image Text:text Font:font FontColor:fontColor];
        selectImage = [[self class]createFooterBarItemIconByImage:selectImage Text:text Font:font FontColor:fontColor];
        disalbeImage = [[self class]createFooterBarItemIconByImage:selectImage Text:text Font:font FontColor:fontColor];
    }
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, image.size.width, image.size.width)];
    
    [btn setImage:image forState:UIControlStateNormal];
    if (isToggleButton) {
        [btn setImage:selectImage forState:UIControlStateSelected];
    } else {
        [btn setImage:selectImage forState:UIControlStateHighlighted];
    }

    [btn setImage:disalbeImage forState:UIControlStateDisabled];
    return btn;
}

/*
+(UIButton*)createFooterButtonByImage:(UIImage*)image
                          SelectImage:(UIImage*)selectImage
                         DisableImage:(UIImage*)disalbeImage
                                 Text:(NSString*)text {
    return [[self class]createFooterButtonByImage:image
                               SelectImage:selectImage
                              DisableImage:disalbeImage
                            IsToggleButton:NO
                                      Text:text];

}
 */

-(void)enableBarItemByTag:(NSString*)tag Enable:(BOOL)enable {
    FootBarItem* footBarItem = [self getFootBarItemByTag:tag];
    footBarItem.button.enabled = enable;
}

-(void)setHiddenBarItemByTag:(NSString*)tag Hiden:(BOOL)hidden {
    FootBarItem* footBarItem = [self getFootBarItemByTag:tag];
    footBarItem.button.hidden = hidden;
}

-(void)updateBarItemByTag:(NSString*)tag
              NormalImage:(UIImage*)normalImage
              SelectImage:(UIImage*)selectImage Text:(NSString*)text {
    [self updateBarItemByTag:tag
                 NormalImage:normalImage
                 SelectImage:selectImage
                DisableImage:nil
                        Text:text];
}

-(void)updateBarItemByTag:(NSString*)tag
              NormalImage:(UIImage*)normalImage
              SelectImage:(UIImage*)selectImage
              DisableImage:(UIImage*)disableImage Text:(NSString*)text {
    
    FootBarItem* footBarItem = [self getFootBarItemByTag:tag];
    
    if (!footBarItem) {
        DLog(@"no item find");
        return;
    }
    
    if (text) {
        footBarItem.itemShowText = text;

    }
    
    if (footBarItem.itemShowText) {
        normalImage = [FooterViewController createFooterBarItemIconByImage:normalImage Text:footBarItem.itemShowText Font:_font
                                                                 FontColor:_fontColor];
        selectImage = [FooterViewController createFooterBarItemIconByImage:selectImage Text:footBarItem.itemShowText Font:_font
                                                                 FontColor:_fontColor];
        disableImage = [FooterViewController createFooterBarItemIconByImage:disableImage Text:footBarItem.itemShowText Font:_font
                                                                  FontColor:_fontColor];
    }
    
    footBarItem.imageNormal = normalImage;
    footBarItem.imageSelect = selectImage;
    footBarItem.imageDisable = disableImage;
    
    if ([_currentSelectTag isEqualToString:tag]) {
        [footBarItem.button setImage:footBarItem.imageSelect forState:UIControlStateNormal];
        [footBarItem.button setImage:footBarItem.imageNormal forState:UIControlStateHighlighted];

    } else {
        [footBarItem.button setImage:footBarItem.imageNormal forState:UIControlStateNormal];
        [footBarItem.button setImage:footBarItem.imageSelect forState:UIControlStateHighlighted];
    }
    
    [footBarItem.button setImage:footBarItem.imageNormal forState:UIControlStateDisabled];
}

-(void)updateBarItemByTag:(NSString*)tag
              NormalImage:(UIImage*)normalImage
              SelectImage:(UIImage*)selectImage {
    [self updateBarItemByTag:tag NormalImage:normalImage SelectImage:selectImage Text:nil];
}


@end
