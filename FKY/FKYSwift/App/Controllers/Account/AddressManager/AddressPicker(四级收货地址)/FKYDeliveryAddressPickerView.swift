//
//  FKYDeliveryAddressPickerView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/8/27.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  地区选择视图控件...<仅针对用户的收货地址(收货地址改为四级地址)>

import UIKit

// 当前地址等级类型<共4级>
enum addressClassType: Int {
    case provice = 0        // 省
    case city = 1           // 市
    case district = 2       // 区
    case town = 3           // 镇（街道）
}


//MARK: -
class FKYDeliveryAddressPickerView: UIView,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    //MARK: - Property
    
    // 背景视图
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.backgroundColor = .clear
        return view
    }()
    
    // tap视图
    fileprivate lazy var tapView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        // dismiss
        view.bk_(whenTapped: {
            self.dismissWithAnimation()
            //self.resetAllAddressData()
        })
        return view
    }()
    
    // 内容视图
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = bg1
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // 标题
    lazy var titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(18))
        label.textColor = RGBColor(0x343434)
        label.text = "所在区域"
        return label
    }()
    
    // 取消btn
    fileprivate lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = bg1
        btn.setImage(UIImage(named: "icon_account_close"), for: UIControl.State())
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissWithAnimation()
            //self.resetAllAddressData()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 省btn...<标题>
    fileprivate lazy var provinceBtn: FKYAdressLocationButton = {
        let btn = FKYAdressLocationButton()
        btn.backgroundColor = bg1
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        btn.setTitleColor(RGBColor(0xFF394E), for: .highlighted)
        btn.setTitle("请选择", for: UIControl.State())
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.layerDecorate.position = CGPoint(x: strongSelf.provinceBtn.center.x, y: 1)
            strongSelf.mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        btn.frameUpdateClosure = {[weak self] (tag) in
            if let strongSelf = self {
                if .provice == strongSelf.layerDecorateWillMoveTo {
                    strongSelf.layerDecorate.position = CGPoint(x: strongSelf.provinceBtn.center.x, y: 1)
                }
            }
        }
        return btn
    }()
    
    // 市btn...<标题>
    fileprivate lazy var cityBtn: FKYAdressLocationButton = {
        let btn = FKYAdressLocationButton()
        btn.backgroundColor = bg1
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        btn.setTitleColor(RGBColor(0xFF394E), for: .highlighted)
        btn.setTitle("请选择", for: UIControl.State())
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.layerDecorate.position = CGPoint(x: strongSelf.cityBtn.center.x, y: 1)
            strongSelf.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        btn.frameUpdateClosure = {[weak self] (tag) in
            if let strongSelf = self {
                if .city == strongSelf.layerDecorateWillMoveTo {
                    strongSelf.layerDecorate.position = CGPoint(x: strongSelf.cityBtn.center.x, y: 1)
                }
            }
        }
        return btn
    }()
    
    // 区btn...<标题>
    fileprivate lazy var districtBtn: FKYAdressLocationButton = {
        let btn = FKYAdressLocationButton()
        btn.backgroundColor = bg1
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        btn.setTitleColor(RGBColor(0xFF394E), for: .highlighted)
        btn.setTitle("请选择", for: UIControl.State())
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.layerDecorate.position = CGPoint(x: strongSelf.districtBtn.center.x, y: 1)
            strongSelf.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * 2, y: 0), animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        btn.frameUpdateClosure = {[weak self] (tag) in
            if let strongSelf = self {
                if .district == strongSelf.layerDecorateWillMoveTo {
                    strongSelf.layerDecorate.position = CGPoint(x: strongSelf.districtBtn.center.x, y: 1)
                }
            }
        }
        return btn
    }()
    
    // 镇btn...<标题>
    fileprivate lazy var townBtn: FKYAdressLocationButton = {
        let btn = FKYAdressLocationButton()
        btn.backgroundColor = bg1
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        btn.setTitleColor(RGBColor(0xFF394E), for: .highlighted)
        btn.setTitle("请选择", for: UIControl.State())
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.layerDecorate.position = CGPoint(x: strongSelf.townBtn.center.x, y: 1)
            strongSelf.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * 3, y: 0), animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        btn.frameUpdateClosure = {[weak self] (tag) in
            if let strongSelf = self {
                if .town == strongSelf.layerDecorateWillMoveTo {
                    strongSelf.layerDecorate.position = CGPoint(x: strongSelf.townBtn.center.x, y: 1)
                }
            }
        }
        return btn
    }()
    
    // 底部指示器
    fileprivate lazy var layerDecorate: CALayer = {
        let layer: CALayer = CALayer()
        layer.backgroundColor = RGBColor(0xFF394E).cgColor
        return layer
    }()
    
    // 分隔线
    fileprivate lazy var separatorView: UIView = {
        let v = UIView()
        let bottomLine: CALayer = CALayer()
        bottomLine.backgroundColor = RGBColor(0xf4f4f4).cgColor
        bottomLine.frame = CGRect(x: 0, y: 1, width: SCREEN_WIDTH, height: 1)
        v.layer.addSublayer(bottomLine)
        v.backgroundColor = bg1
        return v
    }()
    
    // UIScrollView容器视图
    fileprivate lazy var mainScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.isPagingEnabled = true
        sv.isScrollEnabled = false
        return sv
    }()
    
    // 省
    fileprivate lazy var provinceTableView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(EnterpriseTypeCell.self, forCellWithReuseIdentifier: "EnterpriseTypeCell")
        cv.backgroundColor = bg1
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // 市
    fileprivate lazy var cityTableView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(EnterpriseTypeCell.self, forCellWithReuseIdentifier: "EnterpriseTypeCell")
        cv.backgroundColor = bg1
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // 区
    fileprivate lazy var districtTableView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(EnterpriseTypeCell.self, forCellWithReuseIdentifier: "EnterpriseTypeCell")
        cv.backgroundColor = bg1
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // 镇
    fileprivate lazy var townTableView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(EnterpriseTypeCell.self, forCellWithReuseIdentifier: "EnterpriseTypeCell")
        cv.backgroundColor = bg1
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // 以上为视图控件
    /*******************************************************/
    // 以下为数据源
    
    // 内容高度
    fileprivate var contentHeight: CGFloat = WH(390)
    // 列表高度
    fileprivate var listHeight: CGFloat = WH(310)
    // 定位按钮布局偏移量
    fileprivate var locationButtonTopoffset: CGFloat = 0
    // 底部指示器位置
    fileprivate var layerDecorateWillMoveTo: addressClassType = .provice
    
    // 数据提供类...<采用protocol方式，数据源可能来自本地数据库db文件，也可能来自实时的网络请求>
    fileprivate var addressProvider: FKYAddressProviderProtocol
    
    // 实时查询到的各类数组
    fileprivate var provinceArray = [FKYAddressItemModel]()  // 省数组
    fileprivate var cityArray = [FKYAddressItemModel]()      // 市数组
    fileprivate var districtArray = [FKYAddressItemModel]()  // 区数组
    fileprivate var townArray = [FKYAddressItemModel]()      // 镇数组
    
    // 临时保存的原始省市区镇数据model
    fileprivate var provinceTemp: FKYAddressItemModel?    // 省
    fileprivate var cityTemp: FKYAddressItemModel?        // 市
    fileprivate var districtTemp: FKYAddressItemModel?    // 区
    fileprivate var townTemp: FKYAddressItemModel?        // 镇
    
    // 最终保存的省市区镇数据model
    var province: FKYAddressItemModel?    // 省
    var city: FKYAddressItemModel?        // 市
    var district: FKYAddressItemModel?    // 区
    var town: FKYAddressItemModel?        // 镇
    
    // closure
    var selectOverClosure: emptyClosure?
    var showLoadingClosure: ((Bool)->())?
    var showToastClosure: ((String?)->())?
    
    
    //MARK: - Init
    
    // 自定义的指定初始化方式
    init(Provider: FKYAddressProviderProtocol) {
        addressProvider = Provider
        super.init(frame: CGRect.zero)
        setupData()
        setupView()
        showProvince()
    }

    override init(frame: CGRect) {
        // 默认本地数据库来提供数据源
        addressProvider = FKYAddressLocalProvider()
        super.init(frame: frame)
        setupData()
        setupView()
        showProvince()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Data
    
    fileprivate func setupData() {
        // 内容高度
        let height = SCREEN_HEIGHT * 3 / 5
        contentHeight = height < WH(390) ? WH(390) : height
        
        // 列表高度
        listHeight = contentHeight - WH(98)
        
        // btn顶部间隔
        locationButtonTopoffset = WH(10)
        
        // 底部指示器位置
        layerDecorateWillMoveTo = .provice
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        // frame=screen
        addSubview(bgView)
        
        // tap视图
        bgView.addSubview(tapView)
        tapView.snp.makeConstraints { (make) in
            make.edges.equalTo(bgView)
        }
        
        // 内容视图
        bgView.addSubview(contentView)
        contentView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(bgView)
            make.height.equalTo(contentHeight)
        })
        
        /***************************************************/
        
        // 标题
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints({ (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(15))
        })
        
        // 取消
        contentView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints({ (make) in
            make.top.right.equalTo(contentView)
            make.height.width.equalTo(WH(44))
        })
        
        // 省
        contentView.addSubview(provinceBtn)
        provinceBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView).offset(WH(10))
            make.top.equalTo(titleLable.snp.bottom).offset(locationButtonTopoffset)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(72))
        })
        
        // 市
        contentView.addSubview(cityBtn)
        cityBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(provinceBtn.snp.right).offset(WH(10))
            make.top.equalTo(titleLable.snp.bottom).offset(locationButtonTopoffset)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(72))
        })
        
        // 区
        contentView.addSubview(districtBtn)
        districtBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(cityBtn.snp.right).offset(WH(10))
            make.top.equalTo(titleLable.snp.bottom).offset(locationButtonTopoffset)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(72))
        })
        
        // 镇
        contentView.addSubview(townBtn)
        townBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(districtBtn.snp.right).offset(WH(10))
            make.top.equalTo(titleLable.snp.bottom).offset(locationButtonTopoffset)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(72))
            make.right.lessThanOrEqualTo(contentView).offset(0)
        })
        
        // 底部指示器
        layerDecorate.frame = CGRect(x: 0, y: 0, width: WH(60), height: 2)
        layerDecorate.position = CGPoint(x: WH(10)+WH(72)/2, y: 1)
        separatorView.layer.addSublayer(layerDecorate)
        
        // 分隔线
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(contentView)
            make.height.equalTo(2)
            make.top.equalTo(provinceBtn.snp.bottom).offset(1)
        })
        
        //mainScrollView.contentSize = CGSize.init(width: SCREEN_WIDTH * 4, height: WH(310))
        contentView.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(listHeight)
        })
        
        /***************************************************/
        
        // 省<列表>
        mainScrollView.addSubview(provinceTableView)
        provinceTableView.snp.makeConstraints({ (make) in
            make.top.left.bottom.equalTo(mainScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(listHeight)
        })
        
        // 市<列表>
        mainScrollView.addSubview(cityTableView)
        cityTableView.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(mainScrollView)
            make.left.equalTo(provinceTableView.snp.right)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(listHeight)
        })
        
        // 区<列表>
        mainScrollView.addSubview(districtTableView)
        districtTableView.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(mainScrollView)
            make.left.equalTo(cityTableView.snp.right)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(listHeight)
        })
        
        // 镇<列表>
        mainScrollView.addSubview(townTableView)
        townTableView.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(mainScrollView)
            make.left.equalTo(districtTableView.snp.right)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(listHeight)
        })
    }
    
    
    //MARK: - ShowProvince
    func showProvince() {
        DispatchQueue.global().async {
            // 子线程查询省列表
            self.getProvinceList {[weak self] (list) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    // 主线程更新UI
                    strongSelf.provinceTableView.reloadData()
                }
            }
        }
    }
}


