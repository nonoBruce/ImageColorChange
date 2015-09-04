//
//  UIImage+ChangeColor.h
//  ColorChange
//
//  Created by bruce on 15/9/4.
//  Copyright (c) 2015年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ChangeColor)

- (UIImage *) contentWithColor:(UIColor *)contentColor borderColor:(UIColor *)borderColor;

@end
