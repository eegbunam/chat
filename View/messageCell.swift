//
//  MessageCell.swift
//  ChatApp Prototype
//
//  Created by Daramfon Akpan on 6/6/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var rightMessageImage: UIImageView!
    @IBOutlet weak var leftMessageImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.height/5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func updateViews(){
        messageText.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func sentByMe(){
        leftMessageImage.isHidden = true
        rightMessageImage.isHidden = false
        messageBubble.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
    }
    func notSentByMe(){
        rightMessageImage.isHidden = true
        leftMessageImage.isHidden = false
        messageBubble.backgroundColor = #colorLiteral(red: 0.7920167346, green: 1, blue: 0.9431315405, alpha: 1)
        
    }
    
}
