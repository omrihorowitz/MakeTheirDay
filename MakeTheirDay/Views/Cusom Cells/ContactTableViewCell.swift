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

    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Methods
    func setupCell(contact: Contact) {
        contactPic.image = contact.contactPhoto
        contactName.text = contact.name
        lastInTouch.text = contact.lastInTouch
    }
}//End of class
