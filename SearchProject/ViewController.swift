//
//  ViewController.swift
//  SearchProject
//
//  Created by zhifu360 on 2019/5/21.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: BaseTableReuseIdentifier)
        return tableView
    }()
    
    ///数据源
    var dataArray = ["关羽","张飞","马超","黄忠","魏延","许褚","张辽","于禁","张颌","颜良","文丑","陆逊","吕蒙","诸葛亮","郭嘉","曹操","刘备","孙权","司马懿","罗贯中"]
    
    ///搜索结果
    var searchArray = [String]()
    
    ///UISearchController对象
    lazy var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.delegate = self
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: 60)
        searchVC.dimsBackgroundDuringPresentation = false
        return searchVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPage()
    }

    func setPage() {
        title = "演示"
        view.addSubview(tableView)
        tableView.tableHeaderView = searchController.searchBar
    }

}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchArray.count
        } else {
            return dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableReuseIdentifier, for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = searchController.isActive ? searchArray[indexPath.row] : dataArray[indexPath.row]
        return cell
    }
    
}

extension ViewController: UISearchControllerDelegate,UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //使用filter函数
        if var text = searchController.searchBar.text {
            
            if #available(iOS 9, *) {
                text = text.trimmingCharacters(in: .whitespaces)
                searchArray = dataArray.filter({ (item) -> Bool in
                    return item.localizedStandardContains(text)
                })
                tableView.reloadData()
            } else {
                //过滤条件
                let pred = NSPredicate(format: "SELF CONTAINS [c] %@", text)
                //过滤元素
                searchArray = (dataArray as! NSMutableArray).filtered(using: pred) as! [String]
                tableView.reloadData()
            }
            
        }
    }
    
}

