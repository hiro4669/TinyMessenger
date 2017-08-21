//
//  MessageViewCell.swift
//  TinyMessenger
//
//  Created by Hiroaki Fukuda on 2017/08/21.
//  Copyright © 2017 Hiroaki Fukuda. All rights reserved.
//

import Foundation
import UIKit

class MessageViewCell :UITableViewCell {
    
    var message     : Message!
    var bubbleImage : UIImageView = UIImageView()
    
    override init(style: UITableViewCellStyle , reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = UIColor(patternImage: UIImage(named: "main_back.png")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(msg:Message) {
        self.message = msg
        let label:UILabel = self.message.label
        
        let h:CGFloat = label.frame.size.height
        let w:CGFloat = label.frame.size.width
        
        if self.message.type == MsgType.Mine {
            self.bubbleImage.image = UIImage(named: "bubbleMine.png")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
            self.bubbleImage.addSubview(label)
            
//            print("parent width = \(self.frame.size.width)")
//            print("image width  = \(w+27)")
            
            let offset:CGFloat = self.frame.size.width - w + 27

            self.bubbleImage.frame = CGRect(x:offset, y:0, width: 27 + w, height:h + 16)
        } else {
            self.bubbleImage.image = UIImage(named: "bubbleSomeone.png")?.stretchableImage(withLeftCapWidth: 21, topCapHeight: 14)
            self.bubbleImage.addSubview(label)
            self.bubbleImage.frame = CGRect(x:0, y:0, width: 27 + w, height:h + 16)
        }
        self.addSubview(self.bubbleImage)
    }
    
}
