//
//  FKYFullGiftTableViewCell.m
//  FKY
//
//  Created by 乔羽 on 2018/6/5.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYFullGiftTableViewCell.h"
#import "UILabel+FKYKit.h"



@interface FKYFullGiftCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imgView;

- (void)configCell:(NSString *)imgUrl;

@end


@implementation FKYFullGiftCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)configCell:(NSString *)imgUrl {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageWithColor:[UIColor groupTableViewBackgroundColor]]];
}

@end


@interface FKYFullGiftTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *descL;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation FKYFullGiftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dataSource = @[];
        [self p_setupUI];
    }
    return self;
}

- (void)p_setupUI{
    
    self.titleL = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(20));
            make.top.equalTo(self.contentView.mas_top).offset(FKYWH(4));
            make.width.equalTo(@(56));
        }];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:2/255.0 green:2/255.0 blue:2/255.0 alpha:1/1.0];
        label;
    });
    
    self.descL = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleL.mas_right);
            make.right.equalTo(self.contentView.mas_right).offset(-FKYWH(20));
            make.top.equalTo(self.titleL.mas_top);
        }];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1/1.0];
        label.numberOfLines = 0;
        label;
    });
    
    self.collectionView = ({
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(76, 76);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = false;
        collectionView.scrollEnabled = false;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        collectionView.scrollIndicatorInsets = collectionView.contentInset;
        
        [collectionView registerClass:[FKYFullGiftCollectionViewCell class] forCellWithReuseIdentifier:@"FKYFullGiftCollectionViewCell"];
        
        [self.contentView addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleL.mas_right);
            make.top.equalTo(self.descL.mas_bottom).offset(10);
            make.right.equalTo(self.descL.mas_right);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        collectionView;
    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FKYFullGiftCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FKYFullGiftCollectionViewCell" forIndexPath:indexPath];
    FKYFullGiftImg * img = self.dataSource[indexPath.row];
    [cell configCell:img.giftImgUrl];
    return cell;
}

- (void)configCell:(FKYFullGiftActionSheetModel *)model index:(NSInteger)index {
    _titleL.text = [NSString stringWithFormat:@"规则%ld：", index+1];
    _descL.text = model.promotionRuleMsg;
    _dataSource = model.giftInfoList;
    [_collectionView reloadData];
}


@end


