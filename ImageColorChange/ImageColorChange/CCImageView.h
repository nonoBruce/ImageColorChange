//
//  CCImageView.h
//  ImageColorChange
//
//  Created by bruce on 15/9/4.
//  Copyright (c) 2015年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCImageView : UIImageView


@property(nonatomic, assign) int tolorance;//容差


@property(nonatomic, strong) UIColor *contentColor;

@property(nonatomic, strong) UIColor *borderColor;


//添加手势
- (void)addGesture;


@end
