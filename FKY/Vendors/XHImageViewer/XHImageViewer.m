//
//  XHImageViewer.m
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHImageViewer.h"
#import "XHViewState.h"
#import "XHZoomingImageView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

#define UIColorFromRGB(rgbValue)                                      \
([UIColor                                                          \
colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0x00FF00) >> 8)) / 255.0  \
blue:((CGFloat)(rgbValue & 0x0000FF)) / 255.0         \
alpha:1.0])

/*
@interface XHImageViewer ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;    // 分页控件
    NSMutableArray *_curImageArray; // 当前显示的图片数组
    NSInteger _curPage;             // 当前显示的图片位置
    BOOL _isTwiceTaping;            //
}

@property (nonatomic, strong) UIScrollView *scrollView; //
@property (nonatomic, strong) NSArray *imgViews;        // 所有图片数组
@property (nonatomic, strong) NSMutableArray *tmpMArr;  //

@end

@implementation XHImageViewer

- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.backgroundScale = 0.95;
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
//    pan.maximumNumberOfTouches = 1;
//    [self addGestureRecognizer:pan];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)setImageViewsFromArray:(NSArray*)views {
    NSMutableArray *imgViews = [NSMutableArray array];
    for(id obj in views){
        if([obj isKindOfClass:[UIImageView class]]){
            [imgViews addObject:obj];
            UIImageView *view = obj;
            XHViewState *state = [XHViewState viewStateForView:view];
            [state setStateWithView:view];
            
            view.userInteractionEnabled = NO;
        }
    }
    _imgViews = [imgViews copy];
}

- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView {    
    [self setImageViewsFromArray:views];
    
    if (_imgViews.count > 0) {
        if(![selectedView isKindOfClass:[UIImageView class]] || ![_imgViews containsObject:selectedView]){
            selectedView = _imgViews[0];
        }
        [self showWithSelectedView:selectedView];
    }
}

#pragma mark- Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[backgroundColor colorWithAlphaComponent:0]];
}

- (NSInteger)pageIndex {
    return (_scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5);
}

- (NSMutableArray *)tmpMArr {
    if (!_tmpMArr) {
        _tmpMArr = [[NSMutableArray alloc] init];
    }
    return _tmpMArr;
}

#pragma mark- View management

- (UIImageView *)currentView {
    return [_tmpMArr objectAtIndex:self.pageIndex];
    //return _tmpMArr.count > 1 ? [_tmpMArr objectAtIndex:1] : [_tmpMArr objectAtIndex:0];
}

- (void)showWithSelectedView:(UIImageView*)selectedView {
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    const NSInteger currentPage = [_imgViews indexOfObject:selectedView];
    //初始化数据，当前图片默认位置是0
    _curImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    _curPage = 0;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1];
        _scrollView.alpha = 0;
    }
    if (_imgViews.count == 1) {
        _scrollView.scrollEnabled = NO;
    } else {
        _scrollView.scrollEnabled = YES;
    }
    
    [self addSubview:_scrollView];
    [window addSubview:self];
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, 200, 20)];
        _pageControl.numberOfPages = _imgViews.count;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:(169)/255.0f green:(169)/255.0f blue:(169)/255.0f alpha:1];
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xffc343);
        //_pageControl.currentPageIndicatorTintColor = KNavBarColor;
        _pageControl.center = CGPointMake(self.center.x, _pageControl.center.y);
        [self addSubview:_pageControl];
    }
    _pageControl.currentPage = currentPage;
    _curPage = currentPage;
    
    const CGFloat fullW = window.frame.size.width;
    const CGFloat fullH = window.frame.size.height;
    
    selectedView.frame = [window convertRect:selectedView.frame fromView:selectedView.superview];
    [window addSubview:selectedView];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         __strong typeof(self) strongSelf = weakSelf;
                         strongSelf.scrollView.alpha = 1;
                         window.rootViewController.view.transform = CGAffineTransformMakeScale(self.backgroundScale, self.backgroundScale);
                         
                         selectedView.transform = CGAffineTransformIdentity;
                         
                         CGSize size = (selectedView.image) ? selectedView.image.size : selectedView.frame.size;
                         CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
                         CGFloat W = ratio * size.width;
                         CGFloat H = ratio * size.height;
                         selectedView.frame = CGRectMake((fullW-W)/2, (fullH-H)/2, W, H);
                     }
                     completion:^(BOOL finished) {
                         __strong typeof(self) strongSelf = weakSelf;
                         
                         UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView:)];
                         gesture.numberOfTapsRequired = 1;
                         gesture.numberOfTouchesRequired = 1;
                         [strongSelf.scrollView addGestureRecognizer:gesture];
                         
                         // 双击手势
                         UITapGestureRecognizer *tapTwiceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwiceScrollView:)];
                         tapTwiceGesture.numberOfTapsRequired = 2;
                         tapTwiceGesture.numberOfTouchesRequired = 1;
                         [strongSelf.scrollView addGestureRecognizer:tapTwiceGesture];
                         [gesture requireGestureRecognizerToFail:tapTwiceGesture];
                         
                         [self reloadData];
                         if (strongSelf.imgViews.count > 1) {
                             [strongSelf.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
                         }
                     }
     ];
}

- (void)prepareToDismiss {
    UIImageView *currentView = [self currentView];
    
    if ([self.delegate respondsToSelector:@selector(imageViewer:willDismissWithSelectedView:pageIndex:)]) {
        [self.delegate imageViewer:self willDismissWithSelectedView:currentView pageIndex:_curPage];
    }
    
    for (UIImageView *view in _imgViews) {
        if(view != currentView) {
            XHViewState *state = [XHViewState viewStateForView:view];
            view.transform = CGAffineTransformIdentity;
            view.frame = state.frame;
            view.transform = state.transform;
            [state.superview addSubview:view];
        }
    }
}

- (void)dismissWithAnimate {
    UIView *currentView = [self currentView];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect rct = currentView.frame;
    currentView.transform = CGAffineTransformIdentity;
    currentView.frame = [window convertRect:rct fromView:currentView.superview];
    [window addSubview:currentView];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         __strong typeof(self) strongSelf = weakSelf;
                         strongSelf.scrollView.alpha = 0;
                         window.rootViewController.view.transform =  CGAffineTransformIdentity;
                         
                         XHViewState *state = [XHViewState viewStateForView:currentView];
                         currentView.frame = [window convertRect:state.frame fromView:state.superview];
                         currentView.transform = state.transform;
                     }
                     completion:^(BOOL finished) {
                         __strong typeof(self) strongSelf = weakSelf;
                         XHViewState *state = [XHViewState viewStateForView:currentView];
                         currentView.transform = CGAffineTransformIdentity;
                         currentView.frame = state.frame;
                         currentView.transform = state.transform;
                         [state.superview addSubview:currentView];
                         
                         for (UIView *view in strongSelf.imgViews) {
                             XHViewState *_state = [XHViewState viewStateForView:view];
                             view.userInteractionEnabled = _state.userInteratctionEnabled;
                         }

                         [currentView removeFromSuperview];
                         
                         if ([self.delegate respondsToSelector:@selector(imageViewerDidDismissFromSuperView)]) {
                             [self.delegate imageViewerDidDismissFromSuperView];
                         }
                         
                         [self removeFromSuperview];
                     }
     ];
}

#pragma mark- Gesture events

- (void)tappedScrollView:(UITapGestureRecognizer *)sender
{
    if (_isTwiceTaping) {
        return;
    }
    [self prepareToDismiss];
    [self dismissWithAnimate];
}

// 双击放大缩小图片
- (void)tapTwiceScrollView:(UITapGestureRecognizer *)gesture
{
    if (_isTwiceTaping) {
        return;
    }
    _isTwiceTaping = YES;
    
    double touchX = [gesture locationInView:gesture.view].x;
    int i = touchX / self.bounds.size.width;
//    _touchY = [gesture locationInView:gesture.view].y;
    
    XHZoomingImageView *tmp = self.tmpMArr[i];
    CGFloat newScale;
    if (tmp.scrollView.zoomScale > 1.0) {
        // 恢复
        newScale = 1;
    }
    else {
        // 放大
        newScale = 3;
    }
    
    CGRect zoomRect;
    zoomRect.size.height = tmp.scrollView.frame.size.height / newScale;
    zoomRect.size.width  = tmp.scrollView.frame.size.width  / newScale;
    zoomRect.origin.x = [gesture locationInView:gesture.view].x - self.bounds.size.width * i - (zoomRect.size.width  /2);
    zoomRect.origin.y = [gesture locationInView:gesture.view].y - (zoomRect.size.height /2);
    
    [tmp.scrollView zoomToRect:zoomRect animated:YES];
    
    //延时做标记判断，使用户点击3次时的单击效果不生效。
    [self performSelector:@selector(twiceTaping) withObject:nil afterDelay:0.35];
}

- (void)twiceTaping
{
    _isTwiceTaping = NO;
}

- (void)reloadData
{
    self.tmpMArr = nil;
    //设置页数
    _pageControl.currentPage = _curPage;
    //根据当前页取出图片
    [self getDisplayImagesWithCurpage:_curPage];
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.scrollView subviews];
    if ([subViews count] > 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (_imgViews.count == 1) {
        XHZoomingImageView *tmp = [[XHZoomingImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIImageView *view = _imgViews[0];
        view.transform = CGAffineTransformIdentity;
        
        CGSize size = (view.image) ? view.image.size : view.frame.size;
        CGFloat ratio = MIN(SCREEN_WIDTH / size.width, SCREEN_HEIGHT / size.height);
        CGFloat W = ratio * size.width;
        CGFloat H = ratio * size.height;
        view.frame = CGRectMake((SCREEN_WIDTH-W)/2, (SCREEN_HEIGHT-H)/2, W, H);
        
        tmp.imageView = view;
        [self.tmpMArr addObject:tmp];
        [self.scrollView addSubview:tmp];
    }
    else {
        //创建imageView
        for (int i = 0; i < 3; i++) {
            XHZoomingImageView *tmp = [[XHZoomingImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            UIImageView *view = _curImageArray[i];
            view.transform = CGAffineTransformIdentity;
            
            CGSize size = (view.image) ? view.image.size : view.frame.size;
            CGFloat ratio = MIN(SCREEN_WIDTH / size.width, SCREEN_HEIGHT / size.height);
            CGFloat W = ratio * size.width;
            CGFloat H = ratio * size.height;
            view.frame = CGRectMake((SCREEN_WIDTH-W)/2, (SCREEN_HEIGHT-H)/2, W, H);
            
            tmp.imageView = view;
            [self.tmpMArr addObject:tmp];
            [self.scrollView addSubview:tmp];
        }
    }
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page
{
    //取出开头和末尾图片在图片数组里的下标
    NSInteger front = page - 1;
    NSInteger last = page + 1;
    //如果当前图片下标是0，则开头图片设置为图片数组的最后一个元素
    if (page == 0) {
        front = [_imgViews count]-1;
    }
    
    //如果当前图片下标是图片数组最后一个元素，则设置末尾图片为图片数组的第一个元素
    if (page == [_imgViews count]-1) {
        last = 0;
    }
    
    //如果当前图片数组不为空，则移除所有元素
    if ([_curImageArray count] > 0) {
        [_curImageArray removeAllObjects];
    }
    
    //当前图片数组添加图片
    [_curImageArray addObject:_imgViews[front]];
    [_curImageArray addObject:_imgViews[page]];
    [_curImageArray addObject:_imgViews[last]];
}

#pragma mark UIScrollVIewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= SCREEN_WIDTH * 2) {
        //当前图片位置+1
        _curPage++;
        //如果当前图片位置超过数组边界，则设置为0
        if (_curPage == [_imgViews count]) {
            _curPage = 0;
        }
        //刷新图片
        [self reloadData];
        //设置scrollView偏移位置
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }//如果scrollView当前偏移位置x小于等于0
    else if (scrollView.contentOffset.x <= 0) {
        //当前图片位置-1
        _curPage--;
        //如果当前图片位置小于数组边界，则设置为数组最后一张图片下标
        if (_curPage == -1) {
            _curPage = [_imgViews count]-1;
        }
        //刷新图片
        [self reloadData];
        //设置scrollView偏移位置
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}

@end
*/


