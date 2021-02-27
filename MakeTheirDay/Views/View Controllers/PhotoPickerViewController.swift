//
//  PhotoPickerViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/25/21.
//

import UIKit


//MARK: - Protocol
protocol PhotoPickerViewControllerDelegate: class {
    func photoPickerViewControllerSelected(image: UIImage)
}//End of protocol

class PhotoPickerViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Properties
    
    let imagePicker = UIImagePickerController()
    
    weak var delegate: PhotoPickerViewControllerDelegate?
    
    var photo: UIImage? {
        didSet {
            if photo != nil {
                loadViewIfNeeded()
                selectImageButton.setTitle("", for: .normal)
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func selectImageButton(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    //MARK: - Methods
    func updateImageView() {
        self.imageView.image = photo
    }
}//End of class

//MARK: - Extension (UIImagePickerDelegate)
extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = photo
            delegate?.photoPickerViewControllerSelected(image: photo)
            selectImageButton.setTitle("", for: .normal)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerActionSheet() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Select a Photo", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}//End of extension
