//
//  UIImage+ChangeColor.m
//  ColorChange
//
//  Created by bruce on 15/9/4.
//  Copyright (c) 2015年 bruce. All rights reserved.
//

//#define NOCHANGECOLOR            



#import "UIImage+ChangeColor.h"


@implementation UIImage (ChangeColor)


//这边的point是像素点的位置
- (UIImage *) floodFillFromPoint:(CGPoint)startPoint withColor:(UIColor *)newColor andTolerance:(int)tolerance useAntiAlias:(BOOL)antiAlias
{
    @try
    {
        /*
         1、把UIImage 转为 NSData
         First We create rowData from UIImage.
         We require this conversation so that we can use detail at pixel like color at pixel.
         You can get some discussion about this topic here:
         http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
         */
        
        
        CGImageRef imageRef = [self CGImage];
        //获取原图的宽高
        NSUInteger width = CGImageGetWidth(imageRef);
        NSUInteger height = CGImageGetHeight(imageRef);
        
        
        /*这样创建的方式可能会比实际的大，修改方式查看
         //http://stackoverflow.com/questions/10685276/iphone-ios-saving-data-obtained-from-uiimagejpegrepresentation-fails-second-ti
         */
        //        NSData *imageDataO = UIImagePNGRepresentation(self);
        //        unsigned char *imageData = malloc(imageDataO.length);
        //        memset(imageData,0,sizeof(char)*imageDataO.length);
        
        
        NSUInteger bytesPerPixel = 4;
        unsigned char *imageData = malloc(height * width * bytesPerPixel);
        memset(imageData,0,sizeof(char)*height * width * bytesPerPixel);
        
        
        NSUInteger bytesPerRow = CGImageGetBytesPerRow(imageRef);
        NSUInteger bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        if (kCGImageAlphaLast == (uint32_t)bitmapInfo || kCGImageAlphaFirst == (uint32_t)bitmapInfo) {
            bitmapInfo = (uint32_t)kCGImageAlphaPremultipliedLast;
        }
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef context = CGBitmapContextCreate(imageData,
                                                     width,
                                                     height,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorSpace,
                                                     bitmapInfo);
        CGColorSpaceRelease(colorSpace);
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        
        //Get color at start point
        unsigned int byteIndex = (bytesPerRow * roundf(startPoint.y)) + roundf(startPoint.x) * bytesPerPixel;
        unsigned int ocolor = getColorCode(byteIndex, imageData);
        NSLog(@"oclor = %zd",ocolor);
        
        //Convert newColor to RGBA value so we can save it to image.
        int newRed, newGreen, newBlue, newAlpha;
        //Returns the values of the color components (including alpha) associated with a Quartz color.
        const CGFloat *components = CGColorGetComponents(newColor.CGColor);
        
        /*
         If you are not getting why I use CGColorGetNumberOfComponents than read following link:
         http://stackoverflow.com/questions/9238743/is-there-an-issue-with-cgcolorgetcomponents
         */
        
        if(CGColorGetNumberOfComponents(newColor.CGColor) == 2) {//白色或者黑色
            newRed   = newGreen = newBlue = components[0] * 255;
            newAlpha = components[1] * 255;
        }
        else if (CGColorGetNumberOfComponents(newColor.CGColor) == 4) {
            if ((bitmapInfo&kCGBitmapByteOrderMask) == kCGBitmapByteOrder32Little) {
                newRed   = components[2] * 255;
                newGreen = components[1] * 255;
                newBlue  = components[0] * 255;
                newAlpha = 255;
            }
            else { //一般情况下是这个
                newRed   = components[0] * 255;
                newGreen = components[1] * 255;
                newBlue  = components[2] * 255;
                newAlpha = 255;
            }
        }
        
        for(int i=0;i<width;i++){
            for(int j=0;j<height;j++){
                byteIndex = (bytesPerRow * roundf(j)) + roundf(i) * bytesPerPixel;

                unsigned int ocolor = getColorCode(byteIndex, imageData);
                if (compareColor(ocolor, 0, 100)){
                    //
                    imageData[byteIndex + 0] = 0;
                    imageData[byteIndex + 1] = 0;
                    imageData[byteIndex + 2] = 0;
                    imageData[byteIndex + 3] = 1;
                }else{
                    imageData[byteIndex + 0] = newRed;
                    imageData[byteIndex + 1] = newGreen;
                    imageData[byteIndex + 2] = newBlue;
                    imageData[byteIndex + 3] = newAlpha;
                }
                
                
                

            }
            
            
        }

        
        
        
        
        
        return [self resultWithContext:context andImageData:imageData];
    }
    @catch (NSException *exception) {
        //        NSLog(@"Exception : %@", exception);
    }
}

