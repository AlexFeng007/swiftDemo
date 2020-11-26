//
//  FKYAddressDBManager.swift
//  FKY
//
//  Created by 夏志勇 on 2018/8/18.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  地址数据库管理类...<单例>

import UIKit

//MARK: - Basic
class FKYAddressDBManager: NSObject {
    // db操作队列
    fileprivate lazy var dbQueue: FMDatabaseQueue = {
        print(">>>...dbQueue init")
        let path = self.getAddressDatabaseDocPath()
        return FMDatabaseQueue.init(path: path)
    }()
    // lock锁
    fileprivate lazy var queueLock: NSRecursiveLock = {
        print(">>>..queueLock init")
        return NSRecursiveLock()
    }()
    // 操作队列
    fileprivate lazy var writeQueue: OperationQueue = {
        print(">>>..writeQueue init")
        var queue = OperationQueue()
        // 最大并发操作数...<设为1时为串行>
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    /*
     * 说明：单独使用FMDatabaseQueue时，仍然有可能出现database is locked情况;
     * 故新增OperationQueue + NSRecursiveLock，来防止database is locked情况;
     */
    
    // 省份数组...<只需查一次并保存，不用每次都重复查询>
    var provinceList: [FKYAddressItemModel] = [FKYAddressItemModel]()
    
    // 接口请求相关
    var requestService = FKYAddressRequestService()
    // 当前(起始)页码...<每次请求成功后均+1>
    fileprivate var pageNumber = 1
    // 每页条数...<不支持修改>
    fileprivate let pageSize = 100
    // 当前db版本号...<时间戳>
    fileprivate var versionDb: Int64?
    // 更新item数组
    fileprivate var updateItemList = [FKYAddressUpdateModel]()
    // 最终用于更新db的item数组
    fileprivate var dbItemList = [FKYAddressUpdateItemModel]()

    // 单例写法1
    @objc static let instance = FKYAddressDBManager()
    // 单例写法2
//    static let instance: FKYAddressDBManager = {
//        return FKYAddressDBManager()
//    }()
    
    // 阻止其他对象使用这个类的默认'()'初始化方法
    private override init() {
        print(">>>..FKYAddressDBManager init")
    }
    
    // APP启动时配置地址数据库状态
    @objc func configAddressDatabase() {
        // 保存在DOC中的数据库文件路径
        let dbDir = getAddressDatabaseDocPath()
        guard let dir = dbDir, dir.isEmpty == false else {
            // db路径为空
            return
        }
        
        var isDir:ObjCBool = ObjCBool(false)
        if FileManager.default.fileExists(atPath: dir, isDirectory: &isDir), isDir.boolValue == false {
            // 路径存在，且不为目录
            print("DOC中的数据库文件已存在")
            updateDBInDocByReplace()
        }
        else {
            // 路径不存在 or 为目录
            copyAddressDatabaseToDoc()
        }
    }
    
    // APP启动时需调接口来判断当前版本的本地db是否需要更新
    @objc func checkAndUpdateAddressDatabase(_ callback: @escaping (Bool)->()) {
        // 获取db版本号....<上次修改时间戳>
        let dbVersion = getAddressDatabaseVersion()
        guard let version = dbVersion else {
            // 重新copy一次...<下次启动时再更新>
            copyAddressDatabaseToDoc()
            // 返回
            callback(false)
            return
        }
        
        // 保存当前db版本号
        versionDb = version
        // 先清空
        updateItemList.removeAll()
        // 请求db待更新数据 0 1535015735990 1535105755057 1535105755058 1535968990854
        requestUpdateDataForAddressDatabase(version) { (item, msg) in
            self.updateDataForAddressDatabase({ (success) in
                if success {
                    callback(true)
                }
                else {
                    callback(false)
                }
            })
        }
    }
}


//MARK: - Public
extension FKYAddressDBManager {
    // 获取所有省份
    func getProvinceList(resultBlock: @escaping ([Any]) -> ()) {
        let sqlProvince = "select * from address where level = 1"
        queryAddressDatabase(sql: sqlProvince, arguments: nil) { (list) in
            // 保存省份数组
            self.provinceList = list as! [FKYAddressItemModel]
            resultBlock(list)
        }
    }
}


//MARK: - Private
extension FKYAddressDBManager {
    // 获取本地地址数据库DB中的版本号...<版本号实际为最后一次修改时的时间戳:1594233598000>
    fileprivate func getAddressDatabaseVersion() -> Int64? {
        // 保存在DOC中的数据库文件路径
        let dbDoc = getAddressDatabaseDocPath()
        guard let doc = dbDoc, doc.isEmpty == false else {
            // db路径不存在
            return nil
        }
        
        let db = FMDatabase.init(path: doc)
        guard db.open() else {
            // db文件错误
            return nil
        }
        
        if let result = db.executeQuery("select * from version", withArgumentsIn: [Any]()) {
            while result.next() {
                let version: Int64 = result.longLongInt(forColumn: "version")
                return version
            }
            return nil
        }
        else {
            return nil
        }
    }
    
