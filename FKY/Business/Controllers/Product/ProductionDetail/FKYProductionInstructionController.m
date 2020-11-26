//
//  FKYProductionInstructionController.m
//  FKY
//
//  Created by mahui on 15/11/13.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYProductionInstructionController.h"
#import "FKYProductInstructionCell.h"
#import "FKYProductionInstructionNameCell.h"
#import "FKYExtModel.h"
#import "NSString+Contains.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>


@interface FKYProductionInstructionController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTabelView;
@property (nonatomic, strong) FKYExtModel *speciModel;

@end


@implementation FKYProductionInstructionController

#pragma mark - LifeCircle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupUI];
}

#pragma mark - Private

- (void)p_setupUI
{
    self.mainTabelView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(10))];
        view.backgroundColor = [UIColor whiteColor];
        
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.dataSource = self;
        table.delegate = self;
        table.backgroundColor = UIColorFromRGB(0xf4f4f4);
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.tableHeaderView = view;
        [table registerClass:[FKYProductInstructionCell class] forCellReuseIdentifier:@"FKYProductInstructionCell"];
        [table registerClass:[FKYProductionInstructionNameCell class] forCellReuseIdentifier:@"FKYProductionInstructionNameCell"];
        [self.view addSubview:table];
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        if (@available(iOS 11.0, *)) {
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.parentViewController.automaticallyAdjustsScrollViewInsets = NO;
        }
        table;
    });
}


#pragma mark - Public

- (void)showContent
{
    [self.mainTabelView reloadData];
}

- (void)updateContentHeight:(BOOL)showFlag
{
    CGFloat bottomViewHeight = 64;
    CGFloat navigationBarHeight = 64;
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            bottomViewHeight += iPhoneX_SafeArea_BottomInset;
            navigationBarHeight = iPhoneX_SafeArea_TopInset;
        }
    }
    
    CGFloat height = showFlag ? (SCREEN_HEIGHT - FKYWH(bottomViewHeight) - FKYWH(navigationBarHeight) - FKYWH(32)) : (SCREEN_HEIGHT - FKYWH(bottomViewHeight) - FKYWH(navigationBarHeight));
    self.mainTabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
}

