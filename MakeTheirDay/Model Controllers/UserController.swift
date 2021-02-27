//
//  UserController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/26/21.
//
import CloudKit
import UIKit

class UserController {
    
    static let sharedInstance = UserController()
    var currentUser: User?
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func fetchAppleUserReference(completion: @escaping (Result<CKRecord.Reference?, CustomError>) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            
            if let recordID = recordID {
                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                
                completion(.success(reference))
            }
        }
    }
    
    func createUser(profilePhoto: UIImage, completion: @escaping (Result<User, CustomError>) -> Void) {
        
        self.fetchAppleUserReference { [self] (result) in
            switch result {
            case .success(let reference):
                
                guard let reference = reference else {return completion(.failure(.noData))}
                
                let userToSave = User(appleUserRef: reference, profilePhoto: profilePhoto)
                
                let newRecord = CKRecord(user: userToSave)
                
                self.privateDB.save(newRecord) { (record, error) in
                    
                    if let error = error {
                        return completion(.failure(.thrownError(error)))
                    }
                    
                    guard let record = record else {return completion(.failure(.noData))}
                    
                    guard let user = User(ckRecord: record) else {return completion(.failure(.unableToDecode))}
                    
                    return completion(.success(user))
                }
                
            case .failure(let error):
                print("There was an error saving New User \(String(describing: error.errorDescription))")
            }
        }
    }
    
    func updateUser() {
        
    }
    
    func fetchUser(predicate: NSPredicate, completion: @escaping (Result<User, CustomError>) -> Void) {
        
        let query = CKQuery(recordType: ContactStrings.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let records = records else {return completion(.failure(.unableToDecode))}
            
            guard let user = records.compactMap({ User(ckRecord: $0) }).first else {return completion(.failure(.unableToDecode))}
            self.currentUser = user
            completion(.success(user))
        }
    }
}

