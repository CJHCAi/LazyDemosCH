//
//  ViewController.m
//  ZWGraphicViewDemo
//
//  Created by xzw on 17/6/5.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ViewController.h"
#import "ZWGraphicView.h"

@interface ViewController ()

@property (nonatomic,strong) ZWGraphicView * graphicView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZWGraphicView * drawView = [[ZWGraphicView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-100)];
    self.graphicView = drawView;
    [self.view addSubview:drawView];
   

}
- (IBAction)savePhoto:(id)sender {
    
    [self.graphicView savePhotoToAlbum];
}

- (IBAction)undo:(id)sender {
    
    [self.graphicView undoLastDraw];
}

- (IBAction)clearAll:(id)sender {
    
    [self.graphicView clearDrawBoard];
}




@end
