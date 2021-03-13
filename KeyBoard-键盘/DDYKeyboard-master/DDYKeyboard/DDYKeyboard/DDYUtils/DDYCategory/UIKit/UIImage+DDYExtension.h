#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDYImageType) {
    DDYImageTypeUnknown = 0, // unknown
    DDYImageTypeJPEG,        // jpeg, jpg
    DDYImageTypeJPEG2000,    // jp2
    DDYImageTypeTIFF,        // tiff, tif
    DDYImageTypeBMP,         // bmp
    DDYImageTypeICO,         // ico
    DDYImageTypeICNS,        // icns
    DDYImageTypeGIF,         // gif
    DDYImageTypePNG,         // png
    DDYImageTypeWebP,        // webp
    DDYImageTypeOther,       // other image format
};

CG_EXTERN DDYImageType DDYImageDetectType(CFDataRef data);

@interface UIImage (DDYExtension)
/** 绘制矩形图片 */
+ (UIImage *)ddy_RectImageWithColor:(UIColor *)color size:(CGSize)size;

/** 绘制矩形框 */
+ (UIImage *)ddy_RectBorderWithColor:(UIColor *)color size:(CGSize)size;

/** 绘制圆形图片 */
+ (UIImage *)ddy_CircleImageWithColor:(UIColor *)color radius:(CGFloat)radius;

/** 绘制圆形框 */
+ (UIImage *)ddy_CircleBorderWithColor:(UIColor *)color radius:(CGFloat)radius;

/** 绘制渐变色图片 */
+ (UIImage *)ddy_GradientImage:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

/** 获取图片类型 */
+ (DDYImageType)ddy_ImageDetectType:(NSData *)imageData;

/** 获取图片元数据 */
+ (NSDictionary *)ddy_ImageMetaData:(NSData *)imageData;

/** 获取jpg格式图片元数据 */
- (NSDictionary *)ddy_JpgMetaData;

/** 获取png格式图片元数据 */
- (NSDictionary *)ddy_PngmetaData;

/** 改变亮度、饱和度、对比度 如果某个属性不想修改传-2 */
- (UIImage *)ddy_changeBright:(CGFloat)b saturation:(CGFloat)s contrast:(CGFloat)c;

/** 改变图片亮度 [-1, 1] 数越大越亮 */
- (UIImage *)ddy_ChangeBright:(CGFloat)bright;

/** 改变图片饱和度 [0, 2] */
- (UIImage *)ddy_ChangeSaturation:(CGFloat)saturation;

/** 改变图片对比度 [0, 4] */
- (UIImage *)ddy_ChangeContrast:(CGFloat)contrast;

/** 拍照后图片旋转或者颠倒解决 */
- (UIImage *)ddy_fixOrientation;

/** 根据coreImage 滤镜名称为原图加滤镜 */
- (UIImage *)ddy_FilterWithFilterName:(NSString *)filterName;

@end
