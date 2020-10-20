//
//  BaseViewController.m
//  MLLabelDemo
//
//  Created by 孙巧巧 on 2017/11/28.
//  Copyright © 2017年 孙巧巧. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *vlsName = NSStringFromClass(self.class);
    
    self.title = [vlsName substringToIndex:vlsName.length-@"ViewController".length];
    
    [self.view addSubview:self.button];
    
    [self.view addSubview:self.label];
    
    self.button.frame = CGRectMake((self.view.width-150.0f)/2, 64.0f+10.0f, 150.0f, 40.0f);
    self.label.frame = CGRectMake(10.0f, self.button.bottom+20.0f, self.view.width-10.0f*2, 100.0f);
    
    [self change];
}

- (MLLabel *)label{
    if (!_label) {
        _label = [[self lableClass] new];
        _label.backgroundColor = [UIColor colorWithWhite:0.920 alpha:1.000];
    }
    return _label;
}

- (UIButton *)button
{
    if (!_button) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"Change" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor darkGrayColor];
        
        _button = button;
    }
    return _button;
}

- (void)change{
    static int i = 0;
    int result = i%[self resultCount];
    
    [self.button setTitle:[NSString stringWithFormat:@"Change(Now:%d)",result] forState:UIControlStateNormal];
    
    [self changeToresult:result];
    
    i++;
    
}
- (Class)lableClass{
    return [MLLabel class];
}
-(NSInteger)resultCount{
    return 1;
}
- (void)changeToresult:(int)result{
    
}
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
