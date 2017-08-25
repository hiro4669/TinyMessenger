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
    

    var messages = [Message]()
    
    var editingField:UITextField?
    var overlap:CGFloat = 0.0
    
    func update() -> Void {
        let nos = tableView.numberOfSections
        let nor = tableView.numberOfRows(inSection: nos - 1)
        let lastIndex:IndexPath = IndexPath(row: nor-1, section: nos-1)
        if nor > 0 {
            tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
        }
    }
    
    func initTable() {
        self.tableView.register(MessageViewCell.self, forCellReuseIdentifier: "cell")
        
        
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "main_back.png")!)
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        for _ in 1...10 {
            increment(msgStr:"cde")
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
        
        
        let notification = NotificationCenter.default
        
        // keyboard change
        notification.addObserver(self,
                                 selector: #selector(self.keyboardChangeFrame(_:)),
                                 name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        // keyboard appear
        notification.addObserver(self,
                                 selector: #selector(self.keyboardWillShow(_:)),
                                 name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // keyboard hide
        notification.addObserver(self,
                                 selector: #selector(self.keyboardDidHide(_:)), name: Notification.Name.UIKeyboardDidHide,
                                 object: nil)
        
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
//        print("cell created \(indexPath.row)")
        let cell:MessageViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! MessageViewCell
        cell.setup(msg: messages[indexPath.row])
        return cell
    }
    
    /* textField Delegate */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("didBeginEditing")
        self.editingField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("didEndEditing")
        self.editingField = nil
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    
    /* Notification Center */
    func keyboardChangeFrame(_ notification: Notification) -> Void {
        print("keyboard change frame")
        guard let fld = editingField else {
            return
        }
//        print(fld)
        let userInfo = (notification as Notification).userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let newY = keyboardFrame.minY - fld.frame.size.height
        let newFrame = CGRect(x: fld.frame.minX, y: newY, width: fld.frame.size.width, height: fld.frame.size.height)
        fld.frame = newFrame
        /*
        let userInfo = (notification as Notification).userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print("field = \(fld.frame.maxY)")
        print("keyboard min = \(keyboardFrame.minY)")
        print("keyboard max = \(keyboardFrame.maxY)")
        print("text height = \(fld.frame.size.height)")
        
        overlap = fld.frame.maxY - keyboardFrame.midY + 5
        if overlap > 0 {
            print("overlap = \(overlap)")
            let newY = keyboardFrame.minY - fld.frame.size.height

            let newFrame = CGRect(x: fld.frame.minX, y: newY, width: fld.frame.size.width, height: fld.frame.size.height)
//            let newFrame = CGRect(x: fld.frame.minX, y: overlap, width: fld.frame.size.width, height: fld.frame.size.height)
            fld.frame = newFrame
        }
        */
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        print("keyboard will show")
    }
    
    func keyboardDidHide(_ notification: Notification) {
        print("keyboard will hide")
    }
    
    

}

