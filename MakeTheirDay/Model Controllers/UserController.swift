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
    
    func updateUser(user: User, completion: @escaping (Result<String, CustomError>) -> Void) {
        let record = CKRecord(user: user)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, recordIds, error in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.ckError(error)))
            }
            guard let record = records?.first else { return completion(.failure(.unableToDecode))}
            completion(.success("Successfully updated \(record.recordID.recordName) in Cloudkit."))
        }
        privateDB.add(operation)
    }
    
    func fetchUser(completion: @escaping (Result<User?, CustomError>) -> Void) {
        
        fetchAppleUserReference { (result) in
            switch result {
            case .success(let reference):
                guard let reference = reference else {return completion(.failure(.noData))}
                
                let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.appleUserRefKey, reference])
                
                let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
                
                self.privateDB.perform(query, inZoneWith: nil) { (records, error) in
                    
                    if let error = error {
                        return completion(.failure(.ckError(error)))
                    }
                    
                    guard let record = records?.first else {return completion (.failure(.noData))}
                    
                    guard let foundUser = User(ckRecord: record) else {return completion(.failure(.noData))}
                    
                    print("Fetched user: \(record.recordID.recordName)")
                    completion(.success(foundUser))
                }
                
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
}

