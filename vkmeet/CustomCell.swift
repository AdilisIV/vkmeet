//
//  CustomCell.swift
//  vkmeet
//
//  Created by user on 2/25/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var willgoButtonOutlet: WillGoButton!
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: AlignableUILabel!
    @IBOutlet weak var countOfMembers: UILabel!
    @IBOutlet weak var eventbgImage: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var outerImageView: UIImageView!
    
    @IBOutlet weak var outerBackImage: UIImageView!
    
    @IBOutlet weak var eventBlock: UIImageView!
    
    var isCommercePlacement: Bool = false
    
    func setupViews() {
        
        // cellName
        cellName.contentMode = UIViewContentMode.top
    
        
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
        
        
        // eventDateLabel
        eventDateLabel.layer.cornerRadius = 35
        cellImage.layer.masksToBounds = true
        
        
        // eventBlock
        eventBlock.layer.cornerRadius = 10
        eventBlock.layer.masksToBounds = true
        eventBlock.layer.borderWidth = 1.5
        eventBlock.layer.borderColor = UIColor.rgb(red: 241, green: 241, blue: 241).cgColor
    }
    
    
    func cancelCommerce() {
        //eventBlock.backgroundColor = UIColor.rgb(red: 251, green: 253, blue: 255)
        eventBlock.layer.borderColor = UIColor.rgb(red: 241, green: 241, blue: 241).cgColor
        eventDateLabel.textColor = UIColor.rgb(red: 75, green: 108, blue: 139)
        cellName.textColor = UIColor.rgb(red: 33, green: 33, blue: 33)
        willgoButtonOutlet.backgroundColor = UIColor.rgb(red: 202, green: 219, blue: 236)
        outerBackImage.layer.shadowColor = UIColor.black.cgColor
        outerBackImage.layer.shadowOpacity = 0.15
    }
    
    func takeCommerce() {
        eventBlock.backgroundColor = UIColor.rgb(red: 80, green: 95, blue: 125)
        eventBlock.layer.borderColor = UIColor.rgb(red: 80, green: 95, blue: 125).cgColor
        eventDateLabel.textColor = UIColor.rgb(red: 202, green: 219, blue: 236)
        cellName.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        willgoButtonOutlet.backgroundColor = UIColor.rgb(red: 167, green: 182, blue: 199)
        outerBackImage.layer.shadowColor = UIColor.rgb(red: 62, green: 143, blue: 246).cgColor
        outerBackImage.layer.shadowOpacity = 0.21
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
