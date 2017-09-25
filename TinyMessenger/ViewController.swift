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
    

    @IBOutlet weak var subView: UIView!
    var messages = [Message]()
    
    var editingField:UITextField?
    var overlap:CGFloat = 0.0
    
    var uid:Int = 1
    var tid:Int = 10
    let msgSender: MsgSender = MsgSender(sendUrl: "http://localhost:8080/json",
                                         checkUrl: "http://localhost:8080/id")
    
    func notify(message:Message) -> Void {
        message.show()
        messages.append(message)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.update()
        }
    }
    
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
    
    func sendMessage(msgStr:String) {
        let msg = Message(msg:msgStr, type:MsgType.Mine, tid:self.tid, uid:self.uid)
        messages.append(msg)
        msgSender.sendMessage(uid: msg.uid, tid: msg.tid, msg: msg.msg)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initTable()
        initTextField()
        msgSender.controller = self
        
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
//            increment(msgStr: msg)
            sendMessage(msgStr: msg)
            tableView.reloadData()
            DispatchQueue.main.async {
                self.update()
            }
            
            view.endEditing(true)
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
        if editingField == nil {
            return
        }
        let userInfo = (notification as Notification).userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let newY = keyboardFrame.minY - subView.frame.size.height
        let newFrame = CGRect(x: subView.frame.minX, y: newY, width: subView.frame.size.width, height: subView.frame.size.height)
        subView.frame = newFrame
    }
    
    func keyboardWillShow(_ notification: Notification) {
        print("keyboard will show")
    }
    
    func keyboardDidHide(_ notification: Notification) {
        print("keyboard will hide")
    }
    
    @IBAction func checkMessage(_ sender: Any) {
        print("check message")
        msgSender.checkMessage(id: self.uid)
    }
    

}