    // 获取Bundle地址数据库DB中的版本号...<只读>
    fileprivate func getAddressDatabaseVersionInBundle() -> Int64? {
        // 保存在Bundle中的数据库文件路径
        let dbDoc = getAddressDatabaseBundlePath()
        guard let doc = dbDoc, doc.isEmpty == false else {
            // db路径不存在
            return nil
        }
        
        let db = FMDatabase.init(path: doc)
        guard db.open() else {
            // db文件错误
            return nil
        }
        
        if let result = db.executeQuery("select * from version", withArgumentsIn: [Any]()) {
            while result.next() {
                let version: Int64 = result.longLongInt(forColumn: "version")
                return version
            }
            return nil
        }
        else {
            return nil
        }
    }
    
    // 实时请求完所有需要更新的数据后，封装成db可以执行的SQL数组，且开始更新db
    fileprivate func updateDataForAddressDatabase(_ callback: @escaping (Bool)->()) {
        guard updateItemList.count > 0 else {
            callback(true)
            return
        }
        
        dbItemList.removeAll()
        for item in updateItemList {
            guard let arr = item.list, arr.count > 0 else {
                continue
            }
            dbItemList.append(contentsOf: arr)
        }
        
        guard dbItemList.count > 0 else {
            print("无数据需要更新")
            callback(true)
            return
        }
        
        //
        DispatchQueue.global().async {
            print("updateDataForAddressDatabase begin...>>>")
            
//            var count = 0
//            for item in self.dbItemList {
//                self.executeUpdateForAddressDatabase(item) { (success) in
//                    print("executeUpdateForAddressDatabase over")
//                    if success {
//                        count = count + 1
//                        if count == self.dbItemList.count {
//                            callback(true)
//                            return
//                        }
//                    }
//                    else {
//                        //
//                        callback(false)
//                        return
//                    }
//                }
//            } // for
            
            // db
            let db = FMDatabase.init(path: self.getAddressDatabaseDocPath())
            guard db.open() else {
                callback(false)
                return
            }
            
            var count = 0
            for index in 0..<self.dbItemList.count {
               // print("executeUpdateForAddressDatabase begin...<\(index)>")
                let item = self.dbItemList[index]
                let success = self.startUpdateForAddressDatabase(item, db)
               // print("executeUpdateForAddressDatabase over...<\(index)>")
                if success {
                    count = count + 1
                }
                else {
                    break
                }
            } // for
            
            db.close()
            if count == self.dbItemList.count {
                callback(true)
            }
            else {
                callback(false)
            }
            
           // print("updateDataForAddressDatabase over...>>>")
        }
    }
    
