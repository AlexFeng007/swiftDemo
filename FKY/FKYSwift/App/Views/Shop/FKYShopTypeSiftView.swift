//
//  FKYShopTypeSiftView.swift
//  FKY
//
//  Created by hui on 2018/11/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
class FKYSiftTitleCell: UICollectionViewCell {
    // 标题视图
    fileprivate var shopSiftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    //MARK:初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:UI布局
    func setupView() {
        addSubview(shopSiftTitleLabel)
        shopSiftTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(WH(20))
            make.right.equalTo(self.snp.right).offset(-WH(10))
            make.top.bottom.equalTo(self)
        }
    }
    func configTitle(_ title : String?)  {
        shopSiftTitleLabel.text = title ?? ""
    }
}
class FKYShopSiftCell: UICollectionViewCell {
    //筛选名称
    fileprivate var shopSiftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .center
        label.layer.cornerRadius = WH(4)
        label.layer.masksToBounds = true
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        self.contentView.addSubview(shopSiftLabel)
        shopSiftLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    func configData(_ isSelected:Bool,_ tagStr:String){
        shopSiftLabel.text = tagStr
        if isSelected == true {
            //被选中
            shopSiftLabel.textColor = RGBColor(0xFF2D5C)
            shopSiftLabel.backgroundColor = RGBColor(0xFFEDE7)
            shopSiftLabel.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            shopSiftLabel.layer.borderWidth = WH(1)
        }else {
            //未被选中
            shopSiftLabel.textColor = RGBColor(0x333333)
            shopSiftLabel.backgroundColor = RGBColor(0xF4F4F4)
            shopSiftLabel.layer.borderWidth = WH(0)
        }
    }
}

class FKYShopTypeSiftView: UIView {
    //类型标签列表
    lazy var shopSiftCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = WH(10)
        flowLayout.minimumInteritemSpacing = WH(10)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYShopSiftCell.self, forCellWithReuseIdentifier: "FKYShopSiftCell")
        view.register(FKYSiftTitleCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FKYSiftTitleCell")
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.white
        view.delegate = self
        view.dataSource = self
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    fileprivate lazy var resetSiftBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = RGBColor(0xFFFFFF)
        btn.setTitle("重置", for: .normal)
        btn.titleLabel?.font = t36.font
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        return btn
    }()
    fileprivate lazy var certainSiftBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = RGBColor(0xFF2D5C)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = t36.font
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        return btn
    }()
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    var deliveriesDataArr : Array<FKYShopSiftModel>?//店铺快递筛选
    var serviceDataArr : Array<FKYShopSiftModel>?//服务标签筛选
    fileprivate var selectedIndexArr : Array<IndexPath> = Array() //存被选中的item编号
    fileprivate var selectedDesIndexArr : Array<IndexPath> = Array() //存被已经确认过选中的item编号
    //获取选中的字符串
    var deliveriesStr : String {
        get {
            var str = ""
            if selectedDesIndexArr.count > 0 {
                for indexPath in self.selectedDesIndexArr {
                    if indexPath.section == 0 {
                        if let model = self.deliveriesDataArr?[indexPath.row] ,let strId = model.tagId  {
                            if str == "" {
                                str = strId
                            }else {
                                str = str+","+strId
                            }
                        }
                    }
                }
                return str
            }
            return str
        }
    }
    var serviceStr : String {
        get {
            var str = ""
            if self.selectedDesIndexArr.count > 0 {
                for indexPath in self.selectedDesIndexArr {
                    if indexPath.section == 1 {
                        if let model = self.serviceDataArr?[indexPath.row] ,let strId = model.tagId  {
                            if str == "" {
                                str = strId
                            }else {
                                str = str+","+strId
                            }
                        }
                    }
                }
                return str
            }
            return str
        }
    }
    var clickTypeBtn : viewClosure? //点击按钮
    var clickItem : ((IndexPath)->(Void))? //点击item
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView()  {
        self.backgroundColor = RGBAColor(0x000000, alpha: 0.6)
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            if let closure = self?.clickTypeBtn {
                closure(3)
                self?.selectedIndexArr.removeAll()
                if let arr = self?.selectedDesIndexArr , arr.count  > 0 {
                    self!.selectedIndexArr =  self!.selectedIndexArr + arr
                }
                self?.shopSiftCollectionView.reloadData()
            }
        }).disposed(by: disposeBag)
        self.addGestureRecognizer(tapGesture)
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(ceil(SCREEN_WIDTH-WH(69)))
        }
        let topH = naviBarHeight() - WH(44) + WH(12) //距离顶部的距离
        let btnH = WH(54) + bootSaveHeight()//按钮的高度
        bgView.addSubview(shopSiftCollectionView)
        shopSiftCollectionView.snp.makeConstraints { (make) in
            make.right.equalTo(bgView.snp.right)
            make.top.equalTo(bgView.snp.top).offset(topH)
            make.width.equalTo(ceil(SCREEN_WIDTH-WH(69)))
            make.height.equalTo(SCREEN_HEIGHT-btnH)
        }
        //重置按钮
        bgView.addSubview(resetSiftBtn)
        resetSiftBtn.frame = CGRect.init(x:0, y:SCREEN_HEIGHT-btnH, width: (SCREEN_WIDTH-WH(69))/2.0, height: btnH)
        resetSiftBtn.layer.shadowColor = RGBColor(0x000000).cgColor
        resetSiftBtn.layer.shadowOpacity = 0.1
        resetSiftBtn.layer.shadowOffset = CGSize.init(width: 0, height: -4)
        _ = resetSiftBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
               return
            }
            if let closure = strongSelf.clickTypeBtn {
                strongSelf.selectedIndexArr.removeAll()
                strongSelf.shopSiftCollectionView.reloadData()
                closure(1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        //确认按钮
        bgView.addSubview(certainSiftBtn)
        certainSiftBtn.frame = CGRect.init(x:(SCREEN_WIDTH-WH(69))/2.0, y:SCREEN_HEIGHT-btnH, width: (SCREEN_WIDTH-WH(69))/2.0, height: btnH)
        certainSiftBtn.layer.shadowColor = RGBColor(0x000000).cgColor
        certainSiftBtn.layer.shadowOpacity = 0.1
        certainSiftBtn.layer.shadowOffset = CGSize.init(width: 0, height: -4)
        _ = certainSiftBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
               return
            }
            if let closure = strongSelf.clickTypeBtn {
                strongSelf.selectedDesIndexArr.removeAll()
                strongSelf.selectedDesIndexArr = strongSelf.selectedDesIndexArr + strongSelf.selectedIndexArr
                closure(2)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
    }
    func refreshSiftData(_ deliveriesArr:Array<FKYShopSiftModel> ,_ serviceArr :Array<FKYShopSiftModel>) {
        self.deliveriesDataArr = deliveriesArr
        self.serviceDataArr = serviceArr
        self.shopSiftCollectionView.reloadData()
    }
    //清空数据
    func resetData(){
        selectedIndexArr.removeAll()
        selectedDesIndexArr.removeAll()
        self.shopSiftCollectionView.reloadData()
    }
}

