//
//  FKYEnterBasequalificationTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/11/1.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

let ENTER_PIC_ITEM_H = WH(100) //资质图片高度
let ENTER_PIC_ITEM_W = (SCREEN_WIDTH-WH(15*3))/2.0 //2*n样式资质图片宽度

class FKYEnterBasequalificationTableViewCell: UITableViewCell {

    //MARK:ui
    //红色标
    fileprivate lazy var tagLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = t73.color
        return label
    }()
    //标题
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = t31.color
        label.font = UIFont.boldSystemFont(ofSize: WH(17))
        label.text = "企业资质"
        return label
    }()
    
    //商品列表
    fileprivate lazy var enterQualiView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = WH(14)
        flowLayout.minimumInteritemSpacing = WH(14)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(ShopDetailQcCell.self, forCellWithReuseIdentifier: "ShopDetailQcCell")
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.isScrollEnabled = false
        view.backgroundColor = RGBColor(0xffffff)
        return view
    }()
    //图片数组
    var picArr = [FKYEnterQuaPicModel]()  //
    var clickPicView : ((Int)->(Void))? //点击图片
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = RGBColor(0xffffff)
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.top.equalTo(contentView.snp.top).offset(WH(19))
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(3))
        })
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(tagLabel.snp.right).offset(WH(7))
            make.centerY.equalTo(tagLabel.snp.centerY)
            make.height.equalTo(WH(24))
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
        })
        contentView.addSubview(enterQualiView)
        enterQualiView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(17))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(7))
        })
    }
}

extension FKYEnterBasequalificationTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.picArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:ENTER_PIC_ITEM_W, height:ENTER_PIC_ITEM_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(15), bottom: WH(0), right: WH(15))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopDetailQcCell", for: indexPath) as! ShopDetailQcCell
        let model = self.picArr[indexPath.item]
        cell.configView(imgPath: model.filePath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! ShopDetailQcCell
        showPhotoBrowser(cell.img.image, superView: self, index: indexPath.item)
        if let block  = self.clickPicView {
            block(indexPath.item)
        }
    }
}
extension FKYEnterBasequalificationTableViewCell {
    func cofigEnterBaseQualificationViewData(_ dataArr:[FKYEnterQuaPicModel]) {
        self.picArr = dataArr
        self.enterQualiView.reloadData()
    }
    fileprivate func showPhotoBrowser(_ image: UIImage?, superView: UIView, index: Int) {
        // 老版查看大图
        guard image != nil else {
            return
        }
        let images = {
            return (0..<self.picArr.count).map { (i: Int) -> SKPhotoProtocol in
                let model = self.picArr[i]
                let photo = SKPhoto.photoWithImageURL(model.filePath ?? "")
                photo.shouldCachePhotoURLImage = true
                return photo
            }
        }()
        
        let browser = SKPhotoBrowser(originImage: image!, photos: images, animatedFromView: superView)
        browser.initializePageIndex(index)
        if #available(iOS 13, *) {
            browser.modalPresentationStyle = .fullScreen
        }
        FKYNavigator.shared().topNavigationController.present(browser, animated: true, completion: nil)
    }
    //计算高度
    static func configEnterBaseQualificationCellH(_ arrPic :[FKYEnterQuaPicModel]?) -> CGFloat{
        if let arr = arrPic ,arr.count > 0 {
            let picNum = arr.count
            var lineNum = picNum/2
            if picNum % 2 != 0 {
                lineNum = lineNum + 1
            }
            return CGFloat(lineNum)*(ENTER_PIC_ITEM_H + WH(14)) + WH(61)
        }
        return 0
        
    }
}
class ShopDetailQcCell: UICollectionViewCell {
    var img: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
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
        self.layer.cornerRadius = WH(8)
        self.layer.masksToBounds = true
        self.layer.borderWidth = WH(1)
        self.layer.borderColor = bg7.cgColor
        contentView.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    func configView(imgPath: String) {
        let imgDefault = UIImage.init(named: "image_placeholder_rect")
        img.image = imgDefault
        if let url = imgPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
            img.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
        }
    }
}


fileprivate class ShopDetailMsgHeaderView: UIView {
    // MARK: Life Style
    init(title: String) {
        super.init(frame: CGRect.null)
        
        let titleL: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = t12.font
            label.textColor = t14.color
            return label
        }()
        addSubview(titleL)
        
        let line2: UIView = {
            let view = UIView()
            view.backgroundColor = bg7
            return view
        }()
        addSubview(line2)
        
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(WH(15))
            make.centerY.equalTo(self)
        }
        
        line2.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/************************************************************/


