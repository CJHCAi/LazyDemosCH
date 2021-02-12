//
//  ClassifyMenu.h
//  明医智
//
//  Created by LiuLi on 2019/1/28.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMNode.h"
#import "CMenuConfig.h"

typedef void (^ChooseResult)(CMNode *node);
typedef void (^CloseMenuAction)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ClassifyMenu : UIView

@property (nonatomic,strong) UIView *bgView;

- (instancetype)initWithFrame:(CGRect)frame
                     rootNode:(CMNode *)rootNode
                 chooseResult:(ChooseResult)chooseResult
              closeMenuAction:(CloseMenuAction)closeMenuAction;

- (void)show;

- (void)close;

@end

NS_ASSUME_NONNULL_END
