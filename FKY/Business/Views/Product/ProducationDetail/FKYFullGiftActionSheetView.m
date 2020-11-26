//
//  FKYFullGiftActionSheetView.m
//  FKY
//
//  Created by 乔羽 on 2018/6/4.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYFullGiftActionSheetView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "FKYProductObject.h"
#import "CartPromotionModel.h"
#import "NSString+Size.h"

#import "FKYFullGiftActionSheetModel.h"
#import "FKYFullGiftTableViewCell.h"
#import "FKYFullGiftActionSheetModel.h"

@interface FKYFullGiftActionSheetView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<FKYFullGiftActionSheetModel *> *dataSource;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *cellHeight;
@property (nonatomic, strong) NSString *contentStr;//描述文字
@property (nonatomic, assign) float contentHeight;
@end

@implementation FKYFullGiftActionSheetView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor  = UIColorFromRGBA(0x000000, 0);
    }
    return self;
}

- (instancetype)initWithContentArray:(NSArray *)contentArray andText:(NSString *)contentStr {
    _dataSource = contentArray;
    _contentStr = contentStr;
    self =  [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    return self;
}

- (void)setupView{
    CGFloat showHeight = 0;
    if (_dataSource.count > 0) {
        NSMutableArray *tempCellHeight = [NSMutableArray array];
        for (FKYFullGiftActionSheetModel * model in self.dataSource) {
            CGFloat h = [self computerH:model];
            [tempCellHeight addObject:@(h)];
        }
        self.cellHeight = [NSArray arrayWithArray:tempCellHeight];
        CGFloat tableHeight = [[self.cellHeight valueForKeyPath:@"@sum.self"] floatValue];
        showHeight = tableHeight + 54;
        BOOL isCanScroll = NO;
        if (showHeight > (SCREEN_HEIGHT - 100)) {
            showHeight = SCREEN_HEIGHT - 100;
            isCanScroll = YES;
        }
    }else {
        //兼容老版本促销没有数据返回
        CGFloat strH = [self.contentStr heightWithFont:FKYSystemFont(FKYWH(12)) constrainedToWidth:(SCREEN_WIDTH-20)];
        showHeight = 20 + 54 + strH;
    }
    self.contentHeight = showHeight;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, showHeight)];
    _contentView.backgroundColor = UIColorFromRGBA(0xFFFFFF, 1.0);
    [self addSubview:_contentView];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = UIColorFromRGB(0x8F8E94);
    desLabel.font = FKYSystemFont(FKYWH(15));
    desLabel.text = @"促销";
    desLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:desLabel];
    
    UIButton *cancle = [[UIButton alloc] init];
    [cancle setImage:[UIImage imageNamed:@"icon_account_close"] forState:UIControlStateNormal];
    cancle.titleLabel.font = FKYSystemFont(FKYWH(15));
    @weakify(self);
    [[cancle rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
            self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.contentHeight);
        } completion:^(BOOL finished) {
            @strongify(self);
            [self removeFromSuperview];
        }];
    }];
    [_contentView addSubview:cancle];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(showHeight));
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
    }];
    
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    if (self.dataSource.count > 0) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView registerClass:[FKYFullGiftTableViewCell class] forCellReuseIdentifier:@"FKYFullGiftTableViewCell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = false;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [tableView reloadData];
        [_contentView addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(desLabel.mas_bottom).offset(10);
            make.left.right.bottom.equalTo(self.contentView);
        }];
    }else {
        //兼容老版本促销没有数据返回
        UILabel *contentLb = [UILabel new];
        contentLb.text = self.contentStr;
        contentLb.font = FKYSystemFont(FKYWH(12));
        contentLb.numberOfLines = 0;
        contentLb.textColor = UIColorFromRGB(0x333333);
        [_contentView addSubview:contentLb];
        [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(desLabel.mas_bottom).offset(10);
           make.left.equalTo(self.contentView.mas_left).offset(10);
           make.right.equalTo(self.contentView.mas_right).offset(-10);
           make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        }];
    }
}

- (CGFloat)computerH:(FKYFullGiftActionSheetModel *)model {
    CGFloat collectionItemWidth = 76 + 10;
    
    CGFloat descH = [model.promotionRuleMsg heightWithFont:FKYSystemFont(12) constrainedToWidth:(SCREEN_WIDTH-80)];
    
    CGFloat collectionViewH = 0;
    CGFloat collectionViewW = SCREEN_WIDTH-40-56;
    NSInteger n = model.giftInfoList.count/(int)(collectionViewW/collectionItemWidth);
    if (n != 0) {
        if (n == 1) {
            if (model.giftInfoList.count > collectionViewW/collectionItemWidth) {
                n += 1;
            }
        } else {
            n = model.giftInfoList.count % n == 0 ? n : n+1;
        }
        
        collectionViewH = n * collectionItemWidth + (n-1)*10.0;
    } else {
        collectionViewH = collectionItemWidth;
    }
    return collectionViewH + descH + 30;
}

// MARK: UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FKYFullGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYFullGiftTableViewCell" forIndexPath:indexPath];
    FKYFullGiftActionSheetModel * model = self.dataSource[indexPath.row];
    [cell configCell:model index:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FKYFullGiftActionSheetModel * model = self.dataSource[indexPath.row];
    return [self computerH:model];
}

// MARK: Private Method

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissSheetView];
}

- (void)showInView:(UIView *)superView{
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.6);
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT/ 2, SCREEN_WIDTH, self.contentHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissSheetView{
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.contentHeight);
    } completion:^(BOOL finished) {
        @strongify(self);
        [self removeFromSuperview];
    }];
}

@end
