/**
 * 整体视图:
   DDYKeyboard
 
 ** 结构视图:
    DDYKeyboardTextBar(含输入框部分视图)
    DDYKeyboardToolBar(功能选择部分视图)
    DDYKeyboardFunctionView(功能实现部分视图)
 
 *** DDYKeyboardTextBar:
     textBackgroudView(UIImageView)背景视图，可以设置输入框背景
     textView(UITextView)输入视图
 
 *** DDYKeyboardToolBar:
     N个itemButton(UIButton)点击切换不同功能
 
 *** DDYKeyboardFunctionView:
     N个itemView(UIView)实现不同功能
 
 */


#import "DDYMacrol.h"
#import "DDYCategoryHeader.h"
#import "Masonry.h"


/** DDYKeyboard */
// 浅背景色
#define kbBgSmallColor [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.]
// 中背景色
#define kbBgMidColor [UIColor colorWithRed:235./255. green:235./255. blue:235./255. alpha:1.]
// 深背景色
#define kbBgBigColor [UIColor colorWithRed:225./255. green:225./255. blue:225./255. alpha:1.]
// 所有状态
typedef NS_OPTIONS(NSInteger, DDYKeyboardState) {
    DDYKeyboardStateNone        = 0,        // 注销状态
    DDYKeyboardStateSystem      = 1 << 0,   // 系统键盘
    DDYKeyboardStateVoice       = 1 << 1,   // 语音状态
    DDYKeyboardStatePhoto       = 1 << 2,   // 相册状态
    DDYKeyboardStateVideo       = 1 << 3,   // 相机状态
    DDYKeyboardStateShake       = 1 << 4,   // 窗口抖动
    DDYKeyboardStateGif         = 1 << 5,   // gif状态
    DDYKeyboardStateRedBag      = 1 << 6,   // 红包模式
    DDYKeyboardStateEmoji       = 1 << 7,   // 表情模式
    DDYKeyboardStateMore        = 1 << 8,   // 更多模式
};


/** DDYKeyboardTextBar */
// 输入视图距离约束视图(父视图视图)距离
#define kbTextViewMargin 5
// 输入框字号
#define kbTextViewFont 15
// 输入框最大输入行数
#define kbTextViewMaxLine 5
// 输入框背景视图距离约束视图(父视图)距离
#define kbTextBarBgMargin 10


/** DDYKeyboardToolBar */
// 按钮距约束视图(父视图)底部距离
#define kbToolBarMargin 10
// 按钮宽高
#define kbToolBarButtonWH 30
// DDYKeyboardToolBar(功能选择部分视图)高度 40
#define kbToolBarH (kbToolBarButtonWH + kbToolBarMargin)


/** DDYKeyboardInputView */
// DDYKeyboardFunctionView(功能实现部分视图)显示时高度
#define kbFunctionViewH 260


/** DDYKeyboardVoiceView * 语音 */
// 首页面指示器圆点高宽
#define kbVoiceCircleWH 8
// 首页面指示器文字标签距圆点距离
#define kbVoiceLabalTop 6
// 首页面指示器文字标签高度
#define kbVoiceLabalH 16
// 首页面指示器文字标签间距
#define kbVoiceLabalMargin 10
// 首页面指示器文字标签字号
#define kbVoiceLabalFont 14
// 首页面指示器文字标签距底部边缘距离
#define kbVoiceLabalBottom 20
// 整个指示条高度
#define kbVoiceIndicatorH (kbVoiceCircleWH + kbVoiceLabalTop + kbVoiceLabalH + kbVoiceLabalBottom)

// 状态
typedef NS_ENUM(NSInteger, DDYVoiceState) {
    DDYVoiceStatePrepare = 0,       // 准备中
    DDYVoiceStateNormal,            // 按住说话
    DDYVoiceStateClickRecord,       // 点击录音
    DDYVoiceStateTouchChangeVoice,  // 按住变声
    DDYVoiceStateListen,            // 试听
    DDYVoiceStateCancel,            // 取消
    DDYVoiceStateSend,              // 发送
    DDYVoiceStateRecording,         // 录音中
    DDYVoiceStatePreparePlay,       // 准备播放
    DDYVoiceStatePlay,              // 播放
};


/** DDYKeyboardPhotoView * 图片 */
// 字体色
#define kbPhotoTextColor [UIColor colorWithRed:0. green:100./255. blue:1. alpha:1.]
// 字体大小
#define kbPhotoFont 16






