//
//  WSGScrollView.m
//  WSGScrollView
//
//  Created by user on 16/1/27.
//  Copyright © 2016年 user. All rights reserved.
//

#import "WSGScrollView.h"
#import "UIImageView+WebCache.h"

@interface WSGScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIImageView *rightImageView;

@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIImage *placeImage;

@property (nonatomic,assign) NSUInteger leftIndex;
@property (nonatomic,assign) NSUInteger centerIndex;
@property (nonatomic,assign) NSUInteger rightIndex;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) BOOL isTimeControl;

@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation WSGScrollView

+ (instancetype)scrollViewWithFrame:(CGRect)frame imageArray:(NSMutableArray *)array placeHolderImage:(NSString *)imageURL pageControlShowStyle:(WSGPageControlShowStyle)pageControlShowStyle
{
    WSGScrollView *wsgScrollView = [[WSGScrollView alloc] initWithFrame:frame];
    
    wsgScrollView.placeImage = [UIImage imageNamed:imageURL];
    wsgScrollView.imageArray = array;
    wsgScrollView.pageControlShowStyle = pageControlShowStyle;
    
    return wsgScrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _scrollTime = 3.0f;//默认的间隔时间为4.0s
        _isAutoScrool = YES;//初始默认为YES
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.leftImageView];
        [self.scrollView addSubview:self.centerImageView];
        [self.scrollView addSubview:self.rightImageView];
        [self addSubview:self.pageControl];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (_isAutoScrool && _imageArray.count > 1) {
        [self startTimer];
    }else
    {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Getter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * 3, CGRectGetHeight(_scrollView.frame));
        _scrollView.delegate = self;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _scrollView;
}

- (UIImageView *)leftImageView
{
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView
{
    if (_centerImageView == nil) {
        
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addGestureRecognizer:self.tapGesture];
        
    }
    return _centerImageView;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (_tapGesture == nil) {
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCLickImage)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        
    }
    return _tapGesture;
}

- (UIImageView *)rightImageView
{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame) * 2, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    }
    return _rightImageView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        
    }
    return _pageControl;
}

#pragma mark - Setter
- (void)setIsAutoScrool:(BOOL)isAutoScrool
{
    _isAutoScrool = isAutoScrool;
    
    if (!isAutoScrool || _imageArray.count < 2) {
        
        [_timer invalidate];
        _timer = nil;
        
    }
}

- (void)setPlaceImage:(UIImage *)placeImage
{
    _placeImage = placeImage;
}

- (void)setPageControlShowStyle:(WSGPageControlShowStyle)pageControlShowStyle
{
    _pageControlShowStyle = pageControlShowStyle;
    
    if (pageControlShowStyle == WSGPageControlShowStyleNone || _imageArray.count < 2) {
        _pageControl.hidden = YES;
        return;
    }
    
    switch (pageControlShowStyle) {
        case WSGPageControlShowStyleCenter:
            _pageControl.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) / 2 - 10 * _imageArray.count, CGRectGetHeight(_scrollView.frame) - 20, 20 * _imageArray.count, 20);
            break;
            
        default:
            break;
    }
    _pageControl.numberOfPages = _imageArray.count;
    _pageControl.currentPage = 0;
    _pageControl.enabled = YES;
}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    
    if (imageArray.count == 0) {
        return;
    }
    
    _leftIndex = imageArray.count - 1;
    _centerIndex = 0;
    _rightIndex = 1;
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:_leftIndex]] placeholderImage:_placeImage];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:_centerIndex]] placeholderImage:_placeImage];
    
    if (imageArray.count == 1) {
        _scrollView.scrollEnabled = NO;
        return;
    }
    
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:_rightIndex]] placeholderImage:_placeImage];
}

#pragma mark - Scrool Method
- (void)startTimer
{
    if (_isAutoScrool && _imageArray.count > 1) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollTime target:self selector:@selector(moveImage) userInfo:nil repeats:YES];
        _isTimeControl = NO;
    }
}

- (void)moveImage
{
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * 2, 0) animated:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
    
    _isTimeControl = YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x == 0) {
        
        _leftIndex = _leftIndex - 1;
        _centerIndex = _centerIndex - 1;
        _rightIndex = _rightIndex - 1;
        
        _leftIndex = _leftIndex == -1 ? _imageArray.count -1 : _leftIndex;
        _centerIndex = _centerIndex == -1 ? _imageArray.count - 1 : _centerIndex;
        _rightIndex = _rightIndex == -1 ? _imageArray.count - 1 : _rightIndex;
        
    }
    else if (_scrollView.contentOffset.x == CGRectGetWidth(_scrollView.frame) * 2) {
        
        _leftIndex = _leftIndex +1;
        _centerIndex = _centerIndex + 1;
        _rightIndex = _rightIndex + 1;
        
        _leftIndex = _leftIndex == _imageArray.count ? 0 : _leftIndex;
        _centerIndex = _centerIndex == _imageArray.count ? 0 : _centerIndex;
        _rightIndex = _rightIndex == _imageArray.count ? 0 : _rightIndex;
        
        
    }else
    {
        return;
    }
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:_leftIndex]] placeholderImage:_placeImage];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:_centerIndex]] placeholderImage:_placeImage];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:_rightIndex]] placeholderImage:_placeImage];
    
    _pageControl.currentPage = _centerIndex;
    
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame), 0)];
    
    if (!_isTimeControl) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollTime]];
    }
    _isTimeControl = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

#pragma mark - ClickImage
- (void)didCLickImage
{
    if (_tapcallbackBlock) {
        _tapcallbackBlock(_centerIndex,[_imageArray objectAtIndex:_centerIndex]);
    }
}

@end