//
//  InspirationPostTableViewCell.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit

class InspirationPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var inspirationImageView: UIImageView!
    @IBOutlet weak var inspirationQuoteLabel: UILabel!
    @IBOutlet weak var inspirationAuthorLabel: UILabel!
    
    var quote: Quote? {
        didSet {
            updateViews()
        }
    }
    
    override func prepareForReuse() {
            inspirationImageView.image = nil
        }
    
    var inspirationImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    func updateViews(){
        guard let quote = quote else { return }
        inspirationQuoteLabel.text = "\"\(quote.text)\""
        inspirationAuthorLabel.text = "- \(quote.author ?? "Unknown")"
    }
    
    func updateImage() {
        guard let inspirationImage = inspirationImage else { return }
        inspirationImageView.image = inspirationImage
    }
    
} // End of Class
