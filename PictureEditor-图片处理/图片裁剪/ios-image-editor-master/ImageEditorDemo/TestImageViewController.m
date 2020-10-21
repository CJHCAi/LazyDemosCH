//
//  TestImageViewController.m
//  ImageEditor
//
//  Created by 蔡建华 on 2019/1/14.
//  Copyright © 2019 Heitor Ferreira. All rights reserved.
//

#import "TestImageViewController.h"
#import "HFImageEditorFrameView.h"
@interface TestImageViewController ()

@end

@implementation TestImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HFImageEditorFrameView * editorImageView = [[HFImageEditorFrameView alloc] initWithFrame:CGRectMake(100, 200, 300, 300)];
    editorImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:editorImageView];
}


@end
