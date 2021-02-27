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
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profilePhotoContainer: UIView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupViews()
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
        UserController.sharedInstance.fetchUser { (result) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    UserController.sharedInstance.currentUser = user
                    self.profilePhoto.image = user?.profilePhoto
                    self.profilePhotoContainer.alpha = 0.1
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupViews() {
        profilePhotoContainer.layer.cornerRadius = profilePhotoContainer.frame.height / 2
        profilePhotoContainer.clipsToBounds = true
        profilePhotoContainer.alpha = 0.75
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height / 2
        profilePhoto.clipsToBounds = true
        profilePhoto.alpha = 0.75
        favoriteContactPic1.layer.cornerRadius = favoriteContactPic1.frame.height / 2
        favoriteContactPic1.clipsToBounds = true
        favoriteContactPic1.alpha = 0.75
        favoriteContactPic2.layer.cornerRadius = favoriteContactPic2.frame.height / 2
        favoriteContactPic2.clipsToBounds = true
        favoriteContactPic2.alpha = 0.75
        favoriteContactPic3.layer.cornerRadius = favoriteContactPic3.frame.height / 2
        favoriteContactPic3.clipsToBounds = true
        favoriteContactPic3.alpha = 0.75
        favoriteContactPic4.layer.cornerRadius = favoriteContactPic4.frame.height / 2
        favoriteContactPic4.clipsToBounds = true
        favoriteContactPic4.alpha = 0.75
        favoriteContactPic5.layer.cornerRadius = favoriteContactPic5.frame.height / 2
        favoriteContactPic5.clipsToBounds = true
        favoriteContactPic5.alpha = 0.75
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