#pragma mark - 原版代码...<上面修改后的代码动画失效!!!>

@interface XHImageViewer () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView; // scroll容器
@property (nonatomic, strong) NSArray<UIImageView *> *imgViews; // 图片数组

// 新增pageControl
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *lblPageControl;

// 保存图片btn
@property (nonatomic, strong) UIButton *btnSave;

@end


@implementation XHImageViewer

#pragma mark - Init

- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self _setup];
    }
    return self;
}


#pragma mark - Private

- (void)_setup {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.backgroundScale = 0.95;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    pan.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
}

- (void)setImageViewsFromArray:(NSArray *)views {
    NSMutableArray *imgViews = [NSMutableArray array];
    for (id obj in views) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [imgViews addObject:obj];
            
            UIImageView *view = obj;
            XHViewState *state = [XHViewState viewStateForView:view];
            [state setStateWithView:view];
            view.userInteractionEnabled = NO;
        }
    }
    self.imgViews = [imgViews copy];
}

// 显示PageControl
- (void)addPageControl:(NSInteger)currentPage
{
    if (!self.showPageControl) {
        return;
    }
    
    if (self.lblPageControl.superview) {
        [self.lblPageControl removeFromSuperview];
    }
    if (self.pageControl.superview) {
        [self.pageControl removeFromSuperview];
    }
    
    if (self.imgViews.count == 1 && self.hideWhenOnlyOne == YES) {
        // 单张图片时不显示PageControl
    }
    else {
        // 一直显示PageControl
        if (self.userPageNumber) {
            // 使用数字
            [self addSubview:self.lblPageControl];
            [self updatePageNumber:currentPage];
        }
        else {
            // 使用点
            [self addSubview:self.pageControl];
            self.pageControl.currentPage = currentPage;
        }
    }
}

