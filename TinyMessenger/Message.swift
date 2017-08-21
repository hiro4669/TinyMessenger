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
    }
    
    convenience init(msg:String, type:MsgType) {
        self.init(msg:msg)
        self.type = type

    }
    
    func hello() {
        print(msg)
    }
    
}