//MARK: - Public
extension FKYDeliveryAddressPickerView {
    // 显示
    func showWithAnimation() {
        // 先设置
        self.backgroundColor = RGBAColor(0x0, alpha: 0.0)
        self.bgView.center = CGPoint(x: SCREEN_WIDTH / 2.0, y: (3 * SCREEN_HEIGHT) / 2.0)
        
        // 再动画
        UIView.animate(withDuration: 0.35, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backgroundColor = RGBAColor(0x0, alpha: 0.5)
            strongSelf.bgView.center = CGPoint(x: SCREEN_WIDTH / 2.0, y: SCREEN_HEIGHT / 2.0)
        },completion: {(complete) in
            //
        })
    }
    
    // 隐藏
    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.35, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backgroundColor = RGBAColor(0x0, alpha: 0.0)
            strongSelf.bgView.center = CGPoint(x: SCREEN_WIDTH / 2.0, y: (3 * SCREEN_HEIGHT) / 2.0)
        }, completion: {[weak self] (complete) in
            guard let strongSelf = self else {
                return
            }
            if let superview = strongSelf.superview {
                superview.sendSubviewToBack(strongSelf)
            }
        })
    }
    
    // 若用户之前有已经选择的地址项，则再次弹出视图时，默认需要勾选上
    func showSelectStatus() {
        // 至少需要有省数据
        guard let pro = province, let code = pro.code, let name = pro.name, !code.isEmpty, !name.isEmpty else {
            resetAllAddressData()
            return
        }
        
        // 备份
        backupOriginalAddressData()
        
        // 查询 & 显示
        if let closure = showLoadingClosure {
            print("begin")
            closure(true)
        }
        queryAndShowAllAddressInfo { 
            if let closure = self.showLoadingClosure {
                print("over")
                closure(false)
            }
        }
    }
}


