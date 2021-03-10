//
//  GalaxyViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/25/21.
//
import UIKit
import NVActivityIndicatorView

class GalaxyViewController: UIViewController {
    
    //MARK: - Properties
    
    var selectedImage: UIImage?
    var favoriteContacts: [Contact] = []
    private var imageViews: [UIImageView] = []
    
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
        setupViews()
    }

    //MARK: - Actions
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        setupViews()
    }
    
    @IBAction func credits(_ sender: Any) {
        let alert = UIAlertController(title: "Credits", message: "📷 • @Unsplash\n🎵🥶 • @mahalo_dj\n🌀 • @ninjaprox\n👩🏼‍🎨 • @sliztoonz", preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default)
        alert.view.tintColor = UIColor.blue  // change text color of the buttons
        alert.view.backgroundColor = UIColor.cyan  // change background color
        alert.view.layer.cornerRadius = 25   // change corner radius
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    
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
        startAnimation()
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
        imageViews = [favoriteContactPic1, favoriteContactPic2, favoriteContactPic3, favoriteContactPic4, favoriteContactPic5]
        fetchUser()
        ContactController.sharedInstance.fetchContacts { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.favoriteContacts = ContactController.sharedInstance.favoriteContacts()
                    self.populateFavorites()
                case .failure(let error):
                    print(error)
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            loading.stopAnimating()
        }
    }
    
    func populateFavorites() {
        for (index,favorite) in favoriteContacts.enumerated() {
            imageViews[index].image = favorite.contactPhoto
        }
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
            if let user = UserController.sharedInstance.currentUser {
                UserController.sharedInstance.updateUser(user: user, profilePhoto: selectedImage) { (result) in
                    switch result {
                    case .success(let user):
                        self.fetchUser()
                        print(user.recordID)
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
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
}
