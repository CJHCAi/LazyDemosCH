//
//  ViewController.m
//  JJLabelDemo
//
//  Created by jiejin on 16/3/16.
//  Copyright © 2016年 jiejin. All rights reserved.
//

#import "ViewController.h"
#import "JJLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat superViewWidth = self.view.frame.size.width;
    
    {
        UILabel *normalLab = [[UILabel alloc] init];
        
        normalLab.text = @"这是一个普通的label";
        normalLab.frame = CGRectMake(30, 50, (superViewWidth - 30 * 2), 30);
        normalLab.textColor = [UIColor redColor];
        normalLab.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:normalLab];
    }
    
    {
        JJLabel *copyLab = [[JJLabel alloc] init];
        
        copyLab.frame = CGRectMake(20, 100, (superViewWidth - 20 * 2), 30);
        copyLab.text = @"阿杰说：这是被copy的内容，copy时会变蓝";
        copyLab.textAlignment = NSTextAlignmentCenter;
        copyLab.subFromIndexString = @"阿杰说：";
        copyLab.appendString = @"ajie";
        
        [self.view addSubview:copyLab];
        
        __weak __typeof(&*copyLab) weakLab = copyLab;
        copyLab.willShowMenu = ^(){
            
            weakLab.textColor = [UIColor blueColor];
        };
        
        copyLab.willHiddenMenu = ^(){
            
            weakLab.textColor = [UIColor blackColor];
        };
    }

    {
        JJLabel *spaceLab = [[JJLabel alloc] init];
        spaceLab.text = @"这是一个可以自定义行间距和字间距的label，并且可以直接获取到label的高度，大大提升了码农的工作效率";
        spaceLab.numberOfLines = 0;
        spaceLab.lineSpace = 5.0f;
        spaceLab.characterSpace = 5.0f;
        spaceLab.isCopy = NO;
        
        CGFloat labHeight = [spaceLab getLableHeightWithMaxWidth:(superViewWidth - 30 * 2)];
        
        spaceLab.frame = CGRectMake(30, 150, (superViewWidth - 30 * 2), labHeight);
        
        [self.view addSubview:spaceLab];
    }
    
    {
        JJLabel *changeLab = [[JJLabel alloc] init];
        changeLab.text = @"阿杰说：这是一个可以自定义行间距和字间距的label，并且可以直接获取到label的高度，大大提升了码农的工作效率";
        changeLab.numberOfLines = 0;
        changeLab.isCopy = NO;
        
        JJLabelItem *item = [JJLabelItem new];
        
        item.itemContent = @"阿杰说：";
        item.itemColor = [UIColor orangeColor];
        item.itemFont = [UIFont systemFontOfSize:30];
        
        changeLab.changeArray = @[item];
        
        
        CGFloat labHeight = [changeLab getLableHeightWithMaxWidth:(superViewWidth - 30 * 2)];
        
        changeLab.frame = CGRectMake(30, 300, (superViewWidth - 30 * 2), labHeight);
        
        [self.view addSubview:changeLab];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