//MARK: - Private
extension FKYDeliveryAddressPickerView {
    // 地址选择流程完成
    @objc fileprivate func selectAddressOver () {
        saveAddressDataForSelect()
        if let closure = selectOverClosure {
            closure()
        }
        dismissWithAnimation()
        //resetAllAddressData()
    }
    
    // 备份原始的地址数据...<用户操作过程中，只修改备份数据，不使用原始数据>
    fileprivate func backupOriginalAddressData() {
        provinceTemp = province
        cityTemp = city
        districtTemp = district
        townTemp = town
    }
    
    // 保存用户选择的地址数据...<用户选择地址流程完成时，将最终的地址数据保存>
    fileprivate func saveAddressDataForSelect() {
        province = provinceTemp
        city = cityTemp
        district = districtTemp
        town = townTemp
    }
    
    // 重置到初始的显示状态
    fileprivate func resetShowStatus() {
        provinceTableView.reloadData()
        cityTableView.reloadData()
        districtTableView.reloadData()
        townTableView.reloadData()
        
        mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        layerDecorateWillMoveTo = .provice
        layerDecorate.position = CGPoint(x: provinceBtn.center.x, y: 1)
        
        // 重置collectionview内容缩进
//        provinceTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
//        cityTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
//        districtTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
//        townTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        
        provinceBtn.setTitle("请选择", for: UIControl.State())
        cityBtn.setTitle("请选择", for: UIControl.State())
        districtBtn.setTitle("请选择", for: UIControl.State())
        townBtn.setTitle("请选择", for: UIControl.State())
        
        // 更新约束
        let width = provinceBtn.singleLineLenght()
        provinceBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        provinceBtn.needsUpdateConstraints()
        cityBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        cityBtn.needsUpdateConstraints()
        districtBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        districtBtn.needsUpdateConstraints()
        townBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        townBtn.needsUpdateConstraints()
        self.contentView.layoutIfNeeded()
    }
    
