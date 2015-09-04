//
//  ViewController.m
//  ImageColorChange
//
//  Created by bruce on 15/9/4.
//  Copyright (c) 2015年 bruce. All rights reserved.
//

#import "ViewController.h"
#import "CCImageView.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CCImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 100;
    
    
    
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGesture];
    self.imageView.tolorance = 40;
    self.imageView.contentColor = [UIColor whiteColor];
    self.imageView.borderColor = [UIColor blackColor];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - scroolview delegate
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


#pragma mark - localshare
- (IBAction)localShare:(id)sender {
    
    UIImage *image = self.imageView.image;
    UIImage *imageToShare = image;
    //    NSArray *activityItems = @[textToShare, imageToShare,urlToShare];
    NSArray *activityItems = @[imageToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    //    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
    //
    //
    //
    //    }];
    
    
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage,UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

@end
