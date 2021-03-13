#import <UIKit/UIKit.h>
#import "DDYKeyboardConfig.h"

// 仿QQ键盘各种类型
typedef NS_ENUM(NSInteger, DDYKeyboardType) {
    DDYKeyboardTypeStranger = 0,    // 非好友时样式
    DDYKeyboardTypeSingle,          // 单聊时样式
    DDYKeyboardTypeGroup,           // 群聊时样式
};

@interface DDYKeyboard : UIView

/** 关联tableView */
@property (nonatomic, weak) UITableView *associateTableView;

+ (instancetype)keyboardWithType:(DDYKeyboardType)type;

- (void)updateFrameAnimate:(BOOL)animate;

- (void)keyboardDown;

@end
