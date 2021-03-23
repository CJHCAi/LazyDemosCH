//
//  ViewController.m
//  Test_QRLogoCode
//
//  Created by JXH on 2017/8/8.
//  Copyright © 2017年 JXH. All rights reserved.
//

#import "ViewController.h"
#import "NPQRCodeManager.h"

#define QRStr @"http://www.baidu.com"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *QRImgeView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** title*/
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataArray = @[@"默认黑色",@"自定义颜色",@"自定义logo与颜色",@"已有二维码改色",@"已有二维码加logo",@"其他"];
}

#pragma mark - TableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    if (self.dataArray.count > indexPath.row) {
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   // self.dataArray = @[@"默认黑色",@"自定义颜色",@"自定义logo与颜色",@"已有二维码改色",@"已有二维码加logo"];

    UIImage *resultImage = nil;
    switch (indexPath.row) {
        case 0:
            resultImage = [NPQRCodeManager createQRCode:QRStr];
            break;
        case 1:
            resultImage = [NPQRCodeManager createQRCode:QRStr withColor:[UIColor cyanColor]];
            break;
        case 2:{//先处理logo
            UIImage *logoImage = [NPQRCodeManager clipCornerRadius:[UIImage imageNamed:@"daren"] withSize:CGSizeMake(50, 50) cornerRadius:3 borderWidth:5 andBorderColor:nil];
            resultImage = [NPQRCodeManager createQRCode:QRStr withColor:[UIColor cyanColor] andLogoImageView:logoImage];
        }
            break;
        case 3:
        {
            resultImage = [NPQRCodeManager createQRCode:QRStr];
//            resultImage = [NPQRCodeManager imageBlackToTransparent:resultImage withRed:155 andGreen:155 andBlue:155];
            resultImage = [NPQRCodeManager changeQRCodeImage:resultImage withColor:[UIColor greenColor]];

        }
            break;
        case 4:{
            UIImage *logoImage = [NPQRCodeManager clipCornerRadius:[UIImage imageNamed:@"daren"] withSize:CGSizeMake(50, 50) cornerRadius:5 borderWidth:10 andBorderColor:nil];
            resultImage = [NPQRCodeManager createQRCode:QRStr];
            resultImage = [NPQRCodeManager addLogoImage:resultImage withLogoImage:logoImage ofTheSize:resultImage.size];
        }
            break;
            case 5:
            break;
            
        default:
            break;
    }
    
    self.QRImgeView.image = resultImage;
    
}


@end
