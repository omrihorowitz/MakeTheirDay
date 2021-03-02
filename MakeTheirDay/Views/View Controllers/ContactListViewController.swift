//
//  ContactListViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/25/21.
//

import UIKit
import NVActivityIndicatorView

class ContactListViewController: UIViewController {
        
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllContacts()
        tableView.delegate = self
        tableView.dataSource = self 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllContacts()
    }
    
    //MARK: - Actions
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchAllContacts()
        startAnimation()
    }
    
    //MARK: - Methods
    func fetchAllContacts() {
                
        ContactController.sharedInstance.fetchContacts { (result) in
            
            switch result {
            case .success(let success):
                print(success)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            loading.stopAnimating()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? ContactDetailViewController else {return}
            let contactToSend = ContactController.sharedInstance.contacts[indexPath.row]
            destinationVC.contact = contactToSend
        }
    }
}//End of class

//MARK: - Extensions

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.sharedInstance.contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell else {return UITableViewCell()}

        let contact = ContactController.sharedInstance.contacts[indexPath.row]
        cell.setupCell(contact: contact)
        
        return cell
    }
}
