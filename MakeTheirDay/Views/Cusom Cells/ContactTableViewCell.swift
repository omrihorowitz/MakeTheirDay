//
//  ContactTableViewCell.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var contactPic: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var lastInTouch: UILabel!
    @IBOutlet weak var favoriteButtonImage: UIImageView!
    
    //MARK: - Methods
    func setupCell(contact: Contact) {
        contactPic.image = contact.contactPhoto
        contactName.text = contact.name
        lastInTouch.text = contact.lastInTouch
        if contact.favorite == true {
            favoriteButtonImage.image = UIImage(systemName: "star.fill")
        } else {
            favoriteButtonImage.image = UIImage(systemName: "star")
        }
    }
}//End of class
