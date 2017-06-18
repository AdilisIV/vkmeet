//
//  CustomCell.swift
//  vkmeet
//
//  Created by user on 2/25/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet var willgoButtonOutlet: WillGoButton!
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellName: UITextView!
    @IBOutlet var countOfMembers: UILabel!
    @IBOutlet var eventbgImage: UIImageView!
    @IBOutlet var eventDateLabel: UILabel!
    
    @IBOutlet var outerImageView: UIImageView!
    
    @IBOutlet var outerBackImage: UIImageView!
    
    @IBOutlet var eventBlock: UIImageView!
    
    
    func setupViews() {
        
        // willgoButtonOutlet
        
        
        
        // textView
        cellName.frame = CGRect(x: 0, y: 0, width: cellName.frame.width, height: 49)
        cellName.isUserInteractionEnabled = false
        cellName.textContainer.maximumNumberOfLines = 2
        cellName.textContainer.lineBreakMode = NSLineBreakMode.byClipping
        
        
        
        // set avatar shadow
        outerImageView.frame = CGRect(x: 17, y: 9, width: outerImageView.frame.width, height: outerImageView.frame.height)
        outerImageView.clipsToBounds = false
        outerImageView.layer.shadowColor = UIColor.black.cgColor
        outerImageView.layer.shadowOpacity = 0.35
        outerImageView.layer.shadowOffset = CGSize.zero
        //outerImageView.layer.shadowPath = (10 as! CGPath)
        outerImageView.layer.shadowPath = UIBezierPath(roundedRect: outerImageView.bounds, cornerRadius: 10).cgPath
        
        
        
        // set eventBlock shadow
        outerBackImage.frame = CGRect(x: 56, y: 23, width: outerBackImage.frame.width, height: outerBackImage.frame.height)
        outerBackImage.clipsToBounds = false
        outerBackImage.layer.shadowColor = UIColor.black.cgColor
        outerBackImage.layer.shadowOpacity = 0.15
        outerBackImage.layer.shadowOffset = CGSize.zero
        outerBackImage.layer.shadowPath = UIBezierPath(roundedRect: outerBackImage.bounds, cornerRadius: 10).cgPath
        
        
        
        // eventsImageView
        cellImage.layer.cornerRadius = 10
        cellImage.layer.masksToBounds = true
        //eventbgImage.layer.cornerRadius = 47
        //eventbgImage.layer.masksToBounds = true
        
        
        
        // eventDateLabel
        eventDateLabel.layer.cornerRadius = 35
        cellImage.layer.masksToBounds = true
        
        
        // eventBlock
        eventBlock.layer.cornerRadius = 10
        eventBlock.layer.masksToBounds = true
        eventBlock.layer.borderWidth = 1.5
        eventBlock.layer.borderColor = UIColor.rgb(red: 241, green: 241, blue: 241).cgColor
    }
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
