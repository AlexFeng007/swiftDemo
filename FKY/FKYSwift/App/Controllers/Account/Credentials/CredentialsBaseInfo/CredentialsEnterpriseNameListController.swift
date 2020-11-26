//
//  CredentialsEnterpriseNameListController.swift
//  FKY
//
//  Created by airWen on 2017/5/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  (填写基本信息之)企业名称(搜索联想)列表界面
//  不再使用~!@

import UIKit
import MapKit

class CredentialsEnterpriseNameListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: - Property
    
    fileprivate var navBar: UIView?
    
    /*
     * in 3.5.1用百度地图替换"enterpriseInfo/findEnterpriseList"接口查询，in FKYSearchEnterpriseProvider class
     */
//    private var server: FKYSearchEnterpriseProvider = FKYSearchEnterpriseProvider()
    fileprivate let largetEnterpriseNamelenght = 33
    fileprivate var lastSearchKeyWord: String?
    fileprivate var searchEnterpriseArray: [FKYEnterpriseModel] = []
    fileprivate var selectedEnterpriseModel: FKYEnterpriseModel?
    fileprivate var contriatsTipsHeight: NSLayoutConstraint?
    
    fileprivate lazy var viewTips: FKYTipsUIView = {
        let view: FKYTipsUIView = FKYTipsUIView(frame: CGRect.zero)
        view.setTipsContent("特别提醒：企业名称请一定要和营业执照上的名称一致，如果不一致，供应商会拒绝为您发货！", numberOfLines: 2)
        return view
    }()
    
    fileprivate lazy var edtxtEnterpriseName: UITextField = {
        let edtxt: UITextField = UITextField()
        edtxt.backgroundColor = bg1
        edtxt.placeholder = self.type == .EnterpriseName ? "请输入企业名称" : "请输入零售企业名称"
        edtxt.borderStyle = .none
        edtxt.delegate = self
        edtxt.font = UIFont.systemFont(ofSize: WH(16))
        edtxt.returnKeyType = .search
        edtxt.textColor = RGBColor(0x9A9A9A)
        edtxt.clearButtonMode = .whileEditing
        edtxt.textAlignment = .left
        edtxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        edtxt.addDoneOnKeyboard(withTarget: self, action: #selector(ontextFieldDone(_:)))
        return edtxt
    }()
    
    fileprivate lazy var imageBgView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        return imageView
    }()
    
    fileprivate lazy var tableSearchTabel: UITableView = {
        let table: UITableView = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.white
        table.separatorStyle = .none
        table.isHidden = true
        table.register(FKYEnterpriseNameCell.self, forCellReuseIdentifier: "FKYEnterpriseNameCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return table
    }()
    
    fileprivate lazy var searchService: FKYMapSearchService = {
        let searchService: FKYMapSearchService = FKYMapSearchService()
        return searchService
    }()
    
    fileprivate lazy var controlMask: UIControl = {
        let control: UIControl = UIControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = bg1
        return control
    }()
    
    var enterEnterpriseInTextField: ((_ enterpriseName: String?)->())?
    var popOutCallBack: (()->())?
    var selectEnterpriseInCell: ((_ enterpriseModel: FKYEnterpriseModel?)->())?
    var screenShot: UIImage?
    var enterEnterpriseName: String?
    var isScan:Bool?
    var type: ZZBaseInfoSectionType?
    
    //MARK: - Private
    
    fileprivate func search(_ string: String) {
        if string == lastSearchKeyWord {
            return
        }
        self.tableSearchTabel.reloadData()
        lastSearchKeyWord = string
        // 开始搜索
        searchService.searchLocationInfo(string)
    }
    
    fileprivate func popForSureSelected(_ enterpriseName: String?) {
        if let string: String = enterpriseName {
            let strLenght = string.count
            if 0 < strLenght {
                if  strLenght <= largetEnterpriseNamelenght  {
                    if let callBackAction = self.enterEnterpriseInTextField {
                        callBackAction(string)
                    }
                }else {
                    toast("公司名称不能超过33字")
                }
            }else {
                toast("公司名称不能为空")
            }
        }else {
            toast("公司名称不能为空")
        }
        FKYNavigator.shared().popWithoutAnimation()
    }
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGBColor(0xF8F8F8)
        
        self.searchService.callBackDelegate = self
        
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        
        self.fky_setupLeftImage("icon_back_new_red_normal") {[weak self] in
            if let strongSelf = self, let popOutCallBack = strongSelf.popOutCallBack {
                popOutCallBack()
            }
            FKYNavigator.shared().pop()
        }
        self.fky_setupTitleLabel("填写基本信息")
        self.navBar?.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        
        self.view.addSubview(viewTips)
        viewTips.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.leading.trailing.equalTo(self.view)
        }
        
        self.view.addSubview(imageBgView)
        imageBgView.snp.makeConstraints { (make) in
            make.top.equalTo(viewTips.snp.bottom)
            make.leading.trailing.equalTo(self.view)
        }
        imageBgView.image = self.screenShot
        
        let viewTopToolBarBg: UIView = UIView()
        viewTopToolBarBg.backgroundColor = bg1
        self.view.addSubview(viewTopToolBarBg)
        viewTopToolBarBg.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.top.equalTo(viewTips.snp.bottom).offset(-1)
            make.height.equalTo(WH(56))
        })
        
        let starLabel = UILabel()
        starLabel.textColor = RGBColor(0xFF394E)
        starLabel.font = UIFont.systemFont(ofSize: WH(15))
        starLabel.textAlignment = .center
        starLabel.text = "*"
        starLabel.adjustsFontSizeToFitWidth = true
        starLabel.minimumScaleFactor = 0.8
        viewTopToolBarBg.addSubview(starLabel)
        starLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(viewTopToolBarBg).offset(WH(15))
            make.centerY.equalTo(viewTopToolBarBg)
            make.width.equalTo(WH(8))
        })
        
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.text = "企业名称"
        viewTopToolBarBg.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.left.equalTo(starLabel.snp.right)
            make.centerY.equalTo(viewTopToolBarBg)
        })
        
        edtxtEnterpriseName.text = self.enterEnterpriseName
        viewTopToolBarBg.addSubview(edtxtEnterpriseName)
        edtxtEnterpriseName.snp.makeConstraints({ (make) in
            make.trailing.equalTo(viewTopToolBarBg.snp.trailing).offset(-8)
            make.centerY.equalTo(viewTopToolBarBg)
            make.leading.equalTo((23+label.intrinsicContentSize.width+j1))
        })
        edtxtEnterpriseName.becomeFirstResponder()
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xEEEEEE)
        viewTopToolBarBg.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.trailing.equalTo(viewTopToolBarBg.snp.trailing)
            make.bottom.equalTo(viewTopToolBarBg.snp.bottom).offset(-0.5)
            make.height.equalTo(0.5)
            make.leading.equalTo(viewTopToolBarBg.snp.leading).offset(16)
        })
        
        controlMask.addTarget(self, action: #selector(onControlMask(_:)), for: .touchUpInside);
        self.view.addSubview(controlMask)
        self.view.bringSubviewToFront(controlMask)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[controlMask]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["controlMask":controlMask]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewTopToolBarBg][controlMask]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["controlMask":controlMask,"viewTopToolBarBg":viewTopToolBarBg]))
        
        tableSearchTabel.delegate = self
        tableSearchTabel.dataSource = self
        self.view.addSubview(tableSearchTabel)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableSearchTabel]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["tableSearchTabel":tableSearchTabel]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewTopToolBarBg][tableSearchTabel]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["tableSearchTabel":tableSearchTabel,"viewTopToolBarBg":viewTopToolBarBg]))
        
        if let keyword = edtxtEnterpriseName.text, keyword != "" {
            search(keyword)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIView.animate(withDuration: 0.35, animations: {
            self.viewTips.setTipsContent("", numberOfLines: 0)
        }, completion: { (finish) in
            //
        }) 
    }
    
    
    //MARK: - User Action
    
    @objc func onControlMask(_ sender: UIColor) {
        self.edtxtEnterpriseName.resignFirstResponder()
        self.popForSureSelected(edtxtEnterpriseName.text)
    }
    
    
    //MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchEnterpriseArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(58)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let enterpriseModel = self.searchEnterpriseArray[indexPath.row]
        let enterprisName: String? = enterpriseModel.enterpriseName
        var district = ""
        if let districtName = enterpriseModel.districtName {
            district = districtName
        }
        var city = ""
        if let cityName = enterpriseModel.cityName {
            city = cityName
        }
        
        if let enterprisNameString = enterprisName {
            let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: enterprisNameString)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0x151515), range: NSMakeRange(0, enterprisNameString.count))
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: WH(16)), range: NSMakeRange(0, enterprisNameString.count))
            if let string = self.edtxtEnterpriseName.text {
                for characters in string {
                    let subRange: NSRange = (enterprisNameString as NSString).range(of: String(characters), options: .caseInsensitive)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xFE403B), range: subRange)
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYEnterpriseNameCell", for: indexPath) as! FKYEnterpriseNameCell
            cell.setCellCotent(NSAttributedString(attributedString: attributedString), address: "\(city)\(district)")
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let enterprisObj: FKYEnterpriseModel? = self.searchEnterpriseArray[indexPath.row]
        if let enterprisModel = enterprisObj {
            if let coordinateLocation = enterprisModel.coordinateLocation, let _ = self.selectEnterpriseInCell {
                self.showLoading()
                self.selectedEnterpriseModel = enterprisModel;
                // 获取地址详情信息
                self.searchService.toGetAdressDetail(fromLocation: coordinateLocation)
            }
            else {
                if let selectAction = self.selectEnterpriseInCell {
                    selectAction(enterprisModel)
                }
                FKYNavigator.shared().popWithoutAnimation()
            }
        }
        else {
            FKYNavigator.shared().popWithoutAnimation()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    //MARK: - UITextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    
    @objc func ontextFieldDone(_ sender: AnyObject) {
        self.edtxtEnterpriseName.resignFirstResponder()
        self.popForSureSelected(edtxtEnterpriseName.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.edtxtEnterpriseName.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        // 过滤表情符
        if NSString.stringContainsEmoji(sender.text) || NSString.hasEmoji(sender.text) {
            sender.text = NSString.disableEmoji(sender.text)
        }
        
        var strSearchWord = sender.text
        if let words = sender.text?.components(separatedBy: CharacterSet.whitespacesAndNewlines) {
            strSearchWord = words.joined(separator: "")
        }
        if let string: String = strSearchWord {
            if 0 < string.count {
                self.search(string)
            }else {
                lastSearchKeyWord = nil
                searchEnterpriseArray = []
                tableSearchTabel.reloadData()
                tableSearchTabel.isHidden = true
                self.view.sendSubviewToBack(tableSearchTabel)
                controlMask.isHidden = false
                self.view.bringSubviewToFront(controlMask)
            }
        }else {
            lastSearchKeyWord = nil
            searchEnterpriseArray = []
            self.tableSearchTabel.reloadData()
            self.tableSearchTabel.isHidden = true
            self.view.sendSubviewToBack(tableSearchTabel)
            controlMask.isHidden = false
            self.view.bringSubviewToFront(controlMask)
        }
    }
}


extension CredentialsEnterpriseNameListController: FKYMapSearchServiceDelegate {
    // 搜索失败
    func searchFailed(_ reason: String!) {
        self.dismissLoading()
        
        searchEnterpriseArray = []
        
        tableSearchTabel.reloadData()
        tableSearchTabel.isHidden = true
        self.view.sendSubviewToBack(tableSearchTabel)
        
        controlMask.isHidden = false
        self.view.bringSubviewToFront(controlMask)
        
        if (self.isScan)! {
            // 若有地区编码未匹配全，则清空地区信息
            self.clearAddressInfo(nil)
        }
    }
    
    // 搜索成功
    func searchResult(_ keyList: [String]!, cityList: [String]!, districtList: [String]!, poiIdList: [String]!, ptList: [NSValue]!) {
        self.dismissLoading()
        var index: NSInteger = 0
        self.searchEnterpriseArray = []
        self.tableSearchTabel.reloadData()
        
        if cityList.count > 0 {
            for cityName in cityList {
                // 初始化企业model: 包括企业名称、城市名称、区名称、企业类型...<无地区id>
                let enterpriseModel: FKYEnterpriseModel = FKYEnterpriseModel(enterpriseName: keyList[index], cityName: cityName, provinceName: "", districtName: districtList[index], province: "", enterpriseId: "", district: "", city: "", enterpriseType: 0)
                enterpriseModel.coordinateLocation = ptList[index].mkCoordinateValue
                self.searchEnterpriseArray.append(enterpriseModel)
                index += 1
            }
            
            controlMask.isHidden = true
            self.view.sendSubviewToBack(controlMask)
            
            self.tableSearchTabel.reloadData()
            self.tableSearchTabel.isHidden = false
            self.view.bringSubviewToFront(tableSearchTabel)
        }
        else {
            self.tableSearchTabel.reloadData()
            self.tableSearchTabel.isHidden = true
            self.view.sendSubviewToBack(tableSearchTabel)
            
            controlMask.isHidden = false
            self.view.bringSubviewToFront(controlMask)
        }
    }
    
    // 地址反编码失败
    func getDetailAddressFailed(_ reason: String!) {
        print("<Fail>...getDetailAdressFailed: " + reason)
        self.dismissLoading()
        self.clearAddressInfo(nil)
    }
    
    // 地址反编码成功
    func getDetailAddress(_ address: String?, provinceName: String?, cityName: String?, districtName: String?) {
        self.dismissLoading()
        
        // 省名称为空
        guard let nameP = provinceName, nameP.isEmpty == false else {
            self.clearAddressInfo(address)
            return
        }
        // 市名称为空
        guard let nameC = cityName, nameC.isEmpty == false else {
            self.clearAddressInfo(address)
            return
        }
        // 省名称为空
        guard let nameD = districtName, nameD.isEmpty == false else {
            self.clearAddressInfo(address)
            return
        }
        
        // loading
        self.showLoading()
        
        // 开始通过name查code
        RegisterAddressProvider.queryAreaNameOrCode(nameP, nameC, nameD) { [weak self] (model, msg) in
            guard let strongSelf = self else {
                return
            }
            
            // 隐藏loading
            strongSelf.dismissLoading()
            
            // 省市区三级code均不为空时，才可以使用~!@
            // "自动匹配地址失效，请手动选择地址"
            guard let obj: RegisterAddressQueryItemModel = model else {
                // 失败
                strongSelf.clearAddressInfo(address)
                return
            }
            guard let province = obj.tAddressProvince, let codeP = province.code, codeP.isEmpty == false else {
                // 失败
                strongSelf.clearAddressInfo(address)
                return
            }
            guard let city = obj.tAddressCity, let codeC = city.code, codeC.isEmpty == false else {
                // 失败
                strongSelf.clearAddressInfo(address)
                return
            }
            guard let district = obj.tAddressCountry, let codeD = district.code, codeD.isEmpty == false else {
                // 失败
                strongSelf.clearAddressInfo(address)
                return
            }
            
            // 保存
            if let block = strongSelf.selectEnterpriseInCell {
                strongSelf.dismissLoading()
                strongSelf.selectedEnterpriseModel?.provinceName = nameP
                strongSelf.selectedEnterpriseModel?.province = codeP
                strongSelf.selectedEnterpriseModel?.cityName = nameC
                strongSelf.selectedEnterpriseModel?.city = codeC
                strongSelf.selectedEnterpriseModel?.districtName = nameD
                strongSelf.selectedEnterpriseModel?.district = codeD
                strongSelf.selectedEnterpriseModel?.detailAddress = address
                block(strongSelf.selectedEnterpriseModel)
                
                FKYNavigator.shared().popWithoutAnimation()
            }
        }
    }
    
    // 清除地址信息...<非delegate方法>
    fileprivate func clearAddressInfo(_ address: String?) {
        if let block = self.selectEnterpriseInCell {
            self.dismissLoading()
            self.selectedEnterpriseModel?.provinceName = nil
            self.selectedEnterpriseModel?.province = nil
            self.selectedEnterpriseModel?.cityName = nil
            self.selectedEnterpriseModel?.city = nil
            self.selectedEnterpriseModel?.districtName = nil
            self.selectedEnterpriseModel?.district = nil
            self.selectedEnterpriseModel?.detailAddress = address
            block(self.selectedEnterpriseModel)
            
            FKYNavigator.shared().popWithoutAnimation()
        }
    }
}