// 显示保存图片按钮
- (void)addSaveBtn
{
    if (!self.showSaveBtn) {
        return;
    }
    
    if (self.btnSave.superview) {
        [self.btnSave removeFromSuperview];
    }
    [self addSubview:self.btnSave];
}

- (void)openSetting
{
    if (iOS10Later()) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


#pragma mark - Public

// 传图片数组
- (void)showWithImageViews:(NSArray *)views selectedView:(UIImageView *)selectedView {
    [self setImageViewsFromArray:views];
    
    if (self.imgViews.count > 0) {
        if (![selectedView isKindOfClass:[UIImageView class]] || ![self.imgViews containsObject:selectedView]) {
            selectedView = self.imgViews[0];
        }
        [self showWithSelectedView:selectedView];
    }
}


#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[backgroundColor colorWithAlphaComponent:0]];
}

- (NSInteger)pageIndex {
    return (self.scrollView.contentOffset.x / self.scrollView.frame.size.width + 0.5);
}


#pragma mark - View management

- (UIImageView *)currentView {
    return [self.imgViews objectAtIndex:self.pageIndex];
}

- (void)showWithSelectedView:(UIImageView *)selectedView {
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self addSubview:self.scrollView];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    // 当前页索引
    const NSInteger currentPage = [self.imgViews indexOfObject:selectedView];
    //
    const CGFloat fullW = window.frame.size.width;
    const CGFloat fullH = window.frame.size.height;
    
    selectedView.frame = [window convertRect:selectedView.frame fromView:selectedView.superview];
    [window addSubview:selectedView];
    @weakify(self);
    [UIView animateWithDuration:0.3
                     animations:^{
        @strongify(self);
                         self.scrollView.alpha = 1;
                         window.rootViewController.view.transform = CGAffineTransformMakeScale(self.backgroundScale, self.backgroundScale);
                         
                         selectedView.transform = CGAffineTransformIdentity;
                         
                         CGSize size = (selectedView.image) ? selectedView.image.size : selectedView.frame.size;
                         CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
                         CGFloat W = ratio * size.width;
                         CGFloat H = ratio * size.height;
                         selectedView.frame = CGRectMake((fullW-W)/2, (fullH-H)/2, W, H);
                     }
                     completion:^(BOOL finished) {
        @strongify(self);
                         self.scrollView.contentSize = CGSizeMake(self.imgViews.count * fullW, 0);
                         self.scrollView.contentOffset = CGPointMake(currentPage * fullW, 0);
                         
                         UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView:)];
                         [self.scrollView addGestureRecognizer:gesture];
                         
                         for(UIImageView *view in self.imgViews){
                             view.transform = CGAffineTransformIdentity;
                             
                             CGSize size = (view.image) ? view.image.size : view.frame.size;
                             CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
                             CGFloat W = ratio * size.width;
                             CGFloat H = ratio * size.height;
                             view.frame = CGRectMake((fullW-W)/2, (fullH-H)/2, W, H);
                             
                             XHZoomingImageView *tmp = [[XHZoomingImageView alloc] initWithFrame:CGRectMake([self.imgViews indexOfObject:view] * fullW, 0, fullW, fullH)];
                             tmp.imageView = view;
                             
                             [self.scrollView addSubview:tmp];
                             
                             [self addPageControl:currentPage];
                             [self addSaveBtn];
                         }
                     }
     ];
}