    // 执行单个update操作<包括：delete、add、update>...<使用block，无法保证最终的update操作依次顺序执行>...<暂不使用>
    fileprivate func executeUpdateForAddressDatabase(_ item: FKYAddressUpdateItemModel, _ callback: @escaping (Bool)->()) {
        // sql
        let sql = "select * from address where id = ? and level = ? and code = ?"
        let args = [item.id ?? 0, item.level ?? 1, item.code ?? ""] as [Any]
        // 查询
        queryAddressDatabase(sql: sql, arguments: args) { (list) in
            if list.count > 0 {
                // 修改or删除...<有找到对应项>
                if let delete = item.isDelete, delete == 1 {
                    // 删除
                    let sql_delete = "delete from address where id = ?"
                    let values_delete = [item.id ?? ""] as [Any]
                    let sql_update = "update version set version = ?"
                    let values_update = [item.version ?? ""] as [Any]
                    self.updateAddressDatabaseForMulti([sql_delete, sql_update], arguments: [values_delete, values_update], { (success) in
                        if success {
                            //
                            print("...>>>...delete success~!@")
                            callback(true)
                        }
                        else {
                            //
                            print("...>>>...delete fail~!@")
                            callback(false)
                        }
                    })
                }
                else {
                    // 修改
                    let sql_insert = "update address set name = ?, code = ?, level = ?, parentCode = ? where id = ?"
                    let values_insert = [item.name ?? "", item.code ?? "", item.level ?? "", item.parentCode ?? "", item.id ?? ""] as [Any]
                    let sql_update = "update version set version = ?"
                    let values_update = [item.version ?? ""] as [Any]
                    self.updateAddressDatabaseForMulti([sql_insert, sql_update], arguments: [values_insert, values_update], { (success) in
                        if success {
                            //
                            print("...>>>...modify success~!@")
                            callback(true)
                        }
                        else {
                            //
                            print("...>>>...modify fail~!@")
                            callback(false)
                        }
                    })
                }
            }
            else {
                // 新增<未找到对应项>
                if let delete = item.isDelete, delete == 1 {
                    //
                    print("...>>>...db中未找到对应项，只能是新增，但操作指示为删除，故不作处理")
                    callback(true)
                    return
                }
                
                // 新增
                let sql_insert = "insert into address(id, code, name, level, parentCode) values(?, ?, ?, ?, ?)"
                let values_insert = [item.id ?? "", item.code ?? "", item.name ?? "", item.level ?? "", item.parentCode ?? ""] as [Any]
                let sql_update = "update version set version = ?"
                let values_update = [item.version ?? ""] as [Any]
                self.updateAddressDatabaseForMulti([sql_insert, sql_update], arguments: [values_insert as! Array<String>, values_update as! Array<String>], { (success) in
                    if success {
                        //
                        print("...>>>...Insert success~!@")
                        callback(true)
                    }
                    else {
                        //
                        print("...>>>...Insert fail~!@")
                        callback(false)
                    }
                }) // update
            } // insert
        } // query
    } // func
    
