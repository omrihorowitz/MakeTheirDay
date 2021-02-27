//
//  User.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit
import CloudKit

struct UserStrings {
    static let recordTypeKey = "User"
    static let appleUserRefKey = "appleUserRef"
    fileprivate static let photoAssetKey = "photoAsset"
}

class User {
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    
    var profilePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else {return nil}
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoData: Data?
    
    var photoAsset: CKAsset {
        get {
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
    
    init(recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference, profilePhoto: UIImage? = nil) {
        self.recordID = recordID
        self.appleUserRef = appleUserRef
        self.profilePhoto = profilePhoto
    }
} //end of class

//MARK: - Extensions
extension User {
    
    convenience init?(ckRecord: CKRecord) {
        guard let appleUserRef = ckRecord[UserStrings.appleUserRefKey] as? CKRecord.Reference else { return nil }
        
        var foundPhoto: UIImage?
        
        if let photoAsset = ckRecord[UserStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not tranform asset to data")
            }
        }
        
        self.init(recordID: ckRecord.recordID, appleUserRef: appleUserRef, profilePhoto: foundPhoto)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension CKRecord {
    
    convenience init(user: User) {
        
        self.init(recordType: UserStrings.recordTypeKey, recordID: user.recordID)
        
        setValuesForKeys([
            UserStrings.appleUserRefKey : user.appleUserRef,
            UserStrings.photoAssetKey : user.photoAsset
        ])
    }
}
