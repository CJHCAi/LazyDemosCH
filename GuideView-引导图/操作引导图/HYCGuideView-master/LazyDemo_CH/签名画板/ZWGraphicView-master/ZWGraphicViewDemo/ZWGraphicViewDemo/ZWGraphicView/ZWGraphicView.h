//
//  ZWGraphicView.h
//  TestDemo
//
//  Created by xzw on 16/10/26.
//  Copyright © 2016年 xzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWGraphicView : UIView
{
    CGPoint _start;//起始点
    CGPoint _move;//移动点
    CGMutablePathRef _path;//路径
    NSMutableArray * _pathArray;//保存路径信息
    CGFloat _lineWidth;//线宽
    UIColor * _lineColor;//线的颜色
    BOOL _isDrawLine;//是否有画线
}

/**
 *  线宽
 */
@property (nonatomic,assign) CGFloat  lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic,strong) UIColor * lineColor;
/**
 *  画线路径
 */
@property (nonatomic,strong) NSMutableArray * pathArray;

/**
 *  获取画图
 */
-(UIImage*)getDrawingImg;

/**
 *  清空画板
 */
-(void)clearDrawBoard;

/**
 *  撤销上一次操作
 */
-(void)undoLastDraw;

/**
 *  保存图像至相册
 */
-(void)savePhotoToAlbum;


@end
