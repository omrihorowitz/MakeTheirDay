//
//  ContactDetailViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/25/21.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var contactPhotoContainer: UIView!
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var lastInTouch: UITextField!
    @IBOutlet weak var favoriteButtonImage: UIButton!
    @IBOutlet weak var deleteContactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        deleteContactButton.isHidden = true
        addCancelKeyboardGestureRecognizer()
    }
    
    //MARK: - Properties
    var contact: Contact? {
        didSet {
            loadViewIfNeeded()
            deleteContactButton.isHidden = false
            isFavorite = contact!.favorite
        }
    }
    var isFavorite = false
    var selectedImage: UIImage?
    
    //MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        let favoriteArray = ContactController.sharedInstance.contacts.filter({$0.favorite})
        if favoriteArray.count >= 5 && isFavorite == false {
            let alert = UIAlertController(title: "Easy there, cowboy...", message: "You can only mark 5 contacts as favorites.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true)
        } else {
            self.isFavorite.toggle()
            if self.isFavorite {
                self.favoriteButtonImage.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                self.favoriteButtonImage.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        presentDeleteButtonAlertController()
    }
    
    @IBAction func addContactButtonTapped(_ sender: Any) {
        guard let name = contactName.text, !name.isEmpty,
              let spokenStatus = lastInTouch.text, !spokenStatus.isEmpty,
              let contactPhoto = selectedImage else {self.presentTextFieldAlertController() ; return
        }
        
        if let contact = contact {
            ContactController.sharedInstance.updateContact(contact: contact, name: name, lastInTouch: spokenStatus, favorite: isFavorite, contactPhoto: contactPhoto) { (result) in
                self.switchOnResult(result)
            }
            
        } else {
            ContactController.sharedInstance.saveContact(name: name, lastInTouch: spokenStatus, favorite: isFavorite, contactPhoto: contactPhoto) { (result) in
                self.switchOnResult(result)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    func updateUI() {
        contactName.autocapitalizationType = .sentences
        lastInTouch.autocapitalizationType = .sentences
        guard let contact = contact else {return}
        contactName.text = contact.name
        contactPhoto.image = contact.contactPhoto
        lastInTouch.text = contact.lastInTouch
        favoriteButtonImage.setImage(contact.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
    }
    
    func switchOnResult(_ result: Result<Contact, CustomError>) {
        DispatchQueue.main.async {
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
                
            case .failure(_):
                print("This app runs on iCloud! Make sure you're signed in to add a contact.")
            }
        }
    }
    
    func presentTextFieldAlertController() {
        let alert = UIAlertController(title: "Fill out all Contact info!", message: "Name and photo plz :P", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    func presentDeleteButtonAlertController() {
        let alert = UIAlertController(title: "Delete Contact", message: "You sure?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Nope", style: .default, handler: nil)
        
        let confirmAction = UIAlertAction(title: "Mmk bye Felicia!", style: .destructive) { (_) in
            
            guard let contact = self.contact else {return}
            
            ContactController.sharedInstance.delete(contact: contact) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Contact \(contact.name) successfully deleted.")
                        self.navigationController?.popViewController(animated: true)
                        
                    case .failure(let error):
                        self.presentErrorToUser(localizedError: error)
                    }
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerView" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
            guard let photo = self.contact?.contactPhoto else {return}
            destinationVC?.photo = self.contact?.contactPhoto
            self.selectedImage = photo
        }
    }
}

//MARK: - Extensions
extension ContactDetailViewController: PhotoPickerViewControllerDelegate {
    func photoPickerViewControllerSelected(image: UIImage) {
        contactPhoto.image = image
        selectedImage = image
    }
}

extension UIViewController {
    func addCancelKeyboardGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}//End of extension
