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
        self.bubbleImage.image = UIImage(named: "bubbleMine.png")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
        self.bubbleImage.addSubview(label)
        self.bubbleImage.frame = CGRect(x:0, y:0, width: 27 + label.frame.size.width, height:label.frame.size.height + 16)
        self.addSubview(self.bubbleImage)        
    }
    
}
