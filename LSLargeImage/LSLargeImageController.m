//
//  QYLLargeImageController.m
//  PersonBike
//
//  Created by Marshal on 2017/12/27.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "LSLargeImageController.h"

@interface LSLargeImageController ()<UIScrollViewDelegate>
{
    NSString *_image;
    float _currentScale;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LSLargeImageController

- (instancetype)initWithImage:(NSString *)image {
    if (self = [super init]) {
        _image = image;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;//设置为透明背景模式
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContentView];
    [self initGesture];
}

- (void)initContentView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.tag = 14;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.maximumZoomScale = 8;
    _scrollView.minimumZoomScale = 1;
    [_scrollView setZoomScale:1];
    _scrollView.delegate = self;
    _scrollView.contentSize = self.view.frame.size;
    [self.view addSubview:_scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.userInteractionEnabled = YES;
    imageView.tag = 15;
    imageView.image = [UIImage imageNamed:_image];
    imageView.center = self.view.center;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:imageView];
    _currentScale = 1;
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)initGesture {
    UIView *imageView = [_scrollView viewWithTag:15];
    if (!imageView) return;
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickToSigleTap:)];
    sigleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:sigleTap];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickToDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [sigleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)onClickToSigleTap:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickToDoubleTap:(UITapGestureRecognizer *)sender {
    if (_currentScale >= 1 && _currentScale <= 2) {
        _currentScale *= 2;
    }else {
        _currentScale = 1;
    }
    [_scrollView setZoomScale:_currentScale animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:15];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *iv = [scrollView viewWithTag:15];
    CGRect frame = iv.frame;
    frame.origin.y = (scrollView.frame.size.height - iv.frame.size.height) > 0 ? (scrollView.frame.size.height - iv.frame.size.height) * 0.5 : 0;
    frame.origin.x = (scrollView.frame.size.width - iv.frame.size.width) > 0 ? (scrollView.frame.size.width - iv.frame.size.width) * 0.5 : 0;
    iv.frame = frame;
    scrollView.contentSize = CGSizeMake(iv.frame.size.width, iv.frame.size.height);
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:self animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
