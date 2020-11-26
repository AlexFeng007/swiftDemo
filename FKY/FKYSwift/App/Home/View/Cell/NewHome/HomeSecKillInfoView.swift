//
//  HomeSecKillInfoView.swift
//  FKY
//
//  Created by 寒山 on 2020/4/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomeSecKillInfoView: UIView {
    //var checkRecommendBlock: ((HomeSecdKillProductModel)->())? //查看推荐的楼层
    var clickProductBlock: ((HomeRecommendProductItemModel?,HomeSecdKillProductModel)->())? //点击商品进楼层
    var cellModel : HomeSecdKillProductModel? //数据模型
    var cellType:HomeCellType?
    /// 当前页面的布局类型 1 代表1个秒杀占一整个楼层 2代表2个秒杀占一整个楼层
    var layoutType:Int = 0
    //顶部视图
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    //一级标题
    fileprivate lazy var proTypeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(15))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        return label
    }()
    //    //倒计时视图背景
    //    fileprivate lazy var timeCountView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = RGBColor(0xFFFFFF)
    //        view.layer.masksToBounds = true
    //        view.layer.borderWidth = WH(1)
    //        view.layer.borderColor = RGBColor(0xFF2D5C).cgColor
    //        view.layer.cornerRadius =  WH(8)
    //        return view
    //    }()
    //    //倒计时title
    //    fileprivate lazy var timeTitleLabel: UILabel = {
    //        let label = UILabel()
    //        label.font = UIFont.systemFont(ofSize: WH(10))
    //        label.textColor = UIColor.white
    //        label.backgroundColor = RGBColor(0xFF2D5C)
    //        label.textAlignment  = .center
    //        label.text = "距结束"
    //        return label
    //    }()
    //倒计时视图
    fileprivate lazy var countTimeView : HomeSecKillCountView = {
        let counView = HomeSecKillCountView()
        counView.backgroundColor = .white
        return counView
    }()
    //商品列表
    fileprivate lazy var bottomView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(HomeSecKillProductCell.self, forCellWithReuseIdentifier: "HomeSecKillProductCell")
        view.register(HomeSingleSecKillProductCell.self, forCellWithReuseIdentifier: "HomeSingleSecKillProductCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func setupView() {
        backgroundColor = UIColor.white
        self.addSubview(topView)
        self.addSubview(proTypeNameLabel)
        //        self.addSubview(timeCountView)
        //        timeCountView.addSubview(timeTitleLabel)
        self.addSubview(countTimeView)
        self.addSubview(bottomView)
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        proTypeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(13))
            make.left.equalTo(self).offset(WH(14))
            make.width.lessThanOrEqualTo(WH(72))
        }
        
        //        timeCountView.snp.makeConstraints { (make) in
        //            make.centerY.equalTo(proTypeNameLabel.snp.centerY)
        //            make.left.equalTo(proTypeNameLabel.snp.right).offset(WH(6))
        //            make.width.equalTo(WH(0))
        //            make.height.equalTo(WH(16))
        //        }
        //
        //        timeTitleLabel.snp.makeConstraints { (make) in
        //            make.centerY.equalTo(timeCountView.snp.centerY)
        //            make.left.equalTo(timeCountView.snp.left)
        //            make.width.equalTo(WH(36))
        //            make.height.equalTo(WH(16))
        //        }
        countTimeView.snp.makeConstraints { (make) in
            make.centerY.equalTo(proTypeNameLabel.snp.centerY)
            make.left.equalTo(proTypeNameLabel.snp.right).offset(WH(6))
            make.width.equalTo(WH(0))
            make.height.equalTo(WH(16))
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(39))
            make.left.right.bottom.equalTo(self)
            
        }
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickProductBlock,strongSelf.cellModel != nil {
                closure(nil,strongSelf.cellModel!)
            }
        }).disposed(by: disposeBag)
        topView.addGestureRecognizer(tapGesture)
    }
}

//MARK: 数据展示
extension HomeSecKillInfoView{
    func configCell(_ cellModel : HomeSecdKillProductModel,_ layoutType:Int) {
        self.layoutType = layoutType
        self.cellModel = cellModel
        self.configViewData(cellModel)
        self.bottomView.reloadData()
    }
    
    func configViewData(_ cellModel : HomeSecdKillProductModel){
        self.countTimeView.resetAllData() //防止重用
        //秒杀
        self.configCount(cellModel)
        self.proTypeNameLabel.text = cellModel.name
    }
    
