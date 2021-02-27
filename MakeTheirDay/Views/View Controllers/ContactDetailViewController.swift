//
//  ContactDetailViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/25/21.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var contactPic: UIView!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var lastInTouch: UITextField!
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
        }
    }
    
    var selectedImage: UIImage?
    
    //MARK: - Actions

    @IBAction func deleteButtonTapped(_ sender: Any) {
        presentDeleteButtonAlertController()
    }
    
    @IBAction func addContactButtonTapped(_ sender: Any) {
        guard let name = contactName.text, !name.isEmpty,
              let spokenStatus = lastInTouch.text, !spokenStatus.isEmpty,
              let contactPhoto = selectedImage else {self.presentTextFieldAlertController() ; return
    }

        if let contact = contact {
            ContactController.sharedInstance.update(contact: contact, name: name, lastInTouch: "\(String(describing: lastInTouch))", contactPhoto: contactPhoto) { (result) in
                self.switchOnResult(result)
            }

        } else {
            ContactController.sharedInstance.saveContact(name: name, lastInTouch: "\(String(describing: lastInTouch))", contactPhoto: contactPhoto) { (result) in
                self.switchOnResult(result)
            }
        }
    }

//MARK: - Methods
func updateUI() {
    guard let contact = contact else {return}
    contactName.text = contact.name
    lastInTouch.text = contact.lastInTouch
}

func switchOnResult(_ result: Result<Contact, CustomError>) {
    DispatchQueue.main.async {
        switch result {
        case .success(_):
            self.navigationController?.popViewController(animated: true)

        case .failure(let error):
            self.presentErrorToUser(localizedError: error)
        }
    }
}

func presentTextFieldAlertController() {
    let alert = UIAlertController(title: "Please fill out all required fields", message: "First name and Photo", preferredStyle: .alert)

    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)

    alert.addAction(action)

    present(alert, animated: true)
}

func presentDeleteButtonAlertController() {
    let alert = UIAlertController(title: "Delete Contact", message: "Are you sure about that?", preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)

    let confirmAction = UIAlertAction(title: "Yeah, I hate this person", style: .destructive) { (_) in

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
