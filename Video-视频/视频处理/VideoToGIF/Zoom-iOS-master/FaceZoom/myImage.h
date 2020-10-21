//
//  myImage.h
//  FaceZoom
//
//  Created by Ben Taylor on 5/3/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myImage : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIImagePickerController *picker;


@end
