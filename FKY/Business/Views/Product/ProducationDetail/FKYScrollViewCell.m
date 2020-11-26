//
//  FKYScrollViewCell.m
//  FKY
//
//  Created by mahui on 15/9/17.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYScrollViewCell.h"
#import "SDCycleScrollView.h"
#import "XHImageViewer.h"


@interface FKYScrollViewCell () <SDCycleScrollViewDelegate, XHImageViewerDelegate>

// View
@property (nonatomic, strong) SDCycleScrollView *cycleScrollview;
@property (nonatomic, strong) UILabel *lblPageControl;
@property (nonatomic, strong) UIButton *btnRecommend;
// Model
@property (nonatomic, strong) NSMutableArray *arrImageview;
// Block
@property (nonatomic, copy) void (^recommendBlock)(void);

@end


@implementation FKYScrollViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}


#pragma mark - UI

- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.cycleScrollview];
    [self.cycleScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(FKYWH(-10));
    }];
    
    [self.contentView addSubview:self.lblPageControl];
    [self.lblPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(FKYWH(-10));
        make.right.equalTo(self.contentView).offset(FKYWH(-15));
        make.size.mas_equalTo(CGSizeMake(FKYWH(50), FKYWH(22)));
    }];
    
    [self.contentView addSubview:self.btnRecommend];
    [self.btnRecommend setHidden:true];
    [self.btnRecommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(FKYWH(-24));
        make.right.equalTo(self.contentView).offset(FKYWH(0));
        make.size.mas_equalTo(CGSizeMake(FKYWH(107), FKYWH(48)));
    }];
    
//    UIView *viewLine = [UIView new];
//    //viewLine.backgroundColor = UIColorFromRGB(0xF7F7F7);
//    viewLine.backgroundColor = [UIColorFromRGB(0x595959) colorWithAlphaComponent:0.1];
//    [self.contentView addSubview:viewLine];
//    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(self.contentView);
//        make.height.mas_equalTo(FKYWH(2));
//    }];
    
    // 阴影
//    UIView *viewLine = [UIView new];
//    viewLine.backgroundColor = [UIColor whiteColor];
//    viewLine.layer.shadowColor = [UIColorFromRGB(0x595959) colorWithAlphaComponent:0.1].CGColor;
//    viewLine.layer.shadowOffset = CGSizeMake(0, FKYWH(2));
//    viewLine.layer.shadowRadius = FKYWH(1);
//    viewLine.layer.shadowOpacity = 0.5;
//    [self.contentView addSubview:viewLine];
//    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.contentView);
//        make.bottom.equalTo(self.contentView).offset(-FKYWH(2));
//        make.height.mas_equalTo(FKYWH(8));
//    }];
    
    // <反向>阴影
    UIColor *colorTop = [UIColor whiteColor];
    UIColor *colorBottom = UIColorFromRGB(0x595959);
    //UIColor *colorBottom = UIColorFromRGB(0xf4f4f4);
    UIImage *img = [UIImage gradientColorImageFromColors:@[colorTop, colorBottom] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(SCREEN_WIDTH, FKYWH(5))];
    UIImageView *imgview = [UIImageView new];
    imgview.image = img;
    imgview.alpha = 0.1;
    [self.contentView addSubview:imgview];
    [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(FKYWH(5));
    }];
}


#pragma mark - Public

- (void)configCell:(NSArray *)pictureArray
{
    if (pictureArray && pictureArray.count > 0) {
        // 有图片
        self.cycleScrollview.imageURLStringsGroup = [NSArray arrayWithArray:pictureArray];
        [self.cycleScrollview showFromIndex:0];
        self.lblPageControl.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)pictureArray.count];
        
        [self.arrImageview removeAllObjects];
        for (int i = 0; i < pictureArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setFrame:CGRectMake(0, [self getTopHeight], SCREEN_WIDTH, FKYWH(220))];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:pictureArray[i]] placeholderImage:[UIImage imageNamed:@"image_default_img"]];
            [self.arrImageview addObject:imageView];
        } // for
        
        if (pictureArray.count > 1) {
            self.lblPageControl.hidden = NO;
        }
        else {
            self.lblPageControl.hidden = YES;
        }
    }
    else {
        // 无图片
        self.cycleScrollview.localizationImageNamesGroup = @[[UIImage imageNamed:@"image_default_img"]];
        self.lblPageControl.text = @"1/1";
        self.lblPageControl.hidden = YES;
        
        // 默认展示一张本地图片
        [self.arrImageview removeAllObjects];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, [self getTopHeight], SCREEN_WIDTH, FKYWH(220))];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"image_default_img"];
        [self.arrImageview addObject:imageView];
    }
    
    // 调整页索引展示方式
    [self changePageControlStyle];
}

- (void)configRecommendView:(BOOL)isShow block:(void (^)(void))block
{
    self.btnRecommend.hidden = !isShow;
    self.recommendBlock = block;    
}


#pragma mark - Private

