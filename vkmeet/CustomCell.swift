//
//  CustomCell.swift
//  vkmeet
//
//  Created by user on 2/25/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var breedName: UILabel!
    @IBOutlet var eventDescription: UITextView!
    
    
    func setupViews() {
        
        // eventsImageView
        photo.layer.cornerRadius = 42
        photo.layer.masksToBounds = true
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
