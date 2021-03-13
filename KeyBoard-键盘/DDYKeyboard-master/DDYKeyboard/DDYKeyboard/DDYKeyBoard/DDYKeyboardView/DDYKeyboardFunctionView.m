#import "DDYKeyboardFunctionView.h"
#import "DDYAuthorityManager.h"
#import "DDYVoiceView.h"
#import "DDYPhotoView.h"
#import "DDYCameraController.h"
#import "DDYShakeView.h"
#import "DDYGifView.h"
#import "DDYRedBagView.h"
#import "DDYEmojiView.h"
#import "DDYMoreView.h"

@interface DDYKeyboardFunctionView ()
/** 语音视图 */
@property (nonatomic, strong) DDYVoiceView *voiceView;
/** 相册视图 */
@property (nonatomic, strong) DDYPhotoView *photoView;
/** 相机控制器 */
@property (nonatomic, strong) DDYCameraController *cameraViewController;
/** 抖窗视图 */
@property (nonatomic, strong) DDYShakeView *shakeView;
/** gif视图 */
@property (nonatomic, strong) DDYGifView *gifView;
/** 红包视图 */
@property (nonatomic, strong) DDYRedBagView *redBagView;
/** 表情视图 */
@property (nonatomic, strong) DDYEmojiView *emojiView;
/** 更多视图 */
@property (nonatomic, strong) DDYMoreView *moreView;
/** 当前视图 */
@property (nonatomic, strong) UIView *currentView;

@end


@implementation DDYKeyboardFunctionView


- (DDYVoiceView *)voiceView {
    if (!_voiceView) {
        _voiceView = [DDYVoiceView viewWithFrame:CGRectMake(0, 0, DDYSCREENW, kbFunctionViewH)];
    }
    return _voiceView;
}

- (DDYPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [DDYPhotoView viewWithFrame:CGRectMake(0, 0, DDYSCREENW, kbFunctionViewH)];
        [_photoView setAlbumBlock:^{
            NSLog(@"点击相册");
        }];
        [_photoView setEditBlock:^(UIImage *image) {
            NSLog(@"点击编辑");
        }];
        [_photoView setSendImagesBlock:^(NSArray<UIImage *> *imgArray, BOOL isOrignal) {
            NSLog(@"点击发送");
        }];
    }
    return _photoView;
}

- (DDYCameraController *)cameraViewController {
    if (!_cameraViewController) {
        _cameraViewController = [DDYCameraController new];
        [_cameraViewController setTakePhotoBlock:^(UIImage *image, UIViewController *vc) {
            [vc dismissViewControllerAnimated:YES completion:^{   }];
        }];
    }
    return _cameraViewController;
}

- (DDYShakeView *)shakeView {
    if (!_shakeView) {
        _shakeView = [DDYShakeView viewWithFrame:CGRectMake(0, 0, DDYSCREENW, kbFunctionViewH)];
    }
    return _shakeView;
}

- (DDYGifView *)gifView {
    if (!_gifView) {
        _gifView = [DDYGifView viewWithFrame:CGRectMake(0, 0, DDYSCREENW, kbFunctionViewH)];
    }
    return _gifView;
}

- (DDYRedBagView *)redBagView {
    if (!_redBagView) {
        _redBagView = [DDYRedBagView viewWithFrame:CGRectMake(0, 0, DDYSCREENW, kbFunctionViewH)];
    }
    return _redBagView;
}

- (DDYEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [DDYEmojiView viewWithFrame:CGRectMake(0, 0, DDYSCREENW, kbFunctionViewH)];
    }
    return _emojiView;
}

- (DDYMoreView *)moreView {
    if (!_moreView) {
        _moreView = [DDYMoreView viewWithFrame:CGRectMake(0, 0, DDYSCREENW, kbFunctionViewH)];
    }
    return _moreView;
}


- (void)setState:(DDYKeyboardState)state {
    
    if (state == DDYKeyboardStateNone) {
        _show = NO;
        _refresh = (_state != DDYKeyboardStateSystem);
    }
    if (state == DDYKeyboardStateSystem) {
        _show = NO;
        _refresh = NO;
    }
    if (state == DDYKeyboardStateVoice) {
        _show = YES;
        self.currentView = self.voiceView;
        _refresh = (_state == DDYKeyboardStateNone);
    }
    if (state == DDYKeyboardStatePhoto) {
        _show = YES;
        self.currentView = self.photoView;
        _refresh = (_state == DDYKeyboardStateNone);
    }
    if (state == DDYKeyboardStateVideo) {
        [self presentCameraViewController];
        _refresh = NO;
    }
    if (state == DDYKeyboardStateShake) {
        _show = YES;
        self.currentView = self.shakeView;
        _refresh = (_state == DDYKeyboardStateNone);
    }
    if (state == DDYKeyboardStateGif) {
        _show = YES;
        self.currentView = self.gifView;
        _refresh = (_state == DDYKeyboardStateNone);
    }
    if (state == DDYKeyboardStateRedBag) {
        _show = YES;
        self.currentView = self.redBagView;
        _refresh = (_state == DDYKeyboardStateNone);
    }
    if (state == DDYKeyboardStateEmoji) {
        _show = YES;
        self.currentView = self.emojiView;
        _refresh = (_state == DDYKeyboardStateNone);
    }
    if (state == DDYKeyboardStateMore) {
        _show = YES;
        self.currentView = self.moreView;
        _refresh = (_state == DDYKeyboardStateNone);
    }
    _state = state;
}

- (void)setCurrentView:(UIView *)currentView {
    if (_currentView) [_currentView removeFromSuperview];
    _currentView = currentView;
    if (_currentView) [self addSubview:_currentView];
}

- (void)presentCameraViewController {
    [DDYAuthorityManager ddy_AudioAuthAlertShow:YES success:^{
        [DDYAuthorityManager ddy_CameraAuthAlertShow:YES success:^{
            [[self ddy_GetResponderViewController] presentViewController:self.cameraViewController animated:YES completion:^{ }];
        } fail:^(AVAuthorizationStatus authStatus) { }];
    } fail:^(AVAuthorizationStatus authStatus) { }];
}

@end