extension FKYShopTypeSiftView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.deliveriesDataArr?.count ?? 0
        }else {
            return self.serviceDataArr?.count ?? 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WH(82), height: WH(30))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(15), left: WH(20), bottom: WH(20), right: WH(20))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if let arr = self.deliveriesDataArr,arr.count > 0 {
                return CGSize(width: WH(306), height: WH(20))
            }
        }else {
            if let arr = self.serviceDataArr,arr.count > 0 {
                return CGSize(width: WH(306), height: WH(20))
            }
        }
        return CGSize(width: WH(306), height: WH(0))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYShopSiftCell", for: indexPath) as! FKYShopSiftCell
        var name = ""
        if indexPath.section == 0 {
            if let model = self.deliveriesDataArr?[indexPath.row] {
                name = model.tagName ?? ""
            }
        }else {
            if let model = self.serviceDataArr?[indexPath.row] {
                name = model.tagName ?? ""
            }
        }
        if self.selectedIndexArr.contains(indexPath) == true {
            cell.configData(true,name)
        }else {
            cell.configData(false,name)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FKYSiftTitleCell", for: indexPath) as! FKYSiftTitleCell
        if indexPath.section == 0 {
            headerView.configTitle("快递公司")
        }else {
            headerView.configTitle("服务标签")
        }
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let closure = self.clickItem {
            closure(indexPath)
        }
        if self.selectedIndexArr.contains(indexPath) == true {
            let index = (self.selectedIndexArr as NSArray).index(of: indexPath)
            self.selectedIndexArr.remove(at: index)
        }else {
            self.selectedIndexArr.append(indexPath)
        }
        self.shopSiftCollectionView.reloadData()
    }
}
extension FKYShopTypeSiftView:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.shopSiftCollectionView) == true {
            return false
        }
        return true
    }
}