- (void)prepareToDismiss {
    UIImageView *currentView = [self currentView];
    
    if ([self.delegate respondsToSelector:@selector(imageViewer:willDismissWithSelectedView:pageIndex:)]) {
        [self.delegate imageViewer:self willDismissWithSelectedView:currentView pageIndex:self.pageIndex];
    }
    
    for (UIImageView *view in self.imgViews) {
        if (view != currentView) {
            XHViewState *state = [XHViewState viewStateForView:view];
            view.transform = CGAffineTransformIdentity;
            view.frame = state.frame;
            view.transform = state.transform;
            [state.superview addSubview:view];
        }
    }
}

- (void)dismissWithAnimate {
    UIView *currentView = [self currentView];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect rct = currentView.frame;
    currentView.transform = CGAffineTransformIdentity;
    currentView.frame = [window convertRect:rct fromView:currentView.superview];
    [window addSubview:currentView];
    
    if (self.btnSave.superview) {
        [self.btnSave removeFromSuperview];
    }
    if (self.pageControl.superview) {
        [self.pageControl removeFromSuperview];
    }
    if (self.lblPageControl.superview) {
        [self.lblPageControl removeFromSuperview];
    }
    @weakify(self);
    [UIView animateWithDuration:0.3
                     animations:^{
        @strongify(self);
                         self.scrollView.alpha = 0;
                         window.rootViewController.view.transform =  CGAffineTransformIdentity;
                         
                         XHViewState *state = [XHViewState viewStateForView:currentView];
                         currentView.frame = [window convertRect:state.frame fromView:state.superview];
                         currentView.transform = state.transform;
                     }
                     completion:^(BOOL finished) {
        @strongify(self);
                         XHViewState *state = [XHViewState viewStateForView:currentView];
                         currentView.transform = CGAffineTransformIdentity;
                         currentView.frame = state.frame;
                         currentView.transform = state.transform;
                         [state.superview addSubview:currentView];
                         
                         for(UIView *view in self.imgViews){
                             XHViewState *_state = [XHViewState viewStateForView:view];
                             view.userInteractionEnabled = _state.userInteratctionEnabled;
                         }
                         
                         // add by xiazhiyong
                         [currentView removeFromSuperview];
                         
                         if ([self.delegate respondsToSelector:@selector(imageViewerDidDismissFromSuperView)]) {
                             [self.delegate imageViewerDidDismissFromSuperView];
                         }
                         
                         [self removeFromSuperview];
                     }
     ];
}


