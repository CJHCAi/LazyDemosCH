//
//  IQLabelView.h
//  Created by kcandr on 17/12/14.

#import <UIKit/UIKit.h>

@protocol IQLabelViewDelegate;

@interface IQLabelView : UIView<UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    UIImageView *rotateView;
    UIImageView *closeView;

    BOOL _isShowingEditingHandles;
}

@property (assign, nonatomic) UITextField *textView;
@property (assign, nonatomic) NSString *fontName;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) UIImage *closeImage;
@property (assign, nonatomic) UIImage *rotateImage;

@property (unsafe_unretained) id <IQLabelViewDelegate> delegate;

@property(nonatomic, assign) BOOL showContentShadow;    //Default is YES.
@property(nonatomic, assign) BOOL enableClose;  // default is YES. if set to NO, user can't delete the view
@property(nonatomic, assign) BOOL enableRotate;  // default is YES. if set to NO, user can't Rotate the view

//调用刷新。是否支持UIScrollView父视图。它变化的缩放尺度。
- (void)refresh;

- (void)hideEditingHandles;
- (void)showEditingHandles;

@end

@protocol IQLabelViewDelegate <NSObject>
@optional
- (void)labelViewDidBeginEditing:(IQLabelView *)label;
- (void)labelViewDidChangeEditing:(IQLabelView *)label;
- (void)labelViewDidEndEditing:(IQLabelView *)label;

- (void)labelViewDidClose:(IQLabelView *)label;

- (void)labelViewDidShowEditingHandles:(IQLabelView *)label;
- (void)labelViewDidHideEditingHandles:(IQLabelView *)label;
- (void)labelViewDidStartEditing:(IQLabelView *)label;
@end



// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
