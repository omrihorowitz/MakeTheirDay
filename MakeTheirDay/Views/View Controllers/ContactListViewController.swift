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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Properties
    var contacts: [Contact] = []
    var isSearching = false
    
    //MARK: - Methods
    func fetchAllContacts() {
        
        let predicate = NSPredicate(value: true)
        
        ContactController.sharedInstance.fetchContacts(predicate: predicate) { (result) in
            
            switch result {
            case .success(let contacts):
                ContactController.sharedInstance.contacts = contacts.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                self.contacts = ContactController.sharedInstance.contacts
                DispatchQueue.main.async {
                }
                
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell

        guard let contact = contacts[indexPath.row] as Contact? else {return UITableViewCell()}
        cell?.setupCell(contact: contact)

        return cell ?? UITableViewCell()
    }
    
    // MARK: - Navigation
    func prepare(for segue: UIStoryboardSegue, sender: ContactTableViewCell?) {
        
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? ContactDetailViewController else {return}
            let contactToSend = contacts[indexPath.row]
            destinationVC.contact = contactToSend
        }
    }
}//End of class
