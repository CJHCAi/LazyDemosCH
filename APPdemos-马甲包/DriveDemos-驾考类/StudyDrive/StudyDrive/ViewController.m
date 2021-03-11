//
//  ViewController.m
//  StudyDrive
//
//  Created by apple on 15-7-8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "SelectView.h"
#import "FirstViewController.h"
#import "SubjectTwoViewController.h"
#import "WebViewController.h"
@interface ViewController ()
{
    SelectView * _selecView;
    
    __weak IBOutlet UIButton *selectBtn;
}
@end

@implementation ViewController
- (IBAction)click:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _selecView.alpha=1;
            }];
        }
            break;
        case 101://科目一
        {
           
            UIBarButtonItem * item = [[UIBarButtonItem alloc]init];
            item.title=@"";
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:[[FirstViewController alloc]init] animated:YES];
        }
            break;
        case 102:
        {
            UIBarButtonItem * item = [[UIBarButtonItem alloc]init];
            item.title=@"科目二";
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:[[SubjectTwoViewController alloc]init] animated:YES];
            
        }
            break;
        case 103:
        {
            UIBarButtonItem * item = [[UIBarButtonItem alloc]init];
            item.title=@"科目三";
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:[[SubjectTwoViewController alloc]init] animated:YES];
        }
            break;
        case 104:
        {
            UIBarButtonItem * item = [[UIBarButtonItem alloc]init];
            item.title=@"科目四";
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:[[FirstViewController alloc]init] animated:YES];
        }
            break;
        case 105:
        {
            UIBarButtonItem * item = [[UIBarButtonItem alloc]init];
            item.title=@"";
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:[[WebViewController alloc]initWithUrl:@"http://zhinan.jxedt.com/index_7_1.html"] animated:YES];
        }
            break;
        case 106:
        {
            UIBarButtonItem * item = [[UIBarButtonItem alloc]init];
            item.title=@"";
            self.navigationItem.backBarButtonItem=item;
            [self.navigationController pushViewController:[[WebViewController alloc]initWithUrl:@"http://zhinan.jxedt.com/index_7_1.html"] animated:YES];
        }
            break;
        default:
            break;
    }
}

static SelectView * extracted() {
    return [SelectView alloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _selecView=[extracted()initWithFrame:self.view.frame andBtn:selectBtn];
     _selecView.alpha=0;
    [self.view addSubview:_selecView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