// 更新页索引
- (void)updatePageControl:(NSInteger)index
{
    if (self.cycleScrollview.imageURLStringsGroup && self.cycleScrollview.imageURLStringsGroup.count > 0) {
        if (index >= self.cycleScrollview.imageURLStringsGroup.count) {
            index = 0;
        }
        self.lblPageControl.text = [NSString stringWithFormat:@"%ld/%lu", (long)(index+1), (unsigned long)self.cycleScrollview.imageURLStringsGroup.count];
    }
    else {
        self.lblPageControl.text = @"1/1";
    }
    
    // 调整页索引展示方式
    [self changePageControlStyle];
}

// 调整页索引展示方式
- (void)changePageControlStyle
{
    NSString *content = self.lblPageControl.text;
    if (content && content.length > 0) {
        NSArray *arrTemp = [content componentsSeparatedByString:@"/"];
        if (arrTemp && arrTemp.count == 2) {
            NSString *before = arrTemp.firstObject;
            NSRange range = NSMakeRange(0, before.length);
            NSDictionary *attributesBefore = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:FKYWH(16)],
                                                NSForegroundColorAttributeName : [UIColor whiteColor] };
            NSDictionary *attributesAfter = @{ NSFontAttributeName : [UIFont systemFontOfSize:FKYWH(13)],
                                               NSForegroundColorAttributeName : [UIColor whiteColor] };
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
            [attrString addAttributes:attributesAfter range:NSMakeRange(0, content.length)];
            [attrString addAttributes:attributesBefore range:range];
            self.lblPageControl.attributedText = attrString;
        }
    }
}

// 获取顶部导航栏总高度
- (CGFloat)getTopHeight
{
    CGFloat navigationBarHeight = 64;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            navigationBarHeight = iPhoneX_SafeArea_TopInset;
        }
    }
    return navigationBarHeight;
}


#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index >= self.arrImageview.count) {
        return;
    }
    
    // 增加点击图片回调
    if (self.clickDetailPicBlock) {
        self.clickDetailPicBlock();
    }
    
    // 查看大图时，停止自动滑动
//    [self.cycleScrollview stopAutoScroll];
    
    UIImageView *imageView = self.arrImageview[index];
    [imageView setFrame:CGRectMake(0, [self getTopHeight], SCREEN_WIDTH, FKYWH(220))];
    self.arrImageview[index] = imageView;
    
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
//    imageViewer.showPageControl = true;
//    imageViewer.userPageNumber = true;
//    imageViewer.hideWhenOnlyOne = true;
    //imageViewer.showSaveBtn = true;
    [imageViewer showWithImageViews:self.arrImageview selectedView:self.arrImageview[index]];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    // 更新页索引
    [self updatePageControl:index];
}


#pragma mark - XHImageViewerDelegate

- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView pageIndex:(NSInteger)index
{
    // 查看大图完毕后，滑到指定索引图片处，并开始自动滑动
    [self.cycleScrollview showFromIndex:index];
    
    // 大于1张图片时才开始滑动
//    if (self.arrImageview.count > 1) {
//        [self.cycleScrollview startAutoScroll];
//    }
    
    // 更新页索引
    [self updatePageControl:index];
}


#pragma mark - Property

- (SDCycleScrollView *)cycleScrollview
{
    if (!_cycleScrollview) {
        _cycleScrollview = [[SDCycleScrollView alloc] initWithFrame:CGRectZero];
        _cycleScrollview.delegate = self;
        _cycleScrollview.showPageControl = NO;
        _cycleScrollview.autoScroll = NO;
        _cycleScrollview.backgroundColor = [UIColor whiteColor];
        _cycleScrollview.pageControlDotSize = CGSizeMake(FKYWH(5), FKYWH(5));
        _cycleScrollview.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollview.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollview.currentPageDotColor = UIColorFromRGB(0xffc343);
        _cycleScrollview.placeholderImage = [UIImage imageNamed:@"image_default_img"];
        _cycleScrollview.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    }
    return _cycleScrollview;
}

- (UILabel *)lblPageControl
{
    if (!_lblPageControl) {
        _lblPageControl = [UILabel new];
        _lblPageControl.backgroundColor = [UIColorFromRGB(0xABB3BB) colorWithAlphaComponent:0.6];
        _lblPageControl.textColor = [UIColor whiteColor];
        _lblPageControl.textAlignment = NSTextAlignmentCenter;
        _lblPageControl.font = [UIFont systemFontOfSize:FKYWH(13)];
        _lblPageControl.text = @"";
        _lblPageControl.layer.cornerRadius = FKYWH(11);
        _lblPageControl.layer.masksToBounds = YES;
        _lblPageControl.hidden = YES;
    }
    return _lblPageControl;
}

- (NSMutableArray *)arrImageview
{
    if (!_arrImageview) {
        _arrImageview = [NSMutableArray array];
    }
    return _arrImageview;
}

- (UIButton *)btnRecommend
{
    if (!_btnRecommend) {
        _btnRecommend = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRecommend setImage:[UIImage imageNamed:@"recommend_btn_pic"] forState:UIControlStateNormal];
        @weakify(self);
        [_btnRecommend bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.recommendBlock) {
                self.recommendBlock();
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRecommend;
}

@end