#pragma mark - Gesture events

- (void)tappedScrollView:(UITapGestureRecognizer*)sender
{
    [self prepareToDismiss];
    [self dismissWithAnimate];
}

- (void)didPan:(UIPanGestureRecognizer*)sender
{
    static UIImageView *currentView = nil;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        currentView = [self currentView];
        
        UIView *targetView = currentView.superview;
        while (![targetView isKindOfClass:[XHZoomingImageView class]]) {
            targetView = targetView.superview;
        }
        
        if (((XHZoomingImageView *)targetView).isViewing) {
            currentView = nil;
        }
        else {
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            currentView.frame = [window convertRect:currentView.frame fromView:currentView.superview];
            [window addSubview:currentView];
            
            [self prepareToDismiss];
        }
    }
    
    if (currentView) {
        if (sender.state == UIGestureRecognizerStateEnded) {
            if (self.scrollView.alpha > 0.5) {
                [self showWithSelectedView:currentView];
            }
            else {
                [self dismissWithAnimate];
            }
            currentView = nil;
        }
        else {
            CGPoint p = [sender translationInView:self];
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, p.y);
            transform = CGAffineTransformScale(transform, 1 - fabs(p.y)/1000, 1 - fabs(p.y)/1000);
            currentView.transform = transform;
            
            CGFloat r = 1-fabs(p.y)/200;
            self.scrollView.alpha = MAX(0, MIN(1, r));
        }
    }
}

