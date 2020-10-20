//
//  ViewController.m
//  HQDrawingBoard
//
//  Created by zfwlxt on 17/3/15.
//  Copyright © 2017年 何晴. All rights reserved.
//

#import "ViewController.h"
#import "HQDrawingView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet HQDrawingView *HQDrawView;
@property (weak, nonatomic) IBOutlet UISlider *widthSlide;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSegment;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.HQDrawView initDrawingView];
}


- (IBAction)widthSlider:(UISlider *)sender {
    
    self.HQDrawView.lineWidth = self.widthSlide.value;
}

- (IBAction)colorSegment:(UISegmentedControl *)sender {
    
    switch (self.colorSegment.selectedSegmentIndex) {
        case 0:
            self.HQDrawView.color = [UIColor blackColor];
            break;
        case 1:
            self.HQDrawView.color = [UIColor redColor];
            break;
        case 2:
            self.HQDrawView.color = [UIColor greenColor];
            break;
        default:
            break;
    }
}

- (IBAction)back:(id)sender {
    [self.HQDrawView doBack];
}


- (IBAction)forward:(id)sender {
    [self.HQDrawView doForward];
}

- (IBAction)save:(id)sender {
    
    __weak typeof(self) weakS = self;
    [self.HQDrawView saveImage:^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"保存成功"
                                                                       message:@"请在相册查看"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [weakS presentViewController:alert animated:YES completion:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