    // 重置所有数据源
    fileprivate func resetAllAddressData() {
        // 数据源清理
        provinceArray.removeAll()
        cityArray.removeAll()
        districtArray.removeAll()
        townArray.removeAll()
        provinceTemp = nil
        cityTemp = nil
        districtTemp = nil
        townTemp = nil
        
        // 重置显示状态
        resetShowStatus()
        
        // 重拿省份数据并展示
        showProvince()
    }
    
    // 查询省、市、区、镇四级数组，并勾选
    fileprivate func queryAndShowAllAddressInfo(_ complete: @escaping ()->()) {
        // 获取省列表数据~!@
        getProvinceList { (list) in
            guard list.count > 0 else {
                // 无省列表数据
                self.showProvinceList()
                complete()
                return
            }
            
            // 至少需要有市数据
            guard let ci = self.city, let code = ci.code, let name = ci.name, !code.isEmpty, !name.isEmpty else {
                self.showProvinceList()
                complete()
                return
            }
            
            // 获取市列表数据~!@
            self.getCityList(self.province!, resultBlock: { (list) in
                guard list.count > 0 else {
                    // 无市列表数据
                    self.showProvinceList()
                    complete()
                    return
                }
                
                // 至少需要有区数据
                guard let di = self.district, let code = di.code, let name = ci.name, !code.isEmpty, !name.isEmpty else {
                    self.showCityList()
                    complete()
                    return
                }
                
                // 获取区列表数据~!@
                self.getDistrictList(self.city!, resultBlock: { (list) in
                    guard list.count > 0 else {
                        // 无区列表数据
                        self.showCityList()
                        complete()
                        return
                    }
                    
                    // 四级地址新增“暂不选择”时修改相关逻辑
                    // 至少需要有镇数据
//                    guard let to = self.town, let code = to.code, let name = ci.name, !code.isEmpty, !name.isEmpty else {
//                        self.showDistrictList()
//                        complete()
//                        return
//                    }
                    
                    // 获取镇列表数据~!@
                    self.getTownList(self.district!, resultBlock: { (list) in
                        guard list.count > 0 else {
                            // 无镇列表数据
                            self.showDistrictList()
                            complete()
                            return
                        }
                        
                        self.showTownList()
                        complete()
                    }) // town
                }) // district
            }) // city
        } // province
    }
}


