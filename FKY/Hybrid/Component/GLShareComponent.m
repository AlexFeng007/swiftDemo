//
//  GLShareComponent.m
//  YYW
//
//  Created by Rabe on 28/02/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLShareComponent.h"

static float defaultPannelHeight = 260;
static float cancelHeight = 60;

@interface GLShareCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageview; /* <分享图片 */
@property (nonatomic, strong) UILabel *titlelabel;    /* <分享标题 */

- (void)configCellWithTitle:(NSString *)title image:(NSString *)image;

@end

@implementation GLShareCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMainViews];
    }
    return self;
}

- (void)setupMainViews
{
    [self addSubview:self.imageview];
    [self addSubview:self.titlelabel];
}

- (void)configCellWithTitle:(NSString *)title image:(id)image
{
    self.titlelabel.text = title;
    if ([image isKindOfClass:NSString.class] && ![image hasPrefix:@"http"]) {
        self.imageview.image = [UIImage imageNamed:(NSString *)image];
    }
    else if ([image isKindOfClass:NSString.class] && [image hasPrefix:@"http"]) {
        [self.imageview sd_setImageWithURL:[NSURL URLWithString:[(NSString *)image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

- (UIImageView *)imageview
{
    if (_imageview == nil) {
        CGRect frame = CGRectMake(self.frame.size.width / 2 - 25, 15, 50, 50);
        _imageview = [[UIImageView alloc] initWithFrame:frame];
    }
    return _imageview;
}

- (UILabel *)titlelabel
{
    if (_titlelabel == nil) {
        CGRect frame = CGRectMake(5, 75, self.frame.size.width - 10, 15);
        _titlelabel = [[UILabel alloc] initWithFrame:frame];
        _titlelabel.font = [UIFont systemFontOfSize:13];
        _titlelabel.textColor = [UIColor grayColor];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}

@end

@interface GLShareComponent () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *pannel;      /* <分享面板 */
@property (nonatomic, strong) UICollectionView *cv;   /* <分享按钮容器 */
@property (nonatomic, strong) UIView *maskLayer;      /* <遮罩层 */
@property (nonatomic, strong) UIButton *cancelButton; /* <取消按钮 */

@property (nonatomic, strong, readonly) NSArray *titles;      /* <分享标题 */
@property (nonatomic, strong, readonly) NSArray *images;      /* <分享图片 */
@property (nonatomic, assign, readonly) NSInteger totalCount; /* <分享按钮总数 */
@property (nonatomic, assign, readwrite) float pannelHeight;  /* <分享面板高度 */

@property (nonatomic, copy) GLShareHandler handler;

@end

@implementation GLShareComponent

#pragma mark - life cycle

+ (void)showComponentWithTitles:(NSArray *)titles images:(NSArray *)images handler:(GLShareHandler)handler
{
    return [self showComponentInView:[UIApplication sharedApplication].keyWindow frame:[UIScreen mainScreen].bounds titles:titles images:images handler:handler];
}

+ (void)showComponentInView:(UIView *)view frame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images handler:(GLShareHandler)handler
{
    GLShareComponent *sc = [[GLShareComponent alloc] initWithFrame:frame titles:titles images:images handler:handler];
    [view addSubview:sc];
    [sc show];
}

- (instancetype)initWithTitles:(NSArray *)titles images:(NSArray *)images handler:(GLShareHandler)handler
{
    return [self initWithFrame:[UIScreen mainScreen].bounds titles:titles images:images handler:handler];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images handler:(GLShareHandler)handler
{
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        _images = images;
        _totalCount = MIN(_titles.count, _images.count);
        _pannelHeight = _totalCount <= 3 ? ((defaultPannelHeight - cancelHeight) / 2 + cancelHeight) : defaultPannelHeight;
#ifdef __IPHONE_11_0
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                _pannelHeight += insets.bottom;
                cancelHeight = 60 + insets.bottom;
            }
        }
#endif
        _handler = handler;
        [self setupMainView];
    }
    return self;
}

#pragma mark - delegate

#pragma mark UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _totalCount / 6 + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == _totalCount / 6 ? _totalCount % 6 : 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = collectionView.frame.size.width / 3;
    CGFloat h = _totalCount <= 3 ? collectionView.frame.size.height : collectionView.frame.size.height / 2;
    return CGSizeMake(w, h);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GLShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLShareCell" forIndexPath:indexPath];
    [cell configCellWithTitle:_titles[indexPath.item] image:_images[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    if (_handler) {
        _handler(_titles[indexPath.item]);
    }
}

#pragma mark - public

- (void)show
{
    @weakify(self);
    [UIView animateWithDuration:0.3
                     animations:^{
        @strongify(self);
                         self.maskLayer.alpha = 0.4;
                         CGRect rect = CGRectMake(0, self.frame.size.height - self.pannelHeight, [UIScreen mainScreen].bounds.size.width, self.pannelHeight);
                         self.pannel.frame = rect;
                     }
                     completion:nil];
}

- (void)dismiss
{
    @weakify(self);
    [UIView animateWithDuration:0.3
                     animations:^{
        @strongify(self);
                         self.maskLayer.alpha = 0;
                         CGRect rect = CGRectMake(0, self.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.pannelHeight);
                         self.pannel.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - action

- (void)clickMaskLayer:(UITapGestureRecognizer *)recognizer
{
    [self dismiss];
}

#pragma mark - ui

- (void)setupMainView
{
    [self addSubview:self.maskLayer];
    [self addSubview:self.pannel];
    [self.pannel addSubview:self.cv];
    [self.pannel addSubview:self.cancelButton];
    
    CGRect frame = CGRectMake(35, self.pannel.frame.size.height - cancelHeight + 1, self.pannel.frame.size.width - 35 * 2, 1);
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [self.pannel addSubview:line];
}

#pragma mark - private

- (UICollectionViewFlowLayout *)flowlayoutStyleWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return layout;
}

#pragma mark - property

- (UIView *)pannel
{
    if (_pannel == nil) {
        CGRect rect = CGRectMake(0, self.frame.size.height, [UIScreen mainScreen].bounds.size.width, _pannelHeight);
        _pannel = [[UIView alloc] initWithFrame:rect];
        _pannel.backgroundColor = [UIColor whiteColor];
    }
    return _pannel;
}

- (UICollectionView *)cv
{
    if (_cv == nil) {
        CGRect frame = CGRectMake(0, 0, self.pannel.frame.size.width, self.pannel.frame.size.height - cancelHeight);
        UICollectionViewFlowLayout *layout = [self flowlayoutStyleWithFrame:frame];
        _cv = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _cv.delegate = self;
        _cv.dataSource = self;
        _cv.showsVerticalScrollIndicator = NO;
        _cv.showsHorizontalScrollIndicator = NO;
        _cv.backgroundColor = [UIColor clearColor];
        _cv.pagingEnabled = _totalCount > 6;
        [_cv registerClass:GLShareCell.class forCellWithReuseIdentifier:@"GLShareCell"];
    }
    return _cv;
}

- (UIView *)maskLayer
{
    if (_maskLayer == nil) {
        _maskLayer = [[UIView alloc] initWithFrame:self.frame];
        _maskLayer.backgroundColor = [UIColor blackColor];
        _maskLayer.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMaskLayer:)];
        [_maskLayer addGestureRecognizer:tap];
    }
    return _maskLayer;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        CGFloat buttonHeight = cancelHeight - 2;
#ifdef __IPHONE_11_0
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) { // iPhoneX
                buttonHeight -= insets.bottom;
            }
        }
#endif
        CGRect frame = CGRectMake(0, self.pannel.frame.size.height - cancelHeight + 2, [UIScreen mainScreen].bounds.size.width, buttonHeight);
        _cancelButton = [[UIButton alloc] initWithFrame:frame];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end

