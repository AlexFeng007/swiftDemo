//
//  FKYCartTypeView.m
//  FKY
//
//  Created by 夏志勇 on 2019/3/26.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import "FKYCartTypeView.h"

@interface FKYCartTypeView ()

@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@end


@implementation FKYCartTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}


#pragma mark - UI

- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(FKYWH(20));
        make.right.equalTo(self).offset(-FKYWH(20));
    }];
    
    // 底部分隔线
    UIView *viewLine = [UIView new];
    viewLine.backgroundColor = UIColorFromRGB(0xE5E5E5);
    [self addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}


#pragma mark - Public

- (void)setSelectedIndex:(NSInteger)index
{
    self.segmentControl.selectedSegmentIndex = index;
}


#pragma mark - Property

- (HMSegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"普通商品", @"1起购"]];
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        // 设置滚动条高度
        _segmentControl.selectionIndicatorHeight = 1.0;
        // 设置滚动条颜色
        _segmentControl.selectionIndicatorColor = UIColorFromRGB(0xFF2D5C);
        // 设置滚动条样式
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        // 宽度类型
        _segmentControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        // 样式
        _segmentControl.type = HMSegmentedControlTypeText;
        // 内间距
        _segmentControl.segmentEdgeInset = UIEdgeInsetsZero;
        // 设置滚动条位置
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        // 设置未选中的字体大小和颜色
        _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColorFromRGB(0x333333) colorWithAlphaComponent:1], NSFontAttributeName:[UIFont systemFontOfSize:15]};
        // 设置选中的字体大小和颜色
        _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0xFF2D5C), NSFontAttributeName:[UIFont systemFontOfSize:15]};
        // 设置分段选中索引
        [_segmentControl setSelectedSegmentIndex:0 animated:YES];
        // 设置分段类型切换时触发的操作
        @weakify(self);
        [_segmentControl setIndexChangeBlock:^(NSInteger index) {
            @strongify(self);
            if (self.selectBlock) {
                self.selectBlock(index);
            }
        }];
    }
    return _segmentControl;
}

@end
