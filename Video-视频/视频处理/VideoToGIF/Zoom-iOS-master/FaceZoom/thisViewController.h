//
//  ViewController.h
//  FaceZoom
//
//  Created by Ben Taylor on 5/3/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"


//@class ViewController;


@interface thisViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *myView;
@property(nonatomic,strong)UIImage *dvImage;
@property(nonatomic,strong)UIImage *originalImage;
@property(nonatomic, strong)UIImage *firstImage;
@property(nonatomic, strong)UIImage *secondImage;
@property(nonatomic, strong)UIImage *fourthImage;
@property (weak, nonatomic) IBOutlet UITextField *textEntry;
@property (nonatomic) IBOutlet UIImageView *zoomPic;
@property (weak, nonatomic) IBOutlet UIButton *zoomButton;

@property (strong, nonatomic)THLabel *textLabel;
@property (strong, nonatomic)THLabel *textLabel2;

@property(nonatomic) BOOL *isSomethingEnabled;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

