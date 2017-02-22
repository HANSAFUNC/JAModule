//
//  ClipCornerController.m
//  JKHeaderImageScale
//
//  Created by jackey_gjt on 17/2/22.
//  Copyright © 2017年 Jackey. All rights reserved.
//

#import "ClipCornerController.h"

@interface ClipCornerController ()
@property (nonatomic, strong) UIImageView *imageV1;
@property (nonatomic, strong) UIImageView *imageV2;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic ,strong) UIButton * clipCornerButton;
@property (nonatomic ,strong) NSString * clipTypeStr;
@property (nonatomic ,assign) ClipCornerType type;
@end

@implementation ClipCornerController


-(instancetype)initWithClipCornerType:(ClipCornerType)type {
    self = [super init];
    if(self)
    {
        self.type = type;
        if (self.type == ClipCornerTypeCustom) {
            self.clipTypeStr = @"自定义裁剪";
        }else if (self.type == ClipCornerTypeBezier){
            self.clipTypeStr = @"贝尔赛斯";
        }else if (self.type == ClipCornerTypeDraw){
            self.clipTypeStr = @"DrawRect";
        }
        
        
    }
    return self;
}

-(UIButton *)clipCornerButton{
    
    if (_clipCornerButton == nil) {
        _clipCornerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clipCornerButton setTitle:self.clipTypeStr forState:UIControlStateNormal];
        _clipCornerButton.backgroundColor = [UIColor whiteColor];
        [_clipCornerButton setTitleColor:[UIColor blackColor] forState:0];
        _clipCornerButton.layer.borderWidth = 1.0;
        _clipCornerButton.layer.borderColor = [UIColor blackColor].CGColor;
        [_clipCornerButton addTarget:self action:@selector(clipCornerAction) forControlEvents:UIControlEventTouchUpInside];
        _clipCornerButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2, 560, 100, 30);
    }
    return _clipCornerButton;
}
- (UIImageView *)imageV1 {
    if (_imageV1 == nil) {
        _imageV1 = [[UIImageView alloc] init];
        _imageV1.contentMode = UIViewContentModeScaleAspectFit;
        _imageV1.layer.borderColor = [UIColor blackColor].CGColor;
        _imageV1.layer.borderWidth = 1.0;
        _imageV1.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, 100, 200, 200);
    }
    return _imageV1;
}

- (UIImageView *)imageV2 {
    if (_imageV2 == nil) {
        _imageV2 = [[UIImageView alloc] init];
        _imageV2.contentMode = UIViewContentModeScaleAspectFit;
        _imageV2.layer.borderColor = [UIColor blackColor].CGColor;
        _imageV2.layer.borderWidth = 1.0;
        _imageV2.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, 350, 200, 200);
    }
    return _imageV2;
}

- (UILabel *)label1 {
    if (_label1 == nil) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"原图";
        _label1.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40)/2, 70, 40, 20);
    }
    return _label1;
}

- (UILabel *)label2 {
    if (_label2 == nil) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"结果图";
        _label2.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-70)/2, 320, 70, 20);
    }
    return _label2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:self.label1];
    [self.view addSubview:self.imageV1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.imageV2];
    [self.view addSubview:self.clipCornerButton];
    UIImage *image = [UIImage imageNamed:@"timg"];
    self.imageV1.image = image;
    
}

static int count = 3000;               // 1万次调用测试
static NSString *imgName = @"timg";     // 512 * 512,
static CGFloat radius = 256;
/**
    3000次的真机数据
 *  BezierPath裁剪用时：50.092 秒
 *  Draw裁剪用时：49.859 秒
 *  算法裁剪用时：71.106 秒
 
 *
 */

-(void)clipCornerAction{
    if (self.type == ClipCornerTypeCustom) {
        
        self.imageV2.image = [self dealImage:[UIImage imageNamed:imgName] cornerRadius:radius];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSLog(@"%@",[NSThread currentThread]);
            [self test1];
        });
        
    }else if (self.type == ClipCornerTypeBezier){
        self.imageV2.image = [self UIBezierPathClip:[UIImage imageNamed:imgName] cornerRadius:radius];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%@",[NSThread currentThread]);
            [self test3];
            
        });
        
    }else if (self.type == ClipCornerTypeDraw){
        self.imageV2.image = [self CGContextClip:[UIImage imageNamed:imgName] cornerRadius:radius];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%@",[NSThread currentThread]);
            [self test2];
        });
        
    }
    
}

#define IMGWIDTH  512
#define IMGHEIGHT 512
#define PASSCOUNT 4
//测试
void test(){
    
    //    int a[4][IMGWIDTH]={{1,2},
    //                        {5,3},
    //                        {2,3},
    //                        {4,6}
    //                     };
    
    //    {0,1,2,3}
    int a[IMGHEIGHT][IMGWIDTH][PASSCOUNT];
    for (int j=0; j<IMGWIDTH; j++) {
        for (int k=0; k<IMGWIDTH; k++) {
            for (int S=0;S<PASSCOUNT; S++) {
                
                a[j][k][S]=S+k;
                
            }
        }
    }
    
    //    4 * 512 * 512;
    int *p =&a[0][0][0];
    int *c =&a[1][0][0];
    int *b = p+512;
    
    printf("%d %d",*b,*c);
    
    
    
}
-(void)test1 {
    UIImage *image = [UIImage imageNamed:imgName];
    
    NSLog(@"---start");
    time_t t1 = clock();
    for (int i=0; i<count; i++) {
        [self dealImage:image cornerRadius:radius];
    }
    time_t t2 = clock();
    NSLog(@"算法裁剪用时：%.3f 秒", ((float)(t2 - t1)) / CLOCKS_PER_SEC);
}

