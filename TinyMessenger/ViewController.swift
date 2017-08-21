//
//  ViewController.swift
//  TinyMessenger
//
//  Created by Hiroaki Fukuda on 2017/08/21.
//  Copyright © 2017 Hiroaki Fukuda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
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
    
    func increment() {
  //      items.append("item\(items.count)")
        messages.append(Message(msg:"message\(messages.count)"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initTable()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendHandler(_ sender: Any) {
        print("Send")
        increment()
        tableView.reloadData()
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell created \(indexPath.row)")
        let cell = MessageViewCell(style: .default, reuseIdentifier: "cell")
//        cell.textLabel?.textAlignment = .left // 右揃えにするなら .right
//        cell.textLabel?.text = messages[indexPath.row].msg
        cell.setup(msg: messages[indexPath.row])
        return cell
    }

}

