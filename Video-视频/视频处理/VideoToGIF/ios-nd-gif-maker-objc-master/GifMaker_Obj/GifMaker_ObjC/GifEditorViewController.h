//
//  GifEditorViewController.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/4/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gif.h"

@interface GifEditorViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic) Gif *gif;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;



@end
