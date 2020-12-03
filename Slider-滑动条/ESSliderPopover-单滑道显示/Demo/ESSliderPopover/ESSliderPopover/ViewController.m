//
//  ViewController.m
//  ESSliderPopover
//
//  Created by 梅守强 on 16/7/18.
//  Copyright © 2016年 eshine. All rights reserved.
//

#import "ViewController.h"
#import "ESSliderPopover.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ESSliderPopover *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)sliderValueChanged:(id)sender {
    self.slider.popover.textLabel.text = [NSString stringWithFormat:@"%.2f", self.slider.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
