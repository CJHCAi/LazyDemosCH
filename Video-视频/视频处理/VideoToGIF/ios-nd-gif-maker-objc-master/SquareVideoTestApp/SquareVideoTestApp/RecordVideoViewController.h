//
//  RecordVideoViewController.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

@import UIKit;

@interface RecordVideoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (BOOL)startCameraFromViewController:(UIViewController*)viewController;

@end

