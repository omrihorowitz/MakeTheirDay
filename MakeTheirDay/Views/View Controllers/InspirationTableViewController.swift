//
//  InspirationTableViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit

class InspirationTableViewController: UITableViewController {

    //MARK: - Source of Truth
    var quotes: [Quote] = []
    var images: [UIImage] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchQuotes()
    }
    
    //MARK: - Helpers
    
    func fetchQuotes() {
        InspirationPostController.fetchQuote { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let quotes):
                    self.quotes = quotes
                    self.fetchImages()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
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
        // #warning Incomplete implementation, return the number of rows
        return quotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "inspirationCell", for: indexPath) as? InspirationPostTableViewCell else { return UITableViewCell() }
        
        let quote = quotes[indexPath.row]
        let image = images[indexPath.row]
        cell.quote = quote
        cell.inspirationImage = image 

        return cell
    }
}
