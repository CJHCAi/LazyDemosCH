//
//  ViewController.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/3.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "ViewController.h"

#import "SDEditRichImageViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView * theShowImageContentView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSelectedPhoto)];
    
    [self.view addGestureRecognizer:tap];
    
    
    self.theShowImageContentView.image = [UIImage imageNamed:@"timg.jpeg"];
    
    
    
}

- (void)pushSelectedPhoto
{
    NSLog(@"选择图片");
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"编辑图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SDEditRichImageViewController * editRichImage = [[SDEditRichImageViewController alloc] init];
        editRichImage.originImage = [UIImage imageNamed:@"timg.jpeg"];
        [self.navigationController pushViewController:editRichImage animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"选择图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
