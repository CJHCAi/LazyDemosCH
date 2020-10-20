//
//  SDGraffitiFunctionViewController.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDGraffitiFunctionViewController.h"

#import "SDGraffitiEditPhotoControllerItemsView.h"

#import "SDGraffitiEditImageViewModel.h"

#import "SDRevealView.h"

#import "SDDrawingView.h"

@interface SDGraffitiFunctionViewController ()

@property (nonatomic, weak)SDGraffitiEditPhotoControllerItemsView * graffitiView;

@property (nonatomic, strong) SDGraffitiEditImageViewModel * graffitiViewModel;

@property (nonatomic, weak) SDRevealView * theRevealView;

@property (nonatomic, weak) SDDrawingView * drawView;

@end

@implementation SDGraffitiFunctionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self sd_configView];
    
    [self sd_configData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - config
- (void)sd_configView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.theRevealView.revealImage = self.showImageView;

    [self drawView];
    
    self.drawView.frame = self.theRevealView.theRevealView.bounds;
    
    [self graffitiView];
    

}

- (void)sd_configData
{
    self.graffitiViewModel = (SDGraffitiEditImageViewModel *)[SDGraffitiEditImageViewModel modelViewController:self];
    [self.graffitiViewModel cancelModel];
    self.graffitiView.cancelModel = self.graffitiViewModel.cancelModel;
    
    self.graffitiView.sureModel = self.graffitiViewModel.sureModel;
    
    self.graffitiView.brushModel = self.graffitiViewModel.brushModel;
    
    self.graffitiView.eraserModel = self.graffitiViewModel.eraserModel;
    
    self.graffitiView.graffitiSelectedColorModel = self.graffitiViewModel.graffitiSelectedColorModel;
    
    self.graffitiView.graffitiResetModel = self.graffitiViewModel.graffitiResetModel;
    
    self.graffitiView.graffiti_size_list = self.graffitiViewModel.graffiti_size_list;
    
    self.graffitiView.graffiti_color_list = self.graffitiViewModel.graffiti_color_list;
    
}

#pragma mark - done action

- (void)onSureAction{
    
    UIImage * image = [UIImage makeImageFromShowView:self.theRevealView.theRevealView];
    
    
    if (self.diyFinishBlock) {
        self.diyFinishBlock(image);
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];

}
- (void)showSelectedColorView
{
    [self.graffitiView showGraffitiColorView];
    
}
- (void)showSelectedbrushView
{
    [self.graffitiView showSelectedbrushView];
    
    self.drawView.isEarse = false;
    
    if (self.drawView.previous_drawColor) {
        self.drawView.current_color = self.drawView.previous_drawColor;
    }
}
- (void)showSelectedEraserView
{
    [self.graffitiView showSelectedEraserView];
    self.drawView.isEarse = true;
    self.drawView.current_color = [UIColor clearColor];
}


#pragma mark - setter
- (void)setDrawColor:(UIColor *)drawColor
{
    _drawColor = drawColor;
    
    self.drawView.current_color = self.drawColor;
}

- (void)setDrawSize:(CGFloat)drawSize
{
    _drawSize = drawSize;
    
    self.drawView.current_size = self.drawSize;
    
}

#pragma mark - getter
- (SDGraffitiEditPhotoControllerItemsView *)graffitiView
{
    if (!_graffitiView) {
        SDGraffitiEditPhotoControllerItemsView * theView = [[SDGraffitiEditPhotoControllerItemsView alloc] init];
        theView.frame = (CGRect){{0,SCREENH_HEIGHT - theView.frame.size.height},theView.frame.size};
        
        [self.view addSubview:theView];
        _graffitiView = theView;
    }
    return _graffitiView;
}

- (SDRevealView *)theRevealView
{
    if (!_theRevealView) {
        SDRevealView * theView = [[SDRevealView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT - MAXSize(466))];
        [self.view addSubview:theView];
        _theRevealView = theView;
    }
    return _theRevealView;
}

- (SDDrawingView *)drawView
{
    if (!_drawView) {
        SDDrawingView * theView = [[SDDrawingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT - self.graffitiView.frame.size.height - MAXSize(132))];
        
        theView.backgroundColor = [UIColor clearColor];
        [self.theRevealView addTargetView:theView];
        _drawView = theView;
    }
    return _drawView;
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
