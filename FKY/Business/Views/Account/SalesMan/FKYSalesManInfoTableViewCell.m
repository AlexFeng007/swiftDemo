//
//  FKYSalesManInfoTableViewCell.m
//  FKY
//
//  Created by 寒山 on 2018/4/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYSalesManInfoTableViewCell.h"
#import "FMLinkLabel.h"
#import <Masonry/Masonry.h>


@interface FKYSalesManInfoTableViewCell()
@property (nonatomic, strong) UILabel *salesManNameLabel;     //业务员的名字
@property (nonatomic, strong) FMLinkLabel *salesManPhoneLabel;    //业务员电话
@end

@implementation FKYSalesManInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.salesManNameLabel = ({
        UILabel *label = [UILabel new];
        label.font = FKYSystemFont(FKYWH(14));
        label.textColor = UIColorFromRGB(0x000000);
        label.text = @"对应业务员";
        [label sizeToFit];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(FKYWH(10));
            make.centerY.equalTo(self.contentView);
        }];
        label;
    });
    
    self.salesManPhoneLabel = ({
        FMLinkLabel *label = [FMLinkLabel new];
        label.font = FKYSystemFont(FKYWH(14));
        label.textColor = UIColorFromRGB(0x000000);
        [label sizeToFit];
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(FKYWH(-20));
            make.centerY.equalTo(self.contentView);
        }];
        label;
    });
    
}
-(void)configCell:(FKYSalesManModel*)model{
    self.salesManPhoneLabel.text = [NSString stringWithFormat:@"%@    %@",model.name,model.mobile];
    [self.salesManPhoneLabel addClickText:model.mobile attributeds:@{NSForegroundColorAttributeName : UIColorFromRGB(0x3580FA)} transmitBody:(id)model.mobile clickItemBlock:^(id transmitBody) {
       // [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", transmitBody] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil] show];
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
