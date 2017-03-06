//
//  ViewController.swift
//  MultipleDelete
//
//  Created by vivayashi on 2017/03/06.
//  Copyright © 2017年 vivayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var deleteArray: [String] = ["にんじん", "たまねぎ", "じゃがいも", "ルー", "肉", "米", "はちみつ", "りんご", "スプーン", "皿"]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationControllerの設定
        self.title = "複数選択で削除"
        self.editButtonItem.title = "編集"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // tableViewの設定
        tableView = UITableView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: self.view.frame.width, height: self.view.frame.height))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelectionDuringEditing = true
        self.view.addSubview(tableView)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            // 編集開始
            self.editButtonItem.title = "完了"
        } else {
            // 編集終了
            self.editButtonItem.title = "編集"
            self.deleteRows()
        }
        
        // 編集モード時のみ複数選択可能とする
        tableView.isEditing = editing
    }
    
    private func deleteRows() {
        guard let selectedIndexPaths = self.tableView.indexPathsForSelectedRows else {
            return
        }
        
        // 配列の要素削除で、indexの矛盾を防ぐため、降順にソートする
        let sortedIndexPaths =  selectedIndexPaths.sorted { $0.row > $1.row }
        for indexPathList in sortedIndexPaths {
            deleteArray.remove(at: indexPathList.row) // 選択肢のindexPathから配列の要素を削除
        }
        
        // tableViewの行を削除
        tableView.deleteRows(at: sortedIndexPaths, with: UITableViewRowAnimation.automatic)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deleteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        cell.textLabel!.text = "\(deleteArray[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 編集モードじゃない場合はreturn
        guard tableView.isEditing else { return }
        
        if let _ = self.tableView.indexPathsForSelectedRows {
            // 選択肢にチェックが一つでも入ってたら「削除」を表示する。
            self.editButtonItem.title = "削除"
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 編集モードじゃない場合はreturn
        guard tableView.isEditing else { return }
        
        if let _ = self.tableView.indexPathsForSelectedRows {
            self.editButtonItem.title = "削除"
        } else {
            // 何もチェックされていないときは完了を表示
            self.editButtonItem.title = "完了"
        }
    }
}

