//
//  CCImageView.m
//  ImageColorChange
//
//  Created by bruce on 15/9/4.
//  Copyright (c) 2015年 bruce. All rights reserved.
//

#import "CCImageView.h"
#import "UIImage+ChangeColor.h"
@implementation CCImageView

- (void)addGesture{
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
}
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer {
    //    NSLog(@"Pinch scale: %f", recognizer.scale);
}

- (void)tapGesture:(UIGestureRecognizer *)gesture{
    //Get touch Point
    CGPoint point = [gesture locationInView:self];
    //    self.isBack = NO;
    //Convert Touch Point to pixel of Image//点击的点  转换为像素点
    //This code will be according to your need
    //基数为320. 850为图片的宽和高
    //    int width = [UIScreen mainScreen].bounds.size.width;
    
    CGImageRef imageRef = self.image.CGImage;
    //获取原图的宽高
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    point.x = point.x *width/self.frame.size.width;
    point.y = point.y *height/self.frame.size.width;
    
    [self clickWithPoint:point];
    
}

- (void)clickWithPoint:(CGPoint )point {
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        __block UIImage *image1 = nil;
        image1 = [self.image contentWithColor:self.contentColor borderColor:self.borderColor];
        [self setImage:image1];
    });
}

@end