- (UIImage *) contentWithColor:(UIColor *)contentColor borderColor:(UIColor *)borderColor {
    @try
    {
        /*
         1、把UIImage 转为 NSData
         First We create rowData from UIImage.
         We require this conversation so that we can use detail at pixel like color at pixel.
         You can get some discussion about this topic here:
         http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
         */
        
        
        CGImageRef imageRef = [self CGImage];
        //获取原图的宽高
        NSUInteger width = CGImageGetWidth(imageRef);
        NSUInteger height = CGImageGetHeight(imageRef);
        
        
        /*这样创建的方式可能会比实际的大，修改方式查看
         //http://stackoverflow.com/questions/10685276/iphone-ios-saving-data-obtained-from-uiimagejpegrepresentation-fails-second-ti
         */
        //        NSData *imageDataO = UIImagePNGRepresentation(self);
        //        unsigned char *imageData = malloc(imageDataO.length);
        //        memset(imageData,0,sizeof(char)*imageDataO.length);
        
        
        NSUInteger bytesPerPixel = 4;
        unsigned char *imageData = malloc(height * width * bytesPerPixel);
        memset(imageData,0,sizeof(char)*height * width * bytesPerPixel);
        
        
        NSUInteger bytesPerRow = CGImageGetBytesPerRow(imageRef);
        NSUInteger bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        if (kCGImageAlphaLast == (uint32_t)bitmapInfo || kCGImageAlphaFirst == (uint32_t)bitmapInfo) {
            bitmapInfo = (uint32_t)kCGImageAlphaPremultipliedLast;
        }
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef context = CGBitmapContextCreate(imageData,
                                                     width,
                                                     height,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorSpace,
                                                     bitmapInfo);
        CGColorSpaceRelease(colorSpace);
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        
        //Get color at start point
        unsigned int byteIndex = 0;
        //
        NSDictionary *contentDic = [self getColor:contentColor andCGBitmapInfo:bitmapInfo];
        NSDictionary *borderDic = [self getColor:borderColor andCGBitmapInfo:bitmapInfo];
        NSDictionary *dic = contentDic;
        
        for(int i=0;i<width;i++){
            for(int j=0;j<height;j++){
                byteIndex = (bytesPerRow * roundf(j)) + roundf(i) * bytesPerPixel;
                
                unsigned int ocolor = getColorCode(byteIndex, imageData);
                if(compareColor(ocolor, getColorCodeFromUIColor([UIColor blackColor], bitmapInfo), 0)){//原图边界为黑色
                    dic = borderDic;
                }
                else if (compareColor(ocolor,0 , 100)){//原图边界为白色
                    dic = borderDic;
                }
                else{
                    dic = contentDic;
                }
                
                imageData[byteIndex + 0] = [[dic objectForKey:@"red"] integerValue];
                imageData[byteIndex + 1] = [[dic objectForKey:@"green"] integerValue];
                imageData[byteIndex + 2] = [[dic objectForKey:@"blue"] integerValue];
                imageData[byteIndex + 3] = [[dic objectForKey:@"alpha"] integerValue];
                
            }
        }
        return [self resultWithContext:context andImageData:imageData];
    }
    @catch (NSException *exception) {
        //        NSLog(@"Exception : %@", exception);
    }
}

- (NSDictionary *)getColor:(UIColor *)color andCGBitmapInfo:(CGBitmapInfo )bitmapInfo{
    //Convert newColor to RGBA value so we can save it to image.
    
    
    int newRed, newGreen, newBlue, newAlpha;
    //Returns the values of the color components (including alpha) associated with a Quartz color.
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    /*
     If you are not getting why I use CGColorGetNumberOfComponents than read following link:
     http://stackoverflow.com/questions/9238743/is-there-an-issue-with-cgcolorgetcomponents
     */
    
    if(CGColorGetNumberOfComponents(color.CGColor) == 2) {//白色或者黑色
        newRed   = newGreen = newBlue = components[0] * 255;
        newAlpha = components[1] * 255;
    }
    else if (CGColorGetNumberOfComponents(color.CGColor) == 4) {
        if ((bitmapInfo&kCGBitmapByteOrderMask) == kCGBitmapByteOrder32Little) {
            newRed   = components[2] * 255;
            newGreen = components[1] * 255;
            newBlue  = components[0] * 255;
            newAlpha = 255;
        }
        else { //一般情况下是这个
            newRed   = components[0] * 255;
            newGreen = components[1] * 255;
            newBlue  = components[2] * 255;
            newAlpha = 255;
        }
    }
    NSNumber *rNum = [NSNumber numberWithInt:newRed];
    NSNumber *gNum = [NSNumber numberWithInt:newGreen];
    NSNumber *bNum = [NSNumber numberWithInt:newBlue];
    NSNumber *aNum = [NSNumber numberWithInt:newAlpha];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         rNum,@"red",
                         gNum,@"green",
                         bNum,@"blue",
                         aNum,@"alpha",
                         nil];
    return dic;
    
}


