//
//  DisplayViewController.m
//  RabbitWallpaper
//
//  Created by MacBook on 16/4/28.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "DisplayViewController.h"

typedef enum {
    ImageActionAsHomeScreen = 0,
    ImageActionAsLockScreen,
    ImageActionAsBoth,
    ImageActionAsPhoto
}ImageAction;

@interface DisplayViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bingImageView;
@property (weak, nonatomic) IBOutlet UIView *setView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.setView.hidden = YES;
    self.backBtn.hidden = YES;
    [self.bingImageView setImageWithURL:[NSURL URLWithString:self.bigImageUrl]];
    

    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [UIView animateWithDuration:1 animations:^{
    
    self.setView.hidden=!self.setView.hidden;
    self.backBtn.hidden=!self.backBtn.hidden;
//    }];

    
}
- (IBAction)leftTouch:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}



- (IBAction)setImage:(id)sender {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设为桌面壁纸",@"设为锁屏壁纸",@"设为锁屏和桌面壁纸", nil];
//    
//    [actionSheet showInView:self.view];
    [MobClick event:@"preservation"];

    UIImageWriteToSavedPhotosAlbum(self.bingImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);

}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        
        [StatusTipView showStatusTip:@"成功保存到相册" status:StatusTipSuccess];
//        message = @"成功保存到相册";
    }else{
        [StatusTipView showStatusTip:[error description] status:StatusTipFailure];

//        message = [error description];
    }
}
#pragma mark  UIActionSheetDelegate

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    switch (buttonIndex)
//    {
//        case ImageActionAsHomeScreen:
//        {
//            [self.bingImageView.image zj_saveAsHomeScreen];
//
//        }
//            break;
//        case ImageActionAsLockScreen:
//        {
//            [self.bingImageView.image zj_saveAsLockScreen];
//        }
//            break;
//        case ImageActionAsBoth:
//        {
//            [self.bingImageView.image zj_saveAsHomeScreenAndLockScreen];
//            [self.bingImageView.image zj_saveToPhotos];
//        }
//            break;
//  
//        default:
//            break;
//    }
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
