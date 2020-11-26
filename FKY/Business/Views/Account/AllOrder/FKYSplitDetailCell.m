//
//
//  Created by Rabe.☀️ on 16/1/11.
//  Copyright © 2016年 YYW. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "FKYSplitDetailCell.h"
#import "FKYSplitDatailDialView.h"
#import "FKY-Swift.h"
const float SMALLPOINT_CORNERRADIUS = 6;
const float BIGPOINT_CORNERRADIUS = 10;

@interface FKYSplitDetailCell () <UITextViewDelegate>

@property (nonatomic, strong) UIView *pointView;                                // 左边物流点球
@property (nonatomic, strong) UIView *columnLine;                               // 左边物流线
@property (nonatomic, strong) UIView *bottomLine;                               // 左边物流线
@property (nonatomic, strong) UITextView *desTextView;                          // 内容描述
@property (nonatomic, strong) UILabel *timeLabel;                               // 时间
@property (nonatomic, strong) NSDateFormatter *timeFormatter;
@end

@implementation FKYSplitDetailCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMainViews];
    }
    return self;
}

- (void)setupMainViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.pointView];
    [self.contentView addSubview:self.columnLine];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.desTextView];
    [self.contentView addSubview:self.timeLabel];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SMALLPOINT_CORNERRADIUS * 2, SMALLPOINT_CORNERRADIUS * 2));
        make.top.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView.mas_left).offset(25);
    }];

    [self.columnLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.pointView);
    }];

    [self.desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.pointView.mas_centerX).offset(25);
        make.right.equalTo(self.contentView).offset(-15);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.desTextView.mas_bottom).offset(4);
        make.left.equalTo(self.desTextView);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.right.equalTo(self.desTextView);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desTextView.mas_left).offset(0);
        make.trailing.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.height.equalTo(@1);
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"phonenumber"]) {
        NSString *phonenumber = [URL host];
        [FKYSplitDatailDialView showDialViewWithPhoneNumber:phonenumber andCallback:^{
            NSString *urlStr = [NSString stringWithFormat:@"tel://%@", phonenumber];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
        }];
    }
    
    return NO;
}

#pragma mark - public