-(void)test2 {
    UIImage *image = [UIImage imageNamed:imgName];
    
    NSLog(@"---start");
    time_t t1 = clock();
    for (int i=0; i<count; i++) {
        [self CGContextClip:image cornerRadius:radius];
    }
    time_t t2 = clock();
    NSLog(@"Draw裁剪用时：%.3f 秒", ((float)(t2 - t1)) / CLOCKS_PER_SEC);
}
-(void)test3{
    UIImage *image = [UIImage imageNamed:imgName];
    
    NSLog(@"---start");
    time_t t1 = clock();
    for (int i=0; i<count; i++) {
        [self UIBezierPathClip:image cornerRadius:radius];
    }
    time_t t2 = clock();
    NSLog(@"BezierPath裁剪用时：%.3f 秒", ((float)(t2 - t1)) / CLOCKS_PER_SEC);
}


- (UIImage *)CGContextClip:(UIImage *)img cornerRadius:(CGFloat)radius {
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, radius);
    CGContextAddArcToPoint(context, 0, 0, radius, 0, radius);
    CGContextAddLineToPoint(context, w-radius, 0);
    CGContextAddArcToPoint(context, w, 0, w, radius, radius);
    CGContextAddLineToPoint(context, w, h-radius);
    CGContextAddArcToPoint(context, w, h, w-radius, h, radius);
    CGContextAddLineToPoint(context, radius, h);
    CGContextAddArcToPoint(context, 0, h, 0, h-radius, radius);
    CGContextAddLineToPoint(context, 0, radius);
    CGContextClosePath(context);
    
    CGContextClip(context);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}

// UIBezierPath 裁剪
- (UIImage *)UIBezierPathClip:(UIImage *)img cornerRadius:(CGFloat)radius {
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    CGRect rect = CGRectMake(0, 0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [img drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 自定义裁剪算法
- (UIImage *)dealImage:(UIImage *)img cornerRadius:(CGFloat)c {
    // CGImage 转 二进制流
    CGDataProviderRef provider = CGImageGetDataProvider(img.CGImage);
    void *imgData = (void *)CFDataGetBytePtr(CGDataProviderCopyData(provider));
    int width = img.size.width * img.scale;
    int height = img.size.height * img.scale;

    cornerImage(imgData, width, height, c);
    
    CGDataProviderRef pv = CGDataProviderCreateWithData(NULL, imgData, width * height * 4, releaseData);
    /**
     *  @width                       宽
     *  @ height                      高
     *  @ 8                           8比特
     *  @ 32                          32位
     *  @ bytesPerRow                 每行字节数 1字节=8比特
     *  @ CGColorSpaceCreateDeviceRGB
     *
     */
    CGImageRef content = CGImageCreate(width , height, 8, 32, 4 * width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, pv, NULL, true, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:content];
    CGDataProviderRelease(pv);      // 释放空间
    CGImageRelease(content);
    
    return image;
}

void releaseData(void *info, const void *data, size_t size) {
    free((void *)data);
    
}


/**
 *  像素分布
 *     _____
 *    |2 2 2|
 *    |2 5 2|
 *    |2 2 2|
 *    -------
 处理灰度 大约在100px左右
 
 */
void cornerImage(uint32_t *const img, int w, int h, CGFloat cornerRadius) {
    CGFloat c = cornerRadius;
    CGFloat min = w > h ? h : w;
    
    if (c < 0) { c = 0; }
    if (c > min * 0.5) { c = min * 0.5; }
    
    // 左上 y:[0, c), x:[x, c-y)
    for (int y=0; y<c; y++) {
        for (int x=0; x<c-y; x++) {
            uint32_t *p = img + y * w + x;
            if (isCircle(c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右上 y:[0, c), x:[w-c+y, w)
    int tmp = w-c;
    for (int y=0; y<c; y++) {
        for (int x=tmp+y; x<w; x++) {
            uint32_t *p = img + y * w + x;
            if (isCircle(w-c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 左下 y:[h-c, h), x:[0, y-h+c)
    tmp = h-c;
    for (int y=h-c; y<h; y++) {
        for (int x=0; x<y-tmp; x++) {
            uint32_t *p = img + y * w + x;
            if (isCircle(c, h-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右下 y~[h-c, h), x~[w-c+h-y, w)
    tmp = w-c+h;
    for (int y=h-c; y<h; y++) {
        for (int x=tmp-y; x<w; x++) {
            uint32_t *p = img + y * w + x;
            if (isCircle(w-c, h-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
}
//d=√[(x1-x2)²+(y1-y2)²] 公式

static inline bool isCircle(float cx, float cy, float r, float px, float py) {
    if ((px-cx) * (px-cx) + (py-cy) * (py-cy) > r * r) {
        return false;
    }
    return true;
}



@end