//MARK: - AutoSelect...<自动勾选之前已经选中的>
extension FKYDeliveryAddressPickerView {
    // 勾选省
    fileprivate func checkProvinceLogic() {
        guard let pro = province, provinceArray.count > 0 else {
            return
        }
        
        // 匹配的省索引
        var indexSelect = 0
        // 是否匹配
        var findFlag = false
        // 遍历查询
        for index in 0..<provinceArray.count {
            let item = provinceArray[index]
            if item.code == pro.code, item.name == pro.name {
                indexSelect = index
                findFlag = true
                break
            }
        }
        // 勾选项置顶
        provinceTableView.scrollToItem(at: IndexPath.init(row: indexSelect, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
        // 若匹配，则需要显示省名称
        if findFlag {
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            layerDecorateWillMoveTo = .provice
            layerDecorate.position = CGPoint(x: provinceBtn.center.x, y: 1)
            
            provinceBtn.setTitle(province?.name, for: .normal)
            var width = provinceBtn.singleLineLenght()
            if width > SCREEN_WIDTH / 4 {
                width = SCREEN_WIDTH / 4
            }
            provinceBtn.snp.updateConstraints({ (make) in
                make.width.equalTo(width + WH(16))
            })
            provinceBtn.needsUpdateConstraints()
            self.contentView.layoutIfNeeded()
        }
    }
    
    // 勾选市
    fileprivate func checkCityLogic() {
        guard let ci = city, cityArray.count > 0 else {
            return
        }
        
        // 匹配的市索引
        var indexSelect = 0
        // 是否匹配
        var findFlag = false
        // 遍历查询
        for index in 0..<cityArray.count {
            let item = cityArray[index]
            if item.code == ci.code, item.name == ci.name {
                indexSelect = index
                findFlag = true
                break
            }
        }
        // 勾选项置顶
        cityTableView.scrollToItem(at: IndexPath.init(row: indexSelect, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
        // 若匹配，则需要显示市名称
        if findFlag {
            mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: true)
            layerDecorateWillMoveTo = .city
            layerDecorate.position = CGPoint(x: cityBtn.center.x, y: 1)
            
            cityBtn.setTitle(city?.name, for: .normal)
            var width = cityBtn.singleLineLenght()
            if width > SCREEN_WIDTH / 4 {
                width = SCREEN_WIDTH / 4
            }
            cityBtn.snp.updateConstraints({ (make) in
                make.width.equalTo(width + WH(16))
            })
            cityBtn.needsUpdateConstraints()
            self.contentView.layoutIfNeeded()
        }
    }
    
    // 勾选区
    fileprivate func checkDistrictLogic() {
        guard let di = district, districtArray.count > 0 else {
            return
        }
        
        // 匹配的区索引
        var indexSelect = 0
        // 是否匹配
        var findFlag = false
        // 遍历查询
        for index in 0..<districtArray.count {
            let item = districtArray[index]
            if item.code == di.code, item.name == di.name {
                indexSelect = index
                findFlag = true
                break
            }
        }
        // 勾选项置顶
        districtTableView.scrollToItem(at: IndexPath.init(row: indexSelect, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
        // 若匹配，则需要显示区名称
        if findFlag {
            mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * 2, y: 0), animated: true)
            layerDecorateWillMoveTo = .district
            layerDecorate.position = CGPoint(x: districtBtn.center.x, y: 1)
            
            districtBtn.setTitle(district?.name, for: .normal)
            var width = districtBtn.singleLineLenght()
            if width > SCREEN_WIDTH / 4 {
                width = SCREEN_WIDTH / 4
            }
            districtBtn.snp.updateConstraints({ (make) in
                make.width.equalTo(width + WH(16))
            })
            districtBtn.needsUpdateConstraints()
            self.contentView.layoutIfNeeded()
        }
    }
    
    // 勾选镇
    fileprivate func checkTownLogic() {
        guard let to = town, townArray.count > 0 else {
            return
        }
        
        // 匹配的镇索引
        var indexSelect = 0
        // 是否匹配
        var findFlag = false
        // 遍历查询
        for index in 0..<townArray.count {
            let item = townArray[index]
            if item.code == to.code, item.name == to.name {
                indexSelect = index
                findFlag = true
                break
            }
        }
        // 勾选项置顶
        townTableView.scrollToItem(at: IndexPath.init(row: indexSelect, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
        // 若匹配，则需要显示镇名称
        if findFlag {
            mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * 3, y: 0), animated: true)
            layerDecorateWillMoveTo = .town
            layerDecorate.position = CGPoint(x: townBtn.center.x, y: 1)
            
            townBtn.setTitle(town?.name, for: .normal)
            var width = townBtn.singleLineLenght()
            if width > SCREEN_WIDTH / 4 {
                width = SCREEN_WIDTH / 4
            }
            townBtn.snp.updateConstraints({ (make) in
                make.width.equalTo(width + WH(16))
            })
            townBtn.needsUpdateConstraints()
            self.contentView.layoutIfNeeded()
        }
    }
    
    // 显示省列表 & 勾选
    fileprivate func showProvinceList() {
        // 数据源清理
        cityArray.removeAll()
        districtArray.removeAll()
        townArray.removeAll()
        
        // 先重置到初始的显示状态
        resetShowStatus()
        
        // 勾选省的相关逻辑处理
        checkProvinceLogic()
    }
    
    // 显示省列表+市列表 & 勾选
    fileprivate func showCityList() {
        // 数据源清理
        districtArray.removeAll()
        townArray.removeAll()
        
        // 先重置到初始的显示状态
        resetShowStatus()
        
        // 勾选省的相关逻辑处理
        checkProvinceLogic()
        // 勾选市的相关逻辑处理
        checkCityLogic()
    }
    
    // 显示省列表+市列表+区列表 & 勾选
    fileprivate func showDistrictList() {
        // 数据源清理
        townArray.removeAll()
        
        // 先重置到初始的显示状态
        resetShowStatus()
        
        // 勾选省的相关逻辑处理
        checkProvinceLogic()
        // 勾选市的相关逻辑处理
        checkCityLogic()
        // 勾选区的相关逻辑处理
        checkDistrictLogic()
    }
    
    // 显示省列表+市列表+区列表+镇列表 & 勾选
    fileprivate func showTownList() {
        // 先重置到初始的显示状态
        resetShowStatus()
        
        // 勾选省的相关逻辑处理
        checkProvinceLogic()
        // 勾选市的相关逻辑处理
        checkCityLogic()
        // 勾选区的相关逻辑处理
        checkDistrictLogic()
        // 勾选镇的相关逻辑处理
        checkTownLogic()
    }
}


//MARK: - UserSelect...<用户手动选择>
extension FKYDeliveryAddressPickerView {
    // 选择省
    fileprivate func selectProvince(_ model: FKYAddressItemModel) {
        //province = model // 保存省model
        provinceTemp = model // 保存省model
        provinceTableView.reloadData()

        // 设置省份名称
        provinceBtn.setTitle(model.name ?? "", for: UIControl.State())
        // 更新约束
        var width: CGFloat = provinceBtn.singleLineLenght()
        if width > SCREEN_WIDTH / 4 {
            width = SCREEN_WIDTH / 4
        }
        provinceBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        provinceBtn.needsUpdateConstraints()
        
        // 更新市、区、镇名称（标题）
        cityBtn.setTitle("请选择", for: UIControl.State())
        districtBtn.setTitle("请选择", for: UIControl.State())
        townBtn.setTitle("请选择", for: UIControl.State())
        // 更新约束
        width = cityBtn.singleLineLenght()
        cityBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        cityBtn.needsUpdateConstraints()
        districtBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        districtBtn.needsUpdateConstraints()
        townBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        townBtn.needsUpdateConstraints()
        contentView.layoutIfNeeded()
        
        // 更新数据源
        cityTemp = nil
        districtTemp = nil
        townTemp = nil
        cityArray.removeAll()
        districtArray.removeAll()
        townArray.removeAll()
        cityTableView.reloadData()
        districtTableView.reloadData()
        townTableView.reloadData()
        
        // 重置collectionview内容缩进
        cityTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        districtTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        townTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        
        // 开始查询市数组
        // loading
        if addressProvider is FKYAddressRemoteProvider {
            if let closure = showLoadingClosure {
                closure(true)
            }
        }
        getCityList(model) { (list) in
            // dismiss
            if let closure = self.showLoadingClosure {
                closure(false)
            }
            if list.count > 0 {
                // 刷新
                self.cityTableView.reloadData()
                self.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: true)
                // 底部指示器移到市标题下方
                self.layerDecorateWillMoveTo = .city
                self.layerDecorate.position = CGPoint(x: self.cityBtn.center.x, y: 1)
            }
            else {
                // 无数据
                if let closure = self.showToastClosure {
                    closure("获取数据失败")
                }
                // 完成地址选择，返回并传值
                self.perform(#selector(self.selectAddressOver), with: nil, afterDelay: 0.35)
            }
        }
    }
    
    // 选择市
    fileprivate func selectCity(_ model: FKYAddressItemModel) {
        //city = model // 保存市model
        cityTemp = model // 保存市model
        cityTableView.reloadData()
        
        // 设置市名称
        cityBtn.setTitle(model.name ?? "", for: UIControl.State())
        // 更新约束
        var width = cityBtn.singleLineLenght()
        if width > SCREEN_WIDTH / 4 {
            width = SCREEN_WIDTH / 4
        }
        cityBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        cityBtn.needsUpdateConstraints()
        
        // 更新区、镇名称（标题）
        districtBtn.setTitle("请选择", for: UIControl.State())
        townBtn.setTitle("请选择", for: UIControl.State())
        // 更新约束
        width = districtBtn.singleLineLenght()
        districtBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        districtBtn.needsUpdateConstraints()
        townBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        townBtn.needsUpdateConstraints()
        contentView.layoutIfNeeded()
        
        // 更新数据源
        districtTemp = nil
        townTemp = nil
        districtArray.removeAll()
        townArray.removeAll()
        districtTableView.reloadData()
        townTableView.reloadData()
        
        // 重置collectionview内容缩进
        districtTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        townTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        
        // 开始查询区数组
        // loading
        if addressProvider is FKYAddressRemoteProvider {
            if let closure = showLoadingClosure {
                closure(true)
            }
        }
        getDistrictList(model) { (list) in
            // dismiss
            if let closure = self.showLoadingClosure {
                closure(false)
            }
            if list.count > 0 {
                // 刷新
                self.districtTableView.reloadData()
                self.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * 2, y: 0), animated: true)
                // 底部指示器移到区标题下方
                self.layerDecorateWillMoveTo = .district
                self.layerDecorate.position = CGPoint(x: self.districtBtn.center.x, y: 1)
            }
            else {
                // 无数据
                if let closure = self.showToastClosure {
                    closure("获取数据失败")
                }
                // 完成地址选择，返回并传值
                self.perform(#selector(self.selectAddressOver), with: nil, afterDelay: 0.35)
            }
        }
    }
    
    // 选择区
    fileprivate func selectDistrict(_ model: FKYAddressItemModel) {
        //district = model // 保存区model
        districtTemp = model // 保存区model
        districtTableView.reloadData()
        
        // 设置区名称
        districtBtn.setTitle(model.name!, for: UIControl.State())
        // 更新约束
        var width = districtBtn.singleLineLenght()
        if width > SCREEN_WIDTH / 4 {
            width = SCREEN_WIDTH / 4
        }
        districtBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        districtBtn.needsUpdateConstraints()
        
        // 更新镇名称（标题）
        townBtn.setTitle("请选择", for: UIControl.State())
        // 更新约束
        width = townBtn.singleLineLenght()
        townBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        townBtn.needsUpdateConstraints()
        contentView.layoutIfNeeded()
        
        // 更新数据源
        townTemp = nil
        townArray.removeAll()
        townTableView.reloadData()
        
        // 重置collectionview内容缩进
        townTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        
        // 开始查询镇数组
        // loading
        if addressProvider is FKYAddressRemoteProvider {
            if let closure = showLoadingClosure {
                closure(true)
            }
        }
        getTownList(model) { (list) in
            // dismiss
            if let closure = self.showLoadingClosure {
                closure(false)
            }
            if list.count > 0 {
                // 刷新
                self.townTableView.reloadData()
                self.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * 3, y: 0), animated: true)
                // 底部指示器移到区标题下方
                self.layerDecorateWillMoveTo = .town
                self.layerDecorate.position = CGPoint(x: self.townBtn.center.x, y: 1)
            }
            else {
                // 无数据
                // 需判断当前区下面本来就没有镇数据，还是查询失败???
                // 若是读取本地adress.db文件的方式，则返回空数据，一定是当前区下无镇数据~!@
                // 完成地址选择，返回并传值
                self.perform(#selector(self.selectAddressOver), with: nil, afterDelay: 0.35)
            }
        }
    }
    
    // 选择镇
    fileprivate func selectTown(_ model: FKYAddressItemModel) {
        // 对四级地址中最后面的“暂不选择”进行单独处理
        if let name = model.name, name == "暂不选择", let code = model.code, code == "-1" {
            // 更新
            townTemp = nil
            // 完成地址选择，返回并传值
            perform(#selector(selectAddressOver), with: nil, afterDelay: 0.35)
            return
        }
        
        //town = model // 保存镇model
        townTemp = model // 保存镇model
        townTableView.reloadData()
        
        // 设置镇名称
        townBtn.setTitle(model.name!, for: UIControl.State())
        // 更新约束
        var width = townBtn.singleLineLenght()
        if width > SCREEN_WIDTH / 4 {
            width = SCREEN_WIDTH / 4
        }
        townBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        townBtn.needsUpdateConstraints()
        contentView.layoutIfNeeded()
        
        // 完成地址选择，返回并传值
        perform(#selector(selectAddressOver), with: nil, afterDelay: 0.35)
    }
}


//MARK: - DataSource
extension FKYDeliveryAddressPickerView {
    // 获取所有省
    fileprivate func getProvinceList(resultBlock: @escaping ([Any]) -> ()) {
        // 省内容不会改变，故不需要重复查询
        if provinceArray.count > 0 {
            resultBlock(provinceArray)
            return
        }
        addressProvider.getProvinceList { (list) in
            self.provinceArray = list as! [FKYAddressItemModel]
            resultBlock(list)
        }
    }
    
    // 获取所有市
    fileprivate func getCityList(_ provinceModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        addressProvider.getCityList(provinceModel) { (list) in
            self.cityArray = list as! [FKYAddressItemModel]
            resultBlock(list)
        }
    }
    
    // 获取所有区
    fileprivate func getDistrictList(_ cityModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        addressProvider.getDistrictList(cityModel) { (list) in
            self.districtArray = list as! [FKYAddressItemModel]
            resultBlock(list)
        }
    }
    
    // 获取所有镇
    fileprivate func getTownList(_ districtModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        addressProvider.getTownList(districtModel) { (list) in
            self.townArray = list as! [FKYAddressItemModel]
            resultBlock(list)
        }
    }
}


//MARK: - CollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension FKYDeliveryAddressPickerView {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == provinceTableView {
            // 省
            return provinceArray.count
        }
        else if collectionView == cityTableView {
            // 市
            return cityArray.count
        }
        else if collectionView == districtTableView {
            // 区
            return districtArray.count
        }
        else if collectionView == townTableView {
            // 镇
            return townArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: WH(45))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnterpriseTypeCell", for: indexPath) as! EnterpriseTypeCell
        if collectionView == provinceTableView {
            // 省
            let model = provinceArray[indexPath.row]
            var selected = false
            if let temp = provinceTemp {
                selected = (model.code == temp.code)
            }
            cell.configCell(model.name ?? "", selected: selected)
        }
        else if collectionView == cityTableView {
            // 市
            let model = cityArray[indexPath.row]
            var selected = false
            if let temp = cityTemp {
                selected = (model.code == temp.code)
            }
            cell.configCell(model.name ?? "", selected: selected)
        }
        else if collectionView == districtTableView {
            // 区
            let model = districtArray[indexPath.row]
            var selected = false
            if let temp = districtTemp {
                selected = (model.code == temp.code)
            }
            cell.configCell(model.name ?? "", selected: selected)
        }
        else if collectionView == townTableView {
            // 镇
            let model = townArray[indexPath.row]
            var selected = false
            if let temp = townTemp {
                selected = (model.code == temp.code)
            }
            cell.configCell(model.name ?? "", selected: selected)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == provinceTableView {
            // 当前省份model
            selectProvince(provinceArray[indexPath.row])
        }
        else if collectionView == cityTableView {
            // 市
            selectCity(cityArray[indexPath.row])
        }
        else if collectionView == districtTableView {
            // 区
            selectDistrict(districtArray[indexPath.row])
        }
        else if collectionView == townTableView {
            // 镇
            selectTown(townArray[indexPath.row])
        }
    }
}