#pragma mark - help

/**
 *Convert Flood filled image row data back to UIImage object.
 *把rowdata转为UIImage
 */
-(UIImage *)resultWithContext:(CGContextRef)context andImageData:(unsigned char *)imageData {
    //Convert Flood filled image row data back to UIImage object.
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:newCGImage scale:[self scale] orientation:UIImageOrientationUp];
    CGImageRelease(newCGImage);
    CGContextRelease(context);
    free(imageData);
    
    
    
    return result;
}

/*
 I have used pure C function because it is said than C function is faster than Objective - C method in call.
 This two function are called most of time so it require that calling this work in speed.
 I have not verified this performance so I like to here comment on this.
 */
/*
 This function extract color from image and convert it to integer represent.
 
 Converting to integer make comperation easy.
 把图像转为int型进行比较
 */
unsigned int getColorCode (unsigned int byteIndex, unsigned char *imageData) {
    
    unsigned int red   = imageData[byteIndex];
    unsigned int green = imageData[byteIndex + 1];
    unsigned int blue  = imageData[byteIndex + 2];
    unsigned int alpha = imageData[byteIndex + 3];
    
    return (red << 24) | (green << 16) | (blue << 8) | alpha;
}

/*
 *   This function compare two color with counting tolerance value.
 *
 *   If color is between tolerance rancge than it return true other wise false.
 *   比较两个颜色的是否 小于容差值，小于返回false，大于返回true
 */
bool compareColor (unsigned int color1, unsigned int color2, int tolorance)
{
    if(color1 == color2)
        return true;
    
    int red1   = ((0xff000000 & color1) >> 24);//获取最高两位的数值
    int green1 = ((0x00ff0000 & color1) >> 16);
    int blue1  = ((0x0000ff00 & color1) >> 8);
    int alpha1 =  (0x000000ff & color1);
    
    int red2   = ((0xff000000 & color2) >> 24);
    int green2 = ((0x00ff0000 & color2) >> 16);
    int blue2  = ((0x0000ff00 & color2) >> 8);
    int alpha2 =  (0x000000ff & color2);
    
    int diffRed   = abs(red2   - red1);
    int diffGreen = abs(green2 - green1);
    int diffBlue  = abs(blue2  - blue1);
    int diffAlpha = abs(alpha2 - alpha1);
    
    if( diffRed   > tolorance ||
       diffGreen > tolorance ||
       diffBlue  > tolorance ||
       diffAlpha > tolorance  ) {//表示在容差范围外了
        return false;
    }
    
    return true;
}


/**
 *  Convert newColor to RGBA value so we can save it to image.
 *  把UIColor转变为RGBA用户存储图像
 */
unsigned int getColorCodeFromUIColor(UIColor *color, CGBitmapInfo orderMask)
{
    //Convert newColor to RGBA value so we can save it to image.
    int newRed, newGreen, newBlue, newAlpha;
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    /*
     If you are not getting why I use CGColorGetNumberOfComponents than read following link:
     http://stackoverflow.com/questions/9238743/is-there-an-issue-with-cgcolorgetcomponents
     */
    //    [UIColor whiteColor] and [UIColor blackColor] use [UIColor colorWithWhite:alpha:] to create the UIColor. Which means this CGColorRef has only 2 color components, not 4 like colors created with [UIColor colorWithRed:green:blue:alpha:].
    //表示白色和黑色是使用[UIColor colorWithWhite:alpha:]来创建的。因此components只有2个颜色值。
    //
    
    if(CGColorGetNumberOfComponents(color.CGColor) == 2)//白色和黑色
    {
        newRed   = newGreen = newBlue = components[0] * 255;
        newAlpha = components[1] * 255;
    }
    else if (CGColorGetNumberOfComponents(color.CGColor) == 4)//其他颜色
    {
        if (orderMask == kCGBitmapByteOrder32Little)
        {
            newRed   = components[2] * 255;
            newGreen = components[1] * 255;
            newBlue  = components[0] * 255;
            newAlpha = 255;
        }
        else
        {
            newRed   = components[0] * 255;
            newGreen = components[1] * 255;
            newBlue  = components[2] * 255;
            newAlpha = 255;
        }
    }
    else
    {
        newRed   = newGreen = newBlue = 0;
        newAlpha = 255;
    }
    //int  4字节 32bit，每8位作为 一个颜色值
    unsigned int ncolor = (newRed << 24) | (newGreen << 16) | (newBlue << 8) | newAlpha;
    
    return ncolor;
}
@end