    // 执行单个update操作<包括：delete、add、update>...<不带block，保证最终的update操作依次顺序执行>
    fileprivate func startUpdateForAddressDatabase(_ item: FKYAddressUpdateItemModel, _ db: FMDatabase) -> Bool {
        do {
            // query
            let sql = "select * from address where id = ? and level = ? and code = ?"
            let args = [item.id ?? 0, item.level ?? 1, item.code ?? ""] as [Any]
            let res = try db.executeQuery(sql, values: args)
            var hasResult = false
            while res.next() {
                hasResult = true
                break
            }
            
            // update
            if hasResult {
                // 修改or删除...<有找到对应项>
                if let delete = item.isDelete, delete == 1 {
                    // 删除
                    let sql_delete = "delete from address where id = ?"
                    let values_delete = [item.id ?? ""] as [Any]
                    let sql_update = "update version set version = ?"
                    let values_update = [item.version ?? ""] as [Any]
                    let success = executeUpdateOnce(db, sql_delete, values_delete, sql_update, values_update)
                    return success
                }
                else {
                    // 修改
                    let sql_modify = "update address set name = ?, code = ?, level = ?, parentCode = ? where id = ?"
                    let values_modify = [item.name ?? "", item.code ?? "", item.level ?? "", item.parentCode ?? "", item.id ?? ""] as [Any]
                    let sql_update = "update version set version = ?"
                    let values_update = [item.version ?? ""] as [Any]
                    let success = executeUpdateOnce(db, sql_modify, values_modify, sql_update, values_update)
                    return success
                }
            }
            else {
                // 新增<未找到对应项>
                if let delete = item.isDelete, delete == 1 {
                    // db中未找到对应项，只能是新增，但操作指示为删除，故不作处理
                    print("...>>>...db中未找到对应项，只能是新增，但操作指示为删除，故不作处理")
                    return true
                }
                
                // 新增
                let sql_insert = "insert into address(id, code, name, level, parentCode) values(?, ?, ?, ?, ?)"
                let values_insert = [item.id ?? "", item.code ?? "", item.name ?? "", item.level ?? "", item.parentCode ?? ""] as [Any]
                let sql_update = "update version set version = ?"
                let values_update = [item.version ?? ""] as [Any]
                let success = executeUpdateOnce(db, sql_insert, values_insert, sql_update, values_update)
                return success
            }
        } catch {
           // print("failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // 执行一次更新操作...<若失败，则回滚>
    fileprivate func executeUpdateOnce(_ db: FMDatabase, _ sqlAddress: String, _ argsAddress: [Any], _ sqlVersion: String, _ argsVersion: [Any]) -> Bool {
        db.beginTransaction()
        var rollback = false
        if db.executeUpdate(sqlAddress, withArgumentsIn: argsAddress) {
            //print("...>>>...update success...[address]")
            if db.executeUpdate(sqlVersion, withArgumentsIn: argsVersion) {
               // print("...>>>...update success...[version]")
            }
            else {
              //  print("...>>>...update fail...[version]")
                rollback = true
            }
        }
        else {
           // print("...>>>...update fail...[address]")
            rollback = true
        }
        if rollback {
            db.rollback()
        }
        else {
            db.commit()
        }
        return rollback ? false : true
    }
}


//MARK: - 增、删、改、查 <使用Queue>
extension FKYAddressDBManager {
    // 查
    func queryAddressDatabase(sql: String?, arguments: [Any]?, resultBlock: @escaping ([Any]) -> ()) {
        // SQL
        guard let query = sql, query.isEmpty == false else {
            resultBlock([Any]())
            return
        }
        
        // FMDB支持多线程查询，故此处每次查询时均新建一个queue，以防止死锁
        let fmdbQueue = FMDatabaseQueue.init(path: getAddressDatabaseDocPath())
        fmdbQueue.inDatabase { (db) in
            var arrAddress = [FKYAddressItemModel]()
            do {
                let res = try db.executeQuery(query, values: arguments)
                while res.next() {
                    let code = res.string(forColumn: "code")
                    let name = res.string(forColumn: "name")
                    let level = res.string(forColumn: "level")
                    let parentCode = res.string(forColumn: "parentCode")
                    let item = FKYAddressItemModel.init(code: code, name: name, level: level, parentCode: parentCode)
                    arrAddress.append(item)
                }
                res.close()
            } catch {
                print("failed: \(error.localizedDescription)")
            }
            resultBlock(arrAddress)
        }
        
        /*
         Assertion failed: (currentSyncQueue != self && "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock"), function -[FMDatabaseQueue inDatabase:], file /Users/terryhsia/Desktop/iOS-FKY/fangkuaiyi_ios/Pods/FMDB/src/fmdb/FMDatabaseQueue.m, line 178.

        */
        // Lock + Queue
//        queueLock.lock()
//        dbQueue.inDatabase { (db) in
//            //db.beginTransaction()
//            var arrAddress = [FKYAddressItemModel]()
//            do {
//                let res = try db.executeQuery(query, values: arguments)
//                while res.next() {
//                    let code = res.string(forColumn: "code")
//                    let name = res.string(forColumn: "name")
//                    let level = res.string(forColumn: "level")
//                    let parentCode = res.string(forColumn: "parentCode")
//                    let item = FKYAddressItemModel.init(code: code, name: name, level: level, parentCode: parentCode)
//                    arrAddress.append(item)
//                }
//                res.close()
//            } catch {
//                print("failed: \(error.localizedDescription)")
//            }
//            //db.commit()
//            resultBlock(arrAddress)
//        }
//        queueLock.unlock()
        
        // Queue
//        dbQueue.inDatabase { (db) in
//            //db.beginTransaction()
//            var arrAddress = [FKYAddressItemModel]()
//            do {
//                let res = try db.executeQuery(query, values: arguments)
//                while res.next() {
//                    let code = res.string(forColumn: "code")
//                    let name = res.string(forColumn: "name")
//                    let level = res.string(forColumn: "level")
//                    let parentCode = res.string(forColumn: "parentCode")
//                    let item = FKYAddressItemModel.init(code: code, name: name, level: level, parentCode: parentCode)
//                    arrAddress.append(item)
//                }
//                res.close()
//            } catch {
//                print("failed: \(error.localizedDescription)")
//            }
//            //db.commit()
//            resultBlock(arrAddress)
//        }
    }
    
    // 增、删、改...<单条>
    func updateAddressDatabaseForSingle(_ sql: String? , arguments: [Any]?, _ callback: @escaping (Bool)->()) {
        guard let s = sql, !s.isEmpty else {
            callback(false)
            return
        }
        
        guard let list = arguments, list.count > 0 else {
            callback(false)
            return
        }
        
        // Serial + Lock + Queue + Transaction
        writeQueue.addOperation {
            self.queueLock.lock()
            self.dbQueue.inTransaction { (db, rollback) in
                do {
                    try db.executeUpdate(s, values: list)
                    print("update success")
                    callback(true)
                } catch {
                    rollback.pointee = true
                    print("failed: \(error.localizedDescription)")
                    callback(false)
                }
            }
            self.queueLock.unlock()
        }
    }
    
    // 增、删、改...<多条>
    func updateAddressDatabaseForMulti(_ sqls: [String]? , arguments: [[Any]]?, _ callback: @escaping (Bool)->()) {
        guard let slist = sqls, slist.count > 0 else {
            callback(false)
            return
        }
        
        guard let alist = arguments, alist.count > 0 else {
            callback(false)
            return
        }
        
        guard slist.count == alist.count else {
            callback(false)
            return
        }
        
        // Serial + Lock + Queue + Transaction
        writeQueue.addOperation {
            self.queueLock.lock()
            self.dbQueue.inTransaction { (db, rollback) in
                do {
                    for index in 0...slist.count-1 {
                        try db.executeUpdate(slist[index], values: alist[index])
                        print("update success")
                    }
                    callback(true)
                } catch {
                    rollback.pointee = true
                    print("failed: \(error.localizedDescription)")
                    callback(false)
                }
            }
            self.queueLock.unlock()
        }
        
        // Queue + Transaction
//        dbQueue.inTransaction { (db, rollback) in
//            do {
//                for index in 0...slist.count-1 {
//                    try db.executeUpdate(slist[index], values: alist[index])
//                    print("update success")
//                }
//            } catch {
//                rollback.pointee = true
//                //print(error)
//                print("failed: \(error.localizedDescription)")
//            }
//        }
    }
}


//MARK: - 增、删、改、查 <使用DB>...<针对单次查询or更新>...<暂未使用>
extension FKYAddressDBManager {
    // 查
    func fetchAddressItemList(_ sql: String?, _ arguments: [Any]?) -> [Any] {
        // SQL
        guard let s = sql, s.isEmpty == false else {
            return [Any]()
        }
        
        // DB路径
        let dbDoc = getAddressDatabaseDocPath()
        guard let doc = dbDoc, doc.isEmpty == false else {
            return [Any]()
        }
        
        // 最终DB
        let db = FMDatabase.init(path: doc)
        guard db.open() else {
            return [Any]()
        }
        
        var arrAddress = [FKYAddressItemModel]()
        do {
            let res = try db.executeQuery(s, values: arguments)
            while res.next() {
                let code = res.string(forColumn: "code")
                let name = res.string(forColumn: "name")
                let level = res.string(forColumn: "level")
                let parentCode = res.string(forColumn: "parentCode")
                let item = FKYAddressItemModel.init(code: code, name: name, level: level, parentCode: parentCode)
                arrAddress.append(item)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        db.close()
        return arrAddress
    }
    
    // 增、删、改...<支持批量操作，即多条更新语句>
    @discardableResult
    func updateAddressList(_ sqls: [String]? , arguments: [[Any]]?) -> Bool {
        guard let slist = sqls, slist.count > 0 else {
            return false
        }
        
        guard let alist = arguments, alist.count > 0 else {
            return false
        }
        
        guard slist.count == alist.count else {
            return false
        }
        
        let dbDoc = getAddressDatabaseDocPath()
        guard let doc = dbDoc, doc.isEmpty == false else {
            return false
        }
        
        let db = FMDatabase.init(path: doc)
        guard db.open() else {
            return false
        }
        
        db.beginTransaction()
        var rollback = false
        for index in 0...slist.count-1 {
            if db.executeUpdate(slist[index], withArgumentsIn: alist[index]) {
                print("update success")
            }
            else {
                print("update fail")
                rollback = true
            }
        }
        if rollback {
            db.rollback()
        }
        else {
            db.commit()
        }
        db.close()
        
        return rollback ? false : true
    }
}


//MARK: - DOC
extension FKYAddressDBManager {
    // copy...<将工程中由开发人员导入到资源文件目录中的地址数据库DB手动COPY到DOC目录>
    @discardableResult
    func copyAddressDatabaseToDoc() -> Bool {
        // 先删除之前已经存在的db
        guard removeAddressDatabaseInDoc() else {
            return false
        }
        
        // 保存在DOC中的数据库文件路径
        let dbDoc = getAddressDatabaseDocPath()
        guard let doc = dbDoc, doc.isEmpty == false else {
            // db路径不存在
            return false
        }
        
        // Bundle中的数据库文件路径
        let dbBundle = getAddressDatabaseBundlePath()
        guard let bundle = dbBundle, bundle.isEmpty == false else {
            return false
        }
        
        // 将资源目录中只读的DB文件COPY到DOC中，以便可以对其进行读写操作
        do {
            try FileManager.default.copyItem(atPath: bundle, toPath: doc)
            print("COPY数据库DB文件至DOC目录成功")
            return true
        }
        catch {
            print("COPY数据库DB文件至DOC目录失败")
            return false
        }
    }
    
    // remove...<删除DOC中保存的地址DB>
    @discardableResult
    func removeAddressDatabaseInDoc() -> Bool {
        // 保存在DOC中的数据库文件路径
        let dbDoc = getAddressDatabaseDocPath()
        guard let doc = dbDoc, doc.isEmpty == false else {
            // db路径不存在
            return false
        }
        
        guard FileManager.default.fileExists(atPath: doc) else {
            // db不存在
            return true
        }
        
        do {
            try FileManager.default.removeItem(atPath: doc)
            print("删除DOC目录下的数据库DB文件成功")
            return true
        }
        catch {
            print("删除DOC目录下的数据库DB文件失败")
            return false
        }
    }
    
    // 获取导入到App资源文件中的地址BD路径...<只读>
    fileprivate func getAddressDatabaseBundlePath() -> String? {
        return Bundle.main.path(forResource: "address", ofType: "db")
    }
    
    // 获取DOC中保存的地址DB路径...<可读写>
    fileprivate func getAddressDatabaseDocPath() -> String? {
        // 保存在DOC中的数据库文件夹路径
        let docPath = getAppDocDirectory()
        return (docPath as NSString).appendingPathComponent("address.db")
    }
    
    // 获取DOC目录
    fileprivate func getAppDocDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    // 更新...<当App更新时，若App资源文件中的地址BD版本高于之前Copy到Doc中的DB版本，则需要将最新的DB重新Copy到Doc中>
    fileprivate func updateDBInDocByReplace() {
        // 对比版本号
        let versionBundle: Int64? = getAddressDatabaseVersionInBundle()
        let versionDoc: Int64? = getAddressDatabaseVersion()
        guard let versionD = versionDoc else {
            // Doc中未查询到版本号...<error>
            print("Doc中未查询到版本号...<直接copy>")
            copyAddressDatabaseToDoc()
            return
        }
        guard let versionB = versionBundle else {
            print("Bundle中未查询到版本号...<不做操作>")
            return
        }
        if versionB > versionD {
            // Bundle中的db版本号 > Doc中的db版本号
            print("Bundle中的db版本号 > Doc中的db版本号...<直接copy>")
            copyAddressDatabaseToDoc()
        }
        else {
            // Doc中的db版本是最新的
            print("Doc中的db版本是最新的...<不做操作>")
        }
    }
}


//MARK: - Request
extension FKYAddressDBManager {
    // 分页获取更新过的地址数据...<判断当前本地db是否需要更新>
    fileprivate func requestUpdateDataForAddressDatabase(_ version: Int64, _ callback: @escaping (_ item: FKYAddressUpdateModel?, _ message: String?)->()) {
        let parameters = ["levels": "1,2,3,4", "version": version, "pageNum": pageNumber, "pageSize": pageSize] as [String : Any]
        requestService.requestAddressDatabaseUpdateInfo(withParams: parameters) { (responseObj, error) in
            // 请求失败or无数据返回
            guard let response = responseObj, response is FKYAddressUpdateModel else {
                callback(nil, "request error~!@")
                return
            }
            
            // 请求成功且有数据返回
            let item = response as! FKYAddressUpdateModel
            self.updateItemList.append(item)
            // 判断是否需要继续分页加载
            guard let hasNext = item.hasNextPage, hasNext else {
                callback(item, nil)
                return
            }
            // 页码自增
            self.pageNumber = self.pageNumber + 1
            // 递归请求下一页
            self.requestUpdateDataForAddressDatabase(version, { (item, msg) in
                callback(item, msg)
            })
        }
    }
}
