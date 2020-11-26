//
//  FKYGiftActionSheetView.m
//  FKY
//
//  Created by mahui on 2017/2/14.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYGiftActionSheetView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "FKYProductObject.h"
#import "CartPromotionModel.h"
#import "NSString+Size.h"

@interface FKYGiftActionSheetView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) FKYProductObject *productObject;
@property (nonatomic, strong) NSArray *desArray;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *cellHeight;

@end

@implementation FKYGiftActionSheetView

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
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT/ 2, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    } completion:^(BOOL finished) {
        
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor  = UIColorFromRGBA(0x000000, 0);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title andCancleTitle:(NSString *)cancleTitle andProductArray:(FKYProductObject *)object{
    return [self initWithTitle:title andCancleTitle:cancleTitle andDesArray:object.promotionList];
}

- (instancetype)initWithTitle:(NSString *)title andCancleTitle:(NSString *)cancleTitle andDesArray:(NSArray *)contentArray{
    _title = title;
    _cancelTitle = cancleTitle;
    _desArray = contentArray;
    self =  [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    return self;
}

- (void)setupView
{    
    NSString *des = nil;
    NSMutableArray *tempCellHeight = [NSMutableArray array];
    for (id content in self.desArray) {
        if ([content isKindOfClass:[CartPromotionModel class]]) {
            des = [(CartPromotionModel *)content promotionDescription];
        }
        if ([content isKindOfClass:[NSString class]]) {
            des = content;
        }
        CGFloat height = [des heightWithFont:FKYSystemFont(FKYWH(12)) constrainedToWidth:(SCREEN_WIDTH*0.84)];
        if (height > FKYWH(45)) {
            [tempCellHeight addObject:@(height)];
        }else {
            [tempCellHeight addObject:@(FKYWH(45))];
        }
    }
    self.cellHeight = [NSArray arrayWithArray:tempCellHeight];
    CGFloat tableHeight = [[self.cellHeight valueForKeyPath:@"@sum.self"] floatValue]+4 + 50;
    CGFloat showHeight = tableHeight + FKYWH(50);
    BOOL isCanScroll = NO;
    if (showHeight > (SCREEN_HEIGHT - 100)) {
        showHeight = SCREEN_HEIGHT - 100;
        isCanScroll = YES;
    }
    
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            showHeight += iPhoneX_SafeArea_BottomInset;
        }
    }
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, showHeight)];
    [self addSubview:_contentView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(showHeight));
    }];
    
    UIButton *cancle = [[UIButton alloc] init];
    [_contentView addSubview:cancle];
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                make.height.equalTo(@(FKYWH(50+iPhoneX_SafeArea_BottomInset)));
            } else {
                make.height.equalTo(@(FKYWH(50)));
            }
        } else {
            make.height.equalTo(@(FKYWH(50)));
        }
    }];
    [cancle setTitleColor:UIColorFromRGB(0x8F8E94) forState:UIControlStateNormal];
    [cancle setTitle:_cancelTitle forState:UIControlStateNormal];
    cancle.titleLabel.font = FKYSystemFont(FKYWH(15));
    @weakify(self);
    [[cancle rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
            self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_contentView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancle.mas_top);
        make.left.right.top.equalTo(self.contentView);
    }];
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _contentView.backgroundColor = UIColorFromRGBA(0xFFFFFF, 1.0);
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = isCanScroll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.desArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath]
    ;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    id content = self.desArray[indexPath.row];
    NSString *des = nil;
    if ([content isKindOfClass:[CartPromotionModel class]]) {
        des = [(CartPromotionModel *)content promotionDescription];
    }
    if ([content isKindOfClass:[NSString class]]) {
        des = content;
    }
    cell.textLabel.text = des;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = FKYSystemFont(FKYWH(12));
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(NSNumber *)[self.cellHeight objectAtIndex:[indexPath row]] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FKYWH(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id content = self.desArray[indexPath.row];
    NSString *des = nil;
    if ([content isKindOfClass:[CartPromotionModel class]]) {
//        des = [(CartPromotionModel *)content promotionDescription];
        [self dismissSheetView];
        safeBlock(self.goToActivityController, ((CartPromotionModel *)content));
    }
    if ([content isKindOfClass:[NSString class]]) {
        des = content;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self dismissSheetView];
}

- (void)dismissSheetView{
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *desLable = [[UILabel alloc] init];
    desLable.textColor = UIColorFromRGB(0x8F8E94);
    desLable.font = FKYSystemFont(FKYWH(15));
    desLable.text = _title;
    desLable.textAlignment = NSTextAlignmentCenter;
    return desLable;
}

@end
