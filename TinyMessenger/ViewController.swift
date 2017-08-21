//
//  ViewController.swift
//  TinyMessenger
//
//  Created by Hiroaki Fukuda on 2017/08/21.
//  Copyright © 2017 Hiroaki Fukuda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
//    var items = [String]()
    
    var messages = [Message]()
    
    func update() -> Void {
        let nos = tableView.numberOfSections
        let nor = tableView.numberOfRows(inSection: nos - 1)
        let lastIndex:IndexPath = IndexPath(row: nor-1, section: nos-1)
        if nor > 0 {
            tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
        }
    }
    
    func initTable() {
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "main_back.png")!)
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        for _ in 1...10 {
            increment()
        }
    }
    
    func initTextField() {
        messageField.delegate = self
    }
    
    func increment(msgStr:String = "abc") {
        if messages.count % 2 == 0 {
//            messages.append(Message(msg:"message\(messages.count)", type:MsgType.Mine))
            messages.append(Message(msg: msgStr, type:MsgType.Mine))
        } else {
            messages.append(Message(msg: msgStr, type:MsgType.Other))
//            messages.append(Message(msg:"message\(messages.count)", type:MsgType.Other))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initTable()
        initTextField()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendHandler(_ sender: Any) {
        print("Send")
        if let msg = self.messageField.text {
            print(msg)
            increment(msgStr: msg)  
//        increment()
            tableView.reloadData()
            DispatchQueue.main.async {
                self.update()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell created \(indexPath.row)")
//        var cell:MessageViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? MessageViewCell
//        if cell == nil {
//            cell = MessageViewCell(style: .default, reuseIdentifier: "cell")
//        }
        
        let cell = MessageViewCell(style: .default, reuseIdentifier: "cell")
        cell.setup(msg: messages[indexPath.row])
        return cell
//        cell?.setup(msg: messages[indexPath.row])
//        return cell!
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

}

