//
//  FKYNewprdDetailContentCell.swift
//  FKY
//
//  Created by yyc on 2020/3/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYNewprdDetailContentCell: UITableViewCell {
    //ui
    fileprivate lazy var cellBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.layer.cornerRadius = WH(8)
        view.layer.masksToBounds = true
        return view
    }()
    //信息状态视图
    fileprivate lazy var infoView : FKYNewPrdSetInfoVIew = {
        let view = FKYNewPrdSetInfoVIew()
        return view
    }()
    //手机号码
    fileprivate lazy var phoneLabelDes : UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.text = "手机号码："
        return label
    }()
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.textColor = t8.color
        label.font = t61.font
        return label
    }()
    //月均采购量
    fileprivate lazy var monthBuyLabelDes : UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.text = "月均采购量："
        return label
    }()
    fileprivate lazy var monthBuyLabel : UILabel = {
        let label = UILabel()
        label.textColor = t8.color
        label.font = t61.font
        return label
    }()
    //期望采购价
    fileprivate lazy var expectPriceLabelDes : UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.text = "期望采购价："
        return label
    }()
    fileprivate lazy var expectPriceLabel : UILabel = {
        let label = UILabel()
        label.textColor = t8.color
        label.font = t61.font
        return label
    }()
    fileprivate lazy var uploadPicsLabelDes : UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.text = "上传的图片："
        return label
    }()
    //图片列表
    fileprivate lazy var picArrCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewLeftAlignedLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = WH(8)
        flowLayout.minimumInteritemSpacing = WH(8)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYpicCell.self, forCellWithReuseIdentifier: "FKYpicCell")
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = RGBColor(0xffffff)
        view.bounces = false
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    fileprivate var picArr:[String]? //图片数组
    fileprivate var imagePicArr = [UIImageView]() //存放image数组
    var clickItem : ((Int)->(Void))? //点击图片
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension FKYNewprdDetailContentCell {
    fileprivate func setupView(){
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.contentView.addSubview(cellBgView)
        cellBgView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView.snp.right).offset(-WH(10))
            make.left.equalTo(self.contentView.snp.left).offset(WH(10))
        }
        cellBgView.addSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(cellBgView)
            make.height.greaterThanOrEqualTo(WH(44+100))
        }
        cellBgView.addSubview(phoneLabelDes)
        phoneLabelDes.snp.makeConstraints { (make) in
            make.top.equalTo(infoView.snp.bottom).offset(WH(13))
            make.left.equalTo(cellBgView.snp.left).offset(WH(15))
            make.height.equalTo(WH(13))
            //make.width.equalTo(WH(65))
        }
        cellBgView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneLabelDes)
            make.left.equalTo(phoneLabelDes.snp.right)
            make.right.equalTo(cellBgView.snp.right).offset(-WH(5))
        }
        cellBgView.addSubview(monthBuyLabelDes)
        monthBuyLabelDes.snp.makeConstraints { (make) in
            make.top.equalTo(phoneLabelDes.snp.bottom).offset(WH(16))
            make.left.equalTo(phoneLabelDes.snp.left)
            make.height.equalTo(WH(13))
            //make.width.equalTo(WH(78))
        }
        cellBgView.addSubview(monthBuyLabel)
        monthBuyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(monthBuyLabelDes)
            make.left.equalTo(monthBuyLabelDes.snp.right)
            make.right.equalTo(cellBgView.snp.right).offset(-WH(5))
        }
        cellBgView.addSubview(expectPriceLabelDes)
        expectPriceLabelDes.snp.makeConstraints { (make) in
            make.top.equalTo(monthBuyLabelDes.snp.bottom).offset(WH(8))
            make.left.equalTo(phoneLabelDes.snp.left)
            make.height.equalTo(WH(13))
            //make.width.equalTo(WH(78))
        }
        cellBgView.addSubview(expectPriceLabel)
        expectPriceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(expectPriceLabelDes)
            make.left.equalTo(expectPriceLabelDes.snp.right)
            make.right.equalTo(cellBgView.snp.right).offset(-WH(5))
        }
        cellBgView.addSubview(uploadPicsLabelDes)
        uploadPicsLabelDes.snp.makeConstraints { (make) in
            make.top.equalTo(expectPriceLabelDes.snp.bottom).offset(WH(16))
            make.left.equalTo(phoneLabelDes.snp.left)
            make.height.equalTo(WH(13))
        }
        cellBgView.addSubview(picArrCollectionView)
        picArrCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(uploadPicsLabelDes.snp.bottom).offset(WH(8))
            make.left.equalTo(cellBgView.snp.left).offset(WH(15))
            make.right.equalTo(cellBgView.snp.right).offset(-WH(15))
            make.bottom.equalTo(cellBgView.snp.bottom).offset(-WH(28))
            make.height.equalTo(WH(0))
        }
    }
}
extension FKYNewprdDetailContentCell {
    func configPrdDetailData(_ model:FKYNewPrdSetItemModel?,_ arr:[UIImageView]) {
        if let desModel = model {
            infoView.configNewPrdSetInfoViewData(model,2)
            self.phoneLabel.text = desModel.userPhone
            if let num = desModel.avgMonthSales {
                //有值
                self.monthBuyLabel.text = "\(num)"
                self.monthBuyLabelDes.isHidden = false
                self.monthBuyLabel.isHidden = false
                monthBuyLabelDes.snp.updateConstraints { (make) in
                    make.top.equalTo(phoneLabelDes.snp.bottom).offset(WH(16))
                    make.height.equalTo(WH(13))
                }
            }else {
                //无值
                self.monthBuyLabelDes.isHidden = true
                self.monthBuyLabel.isHidden = true
                monthBuyLabelDes.snp.updateConstraints { (make) in
                    make.top.equalTo(phoneLabelDes.snp.bottom).offset(WH(0))
                    make.height.equalTo(WH(0))
                }
            }
            if let priceNum = desModel.purchasePrice {
                //有值
                self.expectPriceLabel.text =  String.init(format:"￥%.2f", priceNum)
                self.expectPriceLabelDes.isHidden = false
                self.expectPriceLabel.isHidden = false
                expectPriceLabelDes.snp.updateConstraints { (make) in
                    make.top.equalTo(monthBuyLabelDes.snp.bottom).offset(WH(8))
                    make.height.equalTo(WH(13))
                }
            }else {
                //无值
                self.expectPriceLabelDes.isHidden = true
                self.expectPriceLabel.isHidden = true
                expectPriceLabelDes.snp.updateConstraints { (make) in
                    make.top.equalTo(monthBuyLabelDes.snp.bottom).offset(WH(0))
                    make.height.equalTo(WH(0))
                }
            }
            if let list = desModel.imagePaths,list.count > 0{
                self.picArr = desModel.imagePaths
                self.imagePicArr = arr
                self.picArrCollectionView.reloadData()
                self.picArrCollectionView.layoutIfNeeded()
                let picArrH = self.picArrCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.picArrCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(picArrH)
                }
                uploadPicsLabelDes.snp.updateConstraints { (make) in
                    make.top.equalTo(expectPriceLabelDes.snp.bottom).offset(WH(16))
                    make.height.equalTo(WH(13))
                }
                picArrCollectionView.snp.updateConstraints { (make) in
                    make.top.equalTo(uploadPicsLabelDes.snp.bottom).offset(WH(8))
                }
                uploadPicsLabelDes.isHidden = false
                picArrCollectionView.isHidden = false
            }else {
                //无图片隐藏
                uploadPicsLabelDes.snp.updateConstraints { (make) in
                    make.top.equalTo(expectPriceLabelDes.snp.bottom).offset(WH(0))
                    make.height.equalTo(WH(0))
                }
                picArrCollectionView.snp.updateConstraints { (make) in
                    make.top.equalTo(uploadPicsLabelDes.snp.bottom).offset(WH(0))
                }
                uploadPicsLabelDes.isHidden = true
                picArrCollectionView.isHidden = true
            }
        }
    }
    // 查看图片
    fileprivate func showPicList(_ index: Int) {
        if self.imagePicArr.count > 0 {
            let currentIndex = (self.imagePicArr.count > index ? index : 0)
            //计算出图片的位置
            if let layoutItem = self.picArrCollectionView.layoutAttributesForItem(at: IndexPath.init(item: index, section: 0)) {
                let desImage = self.imagePicArr[index]
                var scrollerY : CGFloat = 0
                if let tableview = self.superview as? UITableView {
                    scrollerY = tableview.contentOffset.y
                }
                let picArrH = self.picArrCollectionView.collectionViewLayout.collectionViewContentSize.height
                let desImageY = self.frame.origin.y+self.frame.height-WH(28)-picArrH + layoutItem.frame.origin.y + naviBarHeight() - scrollerY
                desImage.frame = CGRect.init(x: layoutItem.frame.origin.x+WH(25), y: desImageY, width: WH(62), height: WH(62))
            }
            let imageViewer = XHImageViewer.init()
            imageViewer.showPageControl = true
            imageViewer.userPageNumber = true
            imageViewer.hideWhenOnlyOne = true
            imageViewer.show(withImageViews: self.imagePicArr, selectedView: self.imagePicArr[currentIndex])
        }
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FKYNewprdDetailContentCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arr = self.picArr {
            return arr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //商品
        return CGSize(width:WH(62), height:WH(62))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYpicCell", for: indexPath) as! FKYpicCell
        if let arr = self.picArr {
            cell.configPicCellData(arr[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showPicList(indexPath.item)
        if let block = self.clickItem {
            block(indexPath.item)
        }
    }
    
}
//MARK:店铺类型标签
class FKYpicCell: UICollectionViewCell {
    //图片
    fileprivate lazy var prdImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = WH(4)
        self.layer.borderWidth = WH(1)
        self.layer.borderColor = RGBColor(0xE5E5E5).cgColor
        contentView.addSubview(prdImageView)
        prdImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    func configPicCellData(_ picStr:String?) {
        self.prdImageView.image = UIImage.init(named: "image_default_img")
        if  let urlStr = picStr , let strProductPicUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.prdImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
    }
}
