//
//  Contact.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit
import CloudKit

struct ContactStrings {
    static let recordTypeKey = "Contact"
    fileprivate static let nameKey = "name"
    fileprivate static let lastInTouchKey = "lastInTouch"
    fileprivate static let favoriteKey = "favorite"
    fileprivate static let photoAssetKey = "photoAsset"
}

class Contact {
    var name: String
    var lastInTouch: String
    var favorite: Bool = false
    var recordID: CKRecord.ID
    
    var contactPhoto: UIImage? {
        get {
            guard let photoData = self.photoData else {return nil}
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoData: Data?
    
    var photoAsset: CKAsset? {
        get {
            guard photoData != nil else {return nil}
            
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(name: String, lastInTouch: String, favorite: Bool = false, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), contactPhoto: UIImage? = nil) {
        self.name = name
        self.lastInTouch = lastInTouch
        self.favorite = favorite
        self.recordID = recordID
        self.contactPhoto = contactPhoto
    }
}

//MARK: - Extensions

extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: ContactStrings.recordTypeKey, recordID: contact.recordID)
        
        self.setValuesForKeys([
            ContactStrings.nameKey : contact.name,
            ContactStrings.lastInTouchKey : contact.lastInTouch,
            ContactStrings.favoriteKey : contact.favorite,
        ])
        
        if contact.photoAsset != nil {
            setValue(contact.photoAsset, forKey: ContactStrings.photoAssetKey)
        }
    }
}

extension Contact {
    
    convenience init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord[ContactStrings.nameKey] as? String,
              let lastInTouch = ckRecord[ContactStrings.lastInTouchKey] as? String,
              let favorite = ckRecord[ContactStrings.favoriteKey] as? Bool else {return nil}
                
        var foundPhoto: UIImage?
        
        if let photoAsset = ckRecord[ContactStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not transform asset to data")
            }
        }

        self.init(name: name, lastInTouch: lastInTouch, favorite: favorite, recordID: ckRecord.recordID, contactPhoto: foundPhoto)
    }
}