- (void)saveImage
{
    NSLog(@"saveImage");
    
    NSInteger indexImg = self.pageIndex;
    if (self.imgViews && self.imgViews.count > indexImg) {
        // 取当前索引处的图片
        UIImageView *imgview = self.imgViews[indexImg];
        if (imgview.image) {
            if (FKYJurisdictionTool.getPhotoLibraryJueiaDiction == true) {
                // 有相册权限
                [[TZImageManager manager] savePhotoWithImage:imgview.image completion:^(PHAsset *asset, NSError *error) {
                    if (error != nil) {
                        // 失败
                        if ([ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusNotDetermined) {
                            [kAppDelegate showToast:error.localizedDescription];
                        }
                    }
                    else {
                        // 成功
                        [kAppDelegate showToast:@"保存成功"];
                    }
                }];
            }
        }
        else {
            // 无图片
            [kAppDelegate showToast:@"暂无可保存的图片"];
        }
    }
    else {
        // error
        [kAppDelegate showToast:@"保存图片失败"];
    }
}


#pragma mark - Private

- (void)updatePageNumber:(NSInteger)index {
    NSInteger total = self.imgViews.count;
    NSInteger current = index + 1;
    self.lblPageControl.text = [NSString stringWithFormat:@"%ld/%ld", (long)current, (long)total];

    NSString *content = self.lblPageControl.text;
    if (content && content.length > 0) {
        NSArray *arrTemp = [content componentsSeparatedByString:@"/"];
        if (arrTemp && arrTemp.count == 2) {
            NSString *before = arrTemp.firstObject;
            NSRange range = NSMakeRange(0, before.length);
            NSDictionary *attributesBefore = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:FKYWH(20)],
                                                NSForegroundColorAttributeName : [UIColor whiteColor] };
            NSDictionary *attributesAfter = @{ NSFontAttributeName : [UIFont systemFontOfSize:FKYWH(16)],
                                               NSForegroundColorAttributeName : [UIColor whiteColor] };
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
            [attrString addAttributes:attributesAfter range:NSMakeRange(0, content.length)];
            [attrString addAttributes:attributesBefore range:range];
            self.lblPageControl.attributedText = attrString;
        }
    }
}

- (CGFloat)getBottomMargin
{
    CGFloat margin = 0;
    
    // iPhoneX适配
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            // iPhoneX
            margin = iPhoneX_SafeArea_BottomInset;
        }
    }
    return margin;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 当前页索引
    NSInteger pageIndexCurrent = (self.scrollView.contentOffset.x / self.scrollView.frame.size.width + 0.5);
//    self.pageControl.currentPage = pageIndexCurrent;
//    [self updatePageNumber:pageIndexCurrent];
    
    // 显示PageControl
    if (self.showPageControl) {
        if (self.imgViews.count == 1 && self.hideWhenOnlyOne == YES) {
            // 单张图片时不显示PageControl
        }
        else {
            // 一直显示PageControl
            if (self.userPageNumber) {
                // 使用数字
                [self updatePageNumber:pageIndexCurrent];
            }
            else {
                // 使用点
                self.pageControl.currentPage = pageIndexCurrent;
            }
        }
    }
}


#pragma mark - Property

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1];
        _scrollView.alpha = 0;
    }
    return _scrollView;
}

- (NSArray *)imgViews
{
    if (!_imgViews) {
        _imgViews = [NSArray array];
    }
    return _imgViews;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        CGFloat margin = [self getBottomMargin];
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - FKYWH(220)) / 2, SCREEN_HEIGHT - FKYWH(30) - margin, FKYWH(220), FKYWH(20))];
        _pageControl.numberOfPages = self.imgViews.count;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:(169)/255.0f green:(169)/255.0f blue:(169)/255.0f alpha:1];
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xffc343);
        _pageControl.center = CGPointMake(self.center.x, _pageControl.center.y);
    }
    return _pageControl;
}

- (UILabel *)lblPageControl
{
    if (!_lblPageControl) {
        CGFloat margin = [self getBottomMargin];
        _lblPageControl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - FKYWH(220)) / 2, SCREEN_HEIGHT - FKYWH(50) - margin, FKYWH(220), FKYWH(20))];
        _lblPageControl.center = CGPointMake(self.center.x, _lblPageControl.center.y);
        _lblPageControl.textColor = [UIColor whiteColor];
        _lblPageControl.textAlignment = NSTextAlignmentCenter;
        _lblPageControl.font = [UIFont systemFontOfSize:FKYWH(16)];
    }
    return _lblPageControl;
}

- (UIButton *)btnSave
{
    if (!_btnSave) {
        // 适配iphoneX
        CGFloat bottomHeight = 0;
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                bottomHeight = insets.bottom;
            }
        }
        
        _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.frame = CGRectMake(SCREEN_WIDTH - FKYWH(40) - FKYWH(20), SCREEN_HEIGHT - FKYWH(40) - FKYWH(20) - bottomHeight, FKYWH(40), FKYWH(40));
        _btnSave.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_btnSave setImage:[UIImage imageNamed:@"btn_download"] forState:UIControlStateNormal];
        [_btnSave addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        _btnSave.layer.masksToBounds = YES;
        _btnSave.layer.cornerRadius = 3.0;
    }
    return _btnSave;
}

@end