    func configCount(_ model :HomeSecdKillProductModel){
        
        guard let start = model.upTimeMillis else {
            // 无起始时间
            countTimeView.isHidden = true
            // timeCountView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        guard let current = model.sysTimeMillis else {
            // 系统时间
            countTimeView.isHidden = true
            //timeCountView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        
        //let currentSecond = NSDate().timeIntervalSince1970
        guard let end = model.downTimeMillis else {
            // 无截止时间...<活动一直存在，但不显示倒计时>
            countTimeView.isHidden = true
            // timeCountView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        
        // 毫秒转秒
        let startSecond = start / 1000
        let endSecond = end / 1000
        let currentSecond = current / 1000 + FKYTimerManager.timerManagerShared.allCount
        guard Int64(currentSecond) >= startSecond, Int64(currentSecond) <= endSecond else {
            // 3个时间戳均有值，但不符合倒计时要求
            countTimeView.isHidden = true
            // timeCountView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        // 毫秒转秒
        let timeInterval = endSecond - Int64(currentSecond)
        guard timeInterval > 0 else {
            // 刚好在截止时间的那一秒刷到数据
            countTimeView.isHidden = true
            // timeCountView.isHidden = true
            countTimeView.resetAllData()
            countTimeView.refreshAgainWhenTimeOver()
            return
        }
        // 开始倒计时
        countTimeView.isHidden = false
        //timeCountView.isHidden = false
        countTimeView.configData(timeInterval, model)
        let countHeight = HomeSecKillCountView.getCountViewWidth(timeInterval)
        countTimeView.snp.updateConstraints { (make) in
            make.width.equalTo(countHeight)
        }
        if self.layoutType == 2{
            let lessWidth = ((SCREEN_WIDTH - WH(20))/2.0 - (countHeight) - WH(14) - WH(6) - WH(6)) > 0 ? ((SCREEN_WIDTH - WH(20))/2.0 - (countHeight) - WH(14) - WH(6) - WH(6)) :0
            proTypeNameLabel.snp.updateConstraints { (make) in
                make.width.lessThanOrEqualTo(lessWidth)
            }
        }else if self.layoutType == 1{
            let lessWidth = (SCREEN_WIDTH - WH(20)  - (countHeight) - WH(14) - WH(6) - WH(6)) > 0 ? (SCREEN_WIDTH - WH(20)  - (countHeight) - WH(14) - WH(6) - WH(6)):0
            proTypeNameLabel.snp.updateConstraints { (make) in
                make.width.lessThanOrEqualTo(lessWidth)
            }
        }
    }
}

extension HomeSecKillInfoView{
    func configHomePromotionCell(_ cellModel : HomeSecdKillProductModel,_ cellType:HomeCellType?) {
        self.cellType = cellType
        self.cellModel = cellModel
        self.configData(cellModel)
        self.bottomView.reloadData()
    }
    func configData(_ cellModel : HomeSecdKillProductModel){
        //隐藏动态ui视图å
        //        self.countTimeView.isHidden = false
        self.countTimeView.resetAllData() //防止重用
        //秒杀
        self.resetCountView(cellModel)
        self.proTypeNameLabel.text = cellModel.name
    }
    //设置倒计时
    func resetCountView(_ model :HomeSecdKillProductModel) {
        //        guard let showFlag = model.countDownFlag, showFlag == 1 else {
        //            // 不显示倒计时
        //            countTimeView.isHidden = true
        //            countTimeView.resetAllData()
        //            return
        //        }
        
        guard let start = model.upTimeMillis else {
            // 无起始时间
            countTimeView.isHidden = true
            // timeCountView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        guard let current = model.sysTimeMillis else {
            // 系统时间
            countTimeView.isHidden = true
            //timeCountView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        
        //let currentSecond = NSDate().timeIntervalSince1970
        guard let end = model.downTimeMillis else {
            // 无截止时间...<活动一直存在，但不显示倒计时>
            countTimeView.isHidden = true
            // timeCountView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        
        // 毫秒转秒
        let startSecond = start / 1000
        let endSecond = end / 1000
        let currentSecond = current / 1000 + FKYTimerManager.timerManagerShared.allCount
        guard Int64(currentSecond) >= startSecond, Int64(currentSecond) <= endSecond else {
            // 3个时间戳均有值，但不符合倒计时要求
            countTimeView.isHidden = true
            // timeCountView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        // 毫秒转秒
        let timeInterval = endSecond - Int64(currentSecond)
        guard timeInterval > 0 else {
            // 刚好在截止时间的那一秒刷到数据
            countTimeView.isHidden = true
            // timeCountView.isHidden = true
            countTimeView.resetAllData()
            countTimeView.refreshAgainWhenTimeOver()
            return
        }
        // 开始倒计时
        countTimeView.isHidden = false
        //timeCountView.isHidden = false
        countTimeView.configData(timeInterval, model)
        let countHeight = HomeSecKillCountView.getCountViewWidth(timeInterval)
        countTimeView.snp.updateConstraints { (make) in
            make.width.equalTo(countHeight)
        }
    }
}
extension  HomeSecKillInfoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = self.cellModel ,let arr = model.floorProductDtos{
            //秒杀
            if self.layoutType == 2{
                return (arr.count > 2) ? 2 : arr.count
            }else if self.layoutType == 1{
                return (arr.count > 4) ? 4 : arr.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let model = self.cellModel ,let arr = model.floorProductDtos {
            if arr.count == 1 {
                return CGSize(width:(SCREEN_WIDTH/2.0 - WH(10) - WH(16)), height:WH(106))
            }
        }
        if self.layoutType == 2{
            return CGSize(width:(SCREEN_WIDTH/2.0 - WH(10) - WH(16))/2.0, height:WH(106))
        }else if self.layoutType == 1{
            return CGSize(width:(SCREEN_WIDTH - WH(20) - WH(16))/4.0, height:WH(106))
        }
        return CGSize(width:WH(68), height:WH(106))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(9), left: WH(8), bottom: WH(0), right: WH(8))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let model = self.cellModel ,let arr = model.floorProductDtos {
            //秒杀
            if arr.count == 1{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSingleSecKillProductCell", for: indexPath) as! HomeSingleSecKillProductCell
                cell.configCell(arr[indexPath.item],model)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSecKillProductCell", for: indexPath) as! HomeSecKillProductCell
            cell.configCell(arr[indexPath.item],model)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSecKillProductCell", for: indexPath) as! HomeSecKillProductCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.cellModel ,let arr = model.floorProductDtos{
            if let bolck = self.clickProductBlock,self.cellModel != nil{
                bolck(arr[indexPath.item],self.cellModel!)
            }
        }
    }
}
