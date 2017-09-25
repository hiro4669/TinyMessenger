//
//  Message.swift
//  TinyMessenger
//
//  Created by Hiroaki Fukuda on 2017/08/21.
//  Copyright © 2017 Hiroaki Fukuda. All rights reserved.
//

import Foundation
import UIKit

enum MsgType {
    case Mine
    case Other
}

class Message {
    
    let msg:String
    let font:UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var type:MsgType = MsgType.Mine
    
    var tid:Int
    var uid:Int
    
    var label:UILabel {
        let lb:UILabel = UILabel()
        lb.text = self.msg
        lb.font = self.font
        let xv = self.type == MsgType.Mine ? 8 : 15
        lb.frame = CGRect(x:xv, y:5, width:210, height:9999)
        lb.numberOfLines = 0
        lb.lineBreakMode = NSLineBreakMode.byWordWrapping
        lb.backgroundColor = UIColor.clear
        lb.sizeToFit()
        return lb
    }

    
    init(msg:String = "Hello") {
        self.msg = msg
        self.tid = 0
        self.uid = 0
    }
    
    convenience init(msg:String, type:MsgType) {
        self.init(msg:msg)
        self.type = type

    }
    
    convenience init(msg:String, type:MsgType, tid:Int, uid:Int) {
        self.init(msg:msg, type:type)
        self.tid = tid
        self.uid = uid
    }
    
    func hello() {
        print(msg)
    }
    
    func show() -> Void {
        print(String(format:"from %d: to %d: msg->%@", self.tid, self.uid, self.msg))
    }
    
}
