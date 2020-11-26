//
//  FKYEnterpriseListView.m
//  FKY
//
//  Created by 夏志勇 on 2017/11/30.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYEnterpriseListView.h"
#import "FKYEnterpriseCell.h"
#import "POP.h"
#import "UIWindow+Hierarchy.h"


@interface FKYEnterpriseListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *viewDismiss;

@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *arrayEnterprise;
@property (nonatomic, copy) NSString *currentEnterprise;
@property (nonatomic, assign) CGFloat currentHeight;

@end


@implementation FKYEnterpriseListView

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
        [self setupData];
        [self setupAction];
    }
    return self;
}


#pragma mark - ui

- (void)setupView
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self addSubview:self.viewDismiss];
    [self.viewDismiss mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.viewContent];
}


#pragma mark - data

- (void)setupData
{
    // 默认最大高度
    self.currentHeight = SCREEN_HEIGHT-FKYWH(70*2);
}


#pragma mark - action

- (void)setupAction
{
    @weakify(self);
    [self.viewDismiss bk_whenTapped:^{
        @strongify(self);
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}


#pragma mark - event

// 滑动到顶部~!@
- (void)scrollToTop {
    [self.tableview reloadData];
    if (self.arrayEnterprise.count > 0) {
        [self.tableview setContentOffset:CGPointZero animated:YES];
       // [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


#pragma mark - public

- (void)setEnterpriseList:(NSArray *)arrayList withCurrentEnterprise:(NSString *)name
{
    // 保存当前选中企业名称...<不再使用>
    self.currentEnterprise = name;
    
    // 保存所有企业名称数组
    [self.arrayEnterprise removeAllObjects];
    if (arrayList && arrayList.count > 0) {
        [self.arrayEnterprise addObjectsFromArray:arrayList];
    }
    [self.tableview reloadData];
    
    // 滑动到顶部
    [self.tableview setContentOffset:CGPointZero animated:YES];
    if (arrayList && arrayList.count > 0) {
        [self.tableview setContentOffset:CGPointZero animated:YES];
        //[self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    // 根据企业个数，需动态调整内容高度
    if (arrayList && arrayList.count > 0) {
        // 有
        CGFloat maxHeight = SCREEN_HEIGHT-FKYWH(70*2); // 默认最大高度
        // 适配iPhoneX
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                maxHeight -= FKYWH(90);
            }
        }
        CGFloat minHeight = FKYWH(52*5); // 默认最小高度
        CGFloat currentHeight = FKYWH(52) * arrayList.count;
        currentHeight = MAX(currentHeight, minHeight);
        currentHeight = MIN(currentHeight, maxHeight);
        self.currentHeight = currentHeight;
    }
    else {
        // 无
        self.currentHeight = FKYWH(52*5); // 最少展示5行
    }
    
    // 初始设置...<先隐藏>
    self.viewContent.frame = CGRectMake(SCREEN_WIDTH, (SCREEN_HEIGHT-self.currentHeight)/2, SCREEN_WIDTH-FKYWH(40*2), self.currentHeight);
}

- (void)showOrHideListView:(BOOL)showFlag withAnimation:(BOOL)animation
{
    if (showFlag) {
        // 显示
        
        UIWindow *window = [UIWindow getTopWindowForAddSubview];
        if (self.superview == nil) {
            [window addSubview:self];
        }
        [window bringSubviewToFront:self];
        
        // 滑动到顶部
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self scrollToTop];
        });
        
        if (animation) {
            // 带动画
            POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            anim.toValue = [NSValue valueWithCGRect:CGRectMake(FKYWH(40), (SCREEN_HEIGHT-self.currentHeight)/2, SCREEN_WIDTH-FKYWH(40*2), self.currentHeight)];
            anim.springSpeed = 12.f;        // [0-20] 速度:越大则动画结束越快
            anim.springBounciness = 9.f;    // [0-20] 弹力:越大则震动幅度越大
            anim.beginTime = CACurrentMediaTime();
            anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                // 动画结束
            };
            [self.viewContent pop_addAnimation:anim forKey:@"frameIn"];
        }
        else {
            // 不带动画
            self.viewContent.frame = CGRectMake(FKYWH(40), (SCREEN_HEIGHT-self.currentHeight)/2, SCREEN_WIDTH-FKYWH(40*2), self.currentHeight);
        }
    }
    else {
        // 隐藏
        
        if (animation) {
            // 带动画
            POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            anim.toValue = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH, (SCREEN_HEIGHT-self.currentHeight)/2, SCREEN_WIDTH-FKYWH(40*2), self.currentHeight)];
            anim.springSpeed = 18.f;        // [0-20] 速度:越大则动画结束越快
            anim.springBounciness = 4.f;    // [0-20] 弹力:越大则震动幅度越大
            //anim.beginTime = CACurrentMediaTime() + 0.2;
            anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                // 动画结束
                [self removeFromSuperview];
            };
            [self.viewContent pop_addAnimation:anim forKey:@"frameOut"];
        }
        else {
            // 不带动画
            [self removeFromSuperview];
        }
    }
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayEnterprise.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FKYWH(52);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FKYEnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYEnterpriseCell" forIndexPath:indexPath];
    NSString *title = self.arrayEnterprise[indexPath.row];
    [cell configWithTitle:title currentTitle:self.currentEnterprise];
    [cell setSelectedStatus:(indexPath.row == 0 ? YES : NO)]; // 永远是第一个选中~!@
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectEnterpriseBlock) {
        self.selectEnterpriseBlock(indexPath.row, self.arrayEnterprise[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - property

- (UIView *)viewDismiss
{
    if (!_viewDismiss) {
        _viewDismiss = [UIView new];
        _viewDismiss.backgroundColor = [UIColor clearColor];
    }
    return _viewDismiss;
}

- (UIView *)viewContent
{
    if (!_viewContent) {
        _viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-FKYWH(40*2), SCREEN_HEIGHT-FKYWH(70*2))];
        _viewContent.center = self.center;
        _viewContent.backgroundColor = [UIColor whiteColor];
        _viewContent.layer.cornerRadius = FKYWH(10);
        _viewContent.layer.masksToBounds = YES;
        
        [_viewContent addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self->_viewContent);
        }];
    }
    return _viewContent;
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.backgroundView = nil;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.tableHeaderView = nil;
        _tableview.tableFooterView = nil;
        _tableview.showsVerticalScrollIndicator = YES;
        [_tableview registerClass:[FKYEnterpriseCell class] forCellReuseIdentifier:@"FKYEnterpriseCell"];
    }
    return _tableview;
}

- (NSMutableArray *)arrayEnterprise
{
    if (!_arrayEnterprise) {
        _arrayEnterprise = [NSMutableArray array];
    }
    return _arrayEnterprise;
}

@end
