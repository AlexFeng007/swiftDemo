//
//  QualificationSegmentViewCCell.swift
//  FKY
//
//  Created by Rabe on 02/04/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

class QualificationSegmentViewCCell: UICollectionViewCell {
    fileprivate lazy var segment: HMSegmentedControl = {
        let titles = ["批发企业", "零售企业", "批零一体"]
        let sv: HMSegmentedControl = HMSegmentedControl(sectionTitles: titles)
        sv.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor : RGBColor(0x343434),
             NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))]
        sv.selectedTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor : RGBColor(0xff394e),
             NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))]
        sv.selectionIndicatorColor = RGBColor(0xff2d5c)
        sv.selectionIndicatorHeight = 2
        sv.selectionStyle = .textWidthStripe
        sv.selectionIndicatorLocation = .down
        sv.indexChangeBlock = { [weak self] index in
            if let strongSelf = self {
                if let indexChangeBlock = strongSelf.indexChangeBlock {
                    indexChangeBlock(index)
                }
            }
        }
        return sv
    }()
    
    var indexChangeBlock: ((_ index: Int)->())?
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        let line = UIView()
        line.backgroundColor = RGBColor(0xf5f5f5)
        contentView.addSubview(line)
        
        contentView.addSubview(segment)
        segment.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(contentView)
            make.bottom.equalTo(line.snp.top)
        })
        
        line.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