- (void)configureModel:(id)model indexPath:(NSIndexPath *)indexPath
{
    //第一行设置高亮状态
    if (indexPath.row == 1) {
        self.desTextView.textColor = UIColorFromRGB(0xFE403B);
        _pointView.backgroundColor = UIColorFromRGB(0xF84A73);
        _pointView.layer.cornerRadius = BIGPOINT_CORNERRADIUS;
        _pointView.layer.masksToBounds = YES;
        _pointView.layer.borderColor = UIColorFromRGB(0xFABFBE).CGColor;
        _pointView.layer.shadowOpacity = 0.2;
        _pointView.layer.borderWidth = 3;
        
        [self.pointView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(BIGPOINT_CORNERRADIUS * 2, BIGPOINT_CORNERRADIUS * 2));
            make.top.equalTo(self.contentView).offset(10);
            make.centerX.equalTo(self.contentView.mas_left).offset(25);
        }];
        
        [self.columnLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.top.equalTo(self.pointView.mas_bottom);
            make.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.pointView);
        }];
    }
    else {
        _desTextView.textColor = [UIColor darkGrayColor];
        _timeLabel.textColor = [UIColor lightGrayColor];
        
        _pointView.backgroundColor = UIColorFromRGB(0xD8D8D8);
        _pointView.layer.cornerRadius = SMALLPOINT_CORNERRADIUS;
        _pointView.layer.masksToBounds = YES;
        _pointView.layer.borderColor = [UIColor clearColor].CGColor;
        _pointView.layer.borderWidth = 0;
        
        [self.pointView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SMALLPOINT_CORNERRADIUS * 2, SMALLPOINT_CORNERRADIUS * 2));
            make.top.equalTo(self.contentView).offset(10);
            make.centerX.equalTo(self.contentView.mas_left).offset(25);
        }];
        
        [self.columnLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.pointView);
        }];
    }
    
    //必须要设置
    CGFloat preMaxWaith = SCREEN_WIDTH - 65;
    [self.timeLabel setPreferredMaxLayoutWidth:preMaxWaith];
    
    if ([model isKindOfClass:[FKYDeliveryItemModel class]]) {
        FKYDeliveryItemModel *_model = (FKYDeliveryItemModel *)model;
        NSString *remark = [_model.remark stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        self.desTextView.text = remark;
        //self.desTextView.text = _model.remark;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.doOpTime/1000];
        self.timeLabel.text = [self.timeFormatter stringFromDate:date];
    }
    else if ([model isKindOfClass:[RCExpressInfoModel class]]) {
        RCExpressInfoModel *_model = (RCExpressInfoModel *)model;
        NSString *remark = [_model.context stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        self.desTextView.text = remark;
        //self.desTextView.text = _model.context;
        self.timeLabel.text = _model.ftime;
    }
    else if ([model isKindOfClass:[RCLogistInfoModel class]]) {
        RCLogistInfoModel *_model = (RCLogistInfoModel *)model;
        NSString *remark = [_model.remark stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        self.desTextView.text = remark;
        //self.desTextView.text = _model.remark;
        self.timeLabel.text = _model.doOpTime;
    }
    
    [self markPhoneNumberWithIndex:indexPath.row];
    
    // 更新desTextView高度
    CGSize newSize = [self.desTextView sizeThatFits:CGSizeMake(preMaxWaith, CGFLOAT_MAX)];
    [self.desTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(newSize);
    }];
    
    [self layoutIfNeeded];
    
    // 无内容时不展示楼层
    NSString *remark = self.desTextView.text;
    if (!remark || remark.length == 0) {
        self.pointView.hidden = YES;
        self.columnLine.hidden = YES;
        self.bottomLine.hidden = YES;
        self.desTextView.hidden = YES;
        self.timeLabel.hidden = YES;
    }
    else {
        self.pointView.hidden = NO;
        self.columnLine.hidden = NO;
        self.bottomLine.hidden = NO;
        self.desTextView.hidden = NO;
        self.timeLabel.hidden = NO;
    }
}

- (CGFloat)calulateHeightWithModel:(id)model indexPath:(NSIndexPath *)indexPath
{
    [self configureModel:model indexPath:indexPath];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

#pragma mark - private

- (void)markPhoneNumberWithIndex:(NSInteger)index
{
    NSString *tempStr = self.desTextView.text;
    if (!tempStr.length) { return; }
    
    // 初始化富文本
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName : (index>1 ? [UIColor darkGrayColor] : UIColorFromRGB(0xFE403B))};
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tempStr attributes:attributes];

    //正则匹配
    NSString *regular = @"1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}";
    NSError *error = nil;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regular options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:tempStr options:0 range:NSMakeRange(0, tempStr.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            // 电话号码字符串
            NSString *actionString = [tempStr substringWithRange:result.range];
            // 电话号码 高亮、下划线、添加链接
            NSDictionary *attributes = @{NSUnderlineStyleAttributeName : [NSNumber numberWithInt:kCTUnderlineStyleSingle],
                                         NSForegroundColorAttributeName : UIColorFromRGB(0x1F95E0),
                                         NSLinkAttributeName : [NSString stringWithFormat:@"phonenumber://%@", actionString]};
            [attString addAttributes:attributes range:result.range];
        }];
    }
    self.desTextView.attributedText = attString;
}

#pragma mark - property

- (UIView *)pointView
{
    if (_pointView == nil) {
        _pointView = [UIView new];
        _pointView.backgroundColor = [UIColor lightGrayColor];
        _pointView.layer.cornerRadius = SMALLPOINT_CORNERRADIUS;
        _pointView.layer.masksToBounds = YES;
    }
    return _pointView;
}

- (UIView *)columnLine
{
    if (_columnLine == nil) {
        _columnLine = [UIView new];
        _columnLine.alpha = 0.5;
        _columnLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
    }
    return _columnLine;
}

- (UIView *)bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [UIView new];
        _bottomLine.alpha = 0.5;
        _bottomLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
    }
    return _bottomLine;
}

- (UITextView *)desTextView
{
    if (_desTextView == nil) {
        _desTextView = [UITextView new];
        _desTextView.delegate = self;
        _desTextView.font = [UIFont systemFontOfSize:14];
        _desTextView.textColor = [UIColor darkGrayColor];
        _desTextView.textContainer.lineFragmentPadding = 0;
        _desTextView.textContainerInset = UIEdgeInsetsZero;
        _desTextView.editable = NO;
        _desTextView.scrollEnabled = NO;
    }
    return _desTextView;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel new];
        _timeLabel.numberOfLines = 0;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

- (NSDateFormatter *)timeFormatter
{
    if (_timeFormatter == nil) {
        _timeFormatter = [[NSDateFormatter alloc]init];
        [_timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _timeFormatter;
}

@end
