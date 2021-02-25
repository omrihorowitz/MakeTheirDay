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
    
    var quote: QuoteStruct? {
        didSet {
            updateViews()
        }
    }
    
    override func prepareForReuse() {
            inspirationImageView.image = nil
        }

    func updateViews(){
        guard let quote = quote else { return }
        inspirationQuoteLabel.text = "\"\(quote.text)\""
        inspirationAuthorLabel.text = "- \(quote.author ?? "Unknown")"
    }
    
    func updateImage(image: UIImage) {
        let inspirationImage = image
        inspirationImageView.image = inspirationImage
    }
    
} // End of Class
