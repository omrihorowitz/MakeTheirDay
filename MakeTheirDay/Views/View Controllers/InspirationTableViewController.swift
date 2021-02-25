//
//  InspirationTableViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit

class InspirationTableViewController: UITableViewController {

    //MARK: - Source of Truth
    var quotes: [QuoteStruct] = []
    var images: [UIImage] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchImages()
        tableView.reloadData()
    }
    
    //MARK: - Helpers
    
    func fetchImages() {
        InspirationPostController.fetchUniqueImages { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    self.images = images
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "inspirationCell", for: indexPath) as? InspirationPostTableViewCell else { return UITableViewCell() }
        
        let allQuotes: [QuoteList] = [First400Quotes(), Second400Quotes(), Third400Quotes(), Fourth400Quotes()]
        let quote = allQuotes.randomElement()?.quotes.randomElement()
        
        cell.updateImage(image: images[indexPath.row])
        cell.quote = quote

        return cell
    }
}
