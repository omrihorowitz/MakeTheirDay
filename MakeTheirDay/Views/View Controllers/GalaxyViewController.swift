//
//  GalaxyViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/25/21.
//

import UIKit

class GalaxyViewController: UIViewController {

    //MARK: - Properties
    
    var selectedImage: UIImage?
    
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var favoriteContactPic1: UIImageView!
    @IBOutlet weak var favoriteContactPic2: UIImageView!
    @IBOutlet weak var favoriteContactPic3: UIImageView!
    @IBOutlet weak var favoriteContactPic4: UIImageView!
    @IBOutlet weak var favoriteContactPic5: UIImageView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetch contact pics
//        UserController.sharedInstance.
    }
        
    //MARK: - Actions
    
    @IBAction func credits(_ sender: Any) {
        let alert = UIAlertController(title: "Media Credits", message: "Photos from Unsplash\nMusic from Bensound", preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default)
        alert.view.tintColor = UIColor.blue  // change text color of the buttons
        alert.view.backgroundColor = UIColor.cyan  // change background color
        alert.view.layer.cornerRadius = 25   // change corner radius
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    //MARK: - Functions
    
    func fetchUser() {
        UserController.sharedInstance.fetchUser(predicate: <#T##NSPredicate#>, completion: <#T##(Result<User, CustomError>) -> Void#>)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerView" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
            }
        }
    }


//MARK: - Extensions
extension GalaxyViewController: PhotoPickerViewControllerDelegate {
    func photoPickerViewControllerSelected(image: UIImage) {
        selectedImage = image
        if let selectedImage = selectedImage {
            UserController.sharedInstance.createUser(profilePhoto: selectedImage) { (result) in
                switch result {
                case .success(let user):
                    print(user.recordID)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

