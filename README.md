# JAModule
##UIScrollView的一个分类->多组件->性能测试。

##*UC下拉
![UC下拉刷新.gif](http://upload-images.jianshu.io/upload_images/2556623-175385259aec6ee3.gif?imageMogr2/auto-orient/strip)
```
/**
 *  让头部view不置顶
 */
@property (nonatomic ,assign) BOOL isNavgation;
@property (nonatomic ,assign) ja_headerType headerType;
/**
 *  下拉放大+刷新
 *
 *  @param image 背景图
 *  @param rect  位置
 */
-(void)ja_pullRefreshDefaultHeader:(UIImage *)image HeaderRect:(CGRect )rect;
/**
 *  UC主页下拉刷新
 *
 *  @param rect 位置
 */
-(void)ja_pullRefreshUC_Header:(CGRect)rect;
```
![pic.png](http://upload-images.jianshu.io/upload_images/2556623-1ebaa900ebecfaf9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
##*下拉放大图片
![下拉放大.gif](http://upload-images.jianshu.io/upload_images/2556623-75cd7860f068958f.gif?imageMogr2/auto-orient/strip)
##*切圆性能测试(3种方法)
```
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
```
![Snip20170222_1.png](http://upload-images.jianshu.io/upload_images/2556623-c6487f24f46d29df.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