- (void)setContentHeight:(CGFloat)height
{
    self.mainTabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.productModel && self.productModel.ext) {
        return self.productModel.ext.numberOfValuesToShow;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.productModel && self.productModel.ext) {
        if (section == 1) {
            return 4;
        }
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row >= 1) {
        // 名称
        FKYProductionInstructionNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYProductionInstructionNameCell" forIndexPath:indexPath];
        cell.nameLabel.textColor = UIColorFromRGB(0x666666);
        cell.normalNameLabel.textColor = UIColorFromRGB(0x666666);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 1:
            {
                cell.normalNameLabel.text = @"通用名称";
                cell.normalNameLabel.textAlignment = NSTextAlignmentLeft;
                cell.nameLabel.text = self.productModel.ext.commonName;
                cell.nameLabel.font = FKYSystemFont(FKYWH(12));
                cell.nameLabel.textAlignment = NSTextAlignmentLeft;
            }
                break;
            case 2:
            {
                cell.normalNameLabel.text = @"汉语拼音";
                cell.normalNameLabel.textAlignment = NSTextAlignmentLeft;
                cell.nameLabel.text = self.productModel.ext.commonNamePinyin;
                cell.nameLabel.font = FKYSystemFont(FKYWH(12));
                cell.nameLabel.textAlignment = NSTextAlignmentLeft;
            }
                break;
            case 3:
            {
                cell.normalNameLabel.text = @"商品名称";
                cell.normalNameLabel.textAlignment = NSTextAlignmentLeft;
                cell.nameLabel.text = self.productModel.ext.productName;
                cell.nameLabel.font = FKYSystemFont(FKYWH(12));
                cell.nameLabel.textAlignment = NSTextAlignmentLeft;
            }
                break;
            default:
                break;
        }
        return cell;
    }
    else {
        // 其它
        FKYProductInstructionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FKYProductInstructionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.section) {
            case 0: // 标题
            {
                if (indexPath.row == 0) {
                    cell.nameLabel.text = [NSString stringWithFormat:@"%@说明书",self.productModel.productName];
                    cell.nameLabel.font = FKYSystemFont(FKYWH(14));
                    cell.nameLabel.textColor = UIColorFromRGB(0x333333);
                    cell.nameLabel.textAlignment = NSTextAlignmentCenter;
                    cell.bottomLine.hidden = true;
                    cell.bgView.backgroundColor = UIColorFromRGB(0xffffff);
                }
                else {
                    cell.nameLabel.text = @"请仔细阅读说明书, 按医生指导购买和服用!";
                    cell.nameLabel.font = FKYSystemFont(FKYWH(12));
                    cell.nameLabel.textColor = UIColorFromRGB(0x999999);
                    cell.nameLabel.textAlignment = NSTextAlignmentCenter;
                    cell.bottomLine.hidden = true;
                    cell.bgView.backgroundColor = UIColorFromRGB(0xffffff);
                }
            }
                break;
            default: { // 内容
                if (!self.productModel) {
                    self.productModel = [FKYProductObject new];
                }
                
                NSString *text = [self.productModel.ext textForIndex:indexPath];
                if ([text containsaString:@"【"]) {
                    cell.nameLabel.text = [[text stringByReplacingOccurrencesOfString:@"【" withString:@""] stringByReplacingOccurrencesOfString:@"】" withString:@""];
                    cell.nameLabel.font = FKYSystemFont(FKYWH(13));
                    cell.nameLabel.textColor = UIColorFromRGB(0x333333);
                    cell.nameLabel.textAlignment = NSTextAlignmentLeft;
                    cell.bottomLine.hidden = false;
                    cell.bgView.backgroundColor = UIColorFromRGB(0xffffff);
                }
                else {
                    cell.nameLabel.text = text;
                    cell.nameLabel.font = FKYSystemFont(FKYWH(12));
                    cell.nameLabel.textColor = UIColorFromRGB(0x666666);
                    cell.nameLabel.textAlignment = NSTextAlignmentLeft;
                    cell.bottomLine.hidden = true;
                    cell.bgView.backgroundColor = UIColorFromRGB(0xffffff);
                }
                
                if (indexPath.row == 0) {
                    cell.nameLabel.font = FKYSystemFont(FKYWH(13));
                    cell.nameLabel.textColor = UIColorFromRGB(0x333333);
                    cell.bottomLine.hidden = false;
                }
                else {
                    cell.nameLabel.font = FKYSystemFont(FKYWH(12));
                    cell.nameLabel.textColor = UIColorFromRGB(0x666666);
                    cell.bottomLine.hidden = true;
                }
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 标题
        return FKYWH(30);
    }
    
    if (indexPath.section == 1) {
        // 名称
        return FKYWH(35);
    }
    
    // 其它
    NSString *text = [self.productModel.ext textForIndex:indexPath];
    if (text && text.length > 0) {
        // 计算文字高度
        CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - FKYWH(22) * 2, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:FKYSystemFont(FKYWH(12))}
                                                  context:NULL].size;
        CGFloat height = size.height + FKYWH(20) + 2;
        height = (height <= FKYWH(35) ? FKYWH(35) : height);
        return height;
    }
    else {
        return FKYWH(35);
    }
    
//    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"FKYProductInstructionCell"
//                                    cacheByIndexPath:indexPath
//                                       configuration:^(FKYProductInstructionCell *cell) {
//                                           NSString *text = [self.productModel.ext textForIndex:indexPath];
//                                           if ([text hasPrefix:@"【"]) {
//                                               cell.nameLabel.text = text;
//                                               cell.nameLabel.font = FKYSystemFont(FKYWH(14));
//                                               cell.nameLabel.textAlignment = NSTextAlignmentLeft;
//                                               cell.bgView.backgroundColor = UIColorFromRGB(0xdcdcdc);
//                                           }
//                                           else {
//                                               cell.nameLabel.text = text;
//                                               cell.nameLabel.font = FKYSystemFont(FKYWH(14));
//                                               cell.nameLabel.textAlignment = NSTextAlignmentLeft;
//                                               cell.bgView.backgroundColor = UIColorFromRGB(0xf7f7f7);
//                                           }}];
//    height = (height <= FKYWH(35) ? FKYWH(35) : height);
//    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FKYWH(8);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FKYWH(8))];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

@end
