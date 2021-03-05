//
//  InspirationTableViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit
import NVActivityIndicatorView

class InspirationTableViewController: UITableViewController {

    //MARK: - Source of Truth
    var quotes: [QuoteStruct] = []
    var images: [UIImage] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
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
    
    fileprivate func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .cyan, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 200),
            loading.heightAnchor.constraint(equalToConstant: 200),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        loading.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            loading.stopAnimating()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "inspirationCell", for: indexPath) as? InspirationPostTableViewCell else { return UITableViewCell() }
        
        let allQuotes: [QuoteList] = [First400Quotes(), Second400Quotes(), Third400Quotes(), Fourth400Quotes()]
        let quoteList = allQuotes.randomElement()
        let quote = quoteList?.quotes.randomElement()
        
        cell.updateImage(image: images[indexPath.row])
        cell.quote = quote

        return cell
    }
}
