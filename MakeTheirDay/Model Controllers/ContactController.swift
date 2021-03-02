//
//  ContactController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit
import CloudKit

class ContactController {
    
    //MARK: - Properties
    var contacts: [Contact] = []
    
    static let sharedInstance = ContactController()
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - Functions
    func saveContact(name: String, lastInTouch: String, favorite: Bool, contactPhoto: UIImage?, completion: @escaping (Result<Contact, CustomError>) -> Void) {
        
        let contactToSave = Contact(name: name, lastInTouch: lastInTouch, favorite: favorite, contactPhoto: contactPhoto)
        
        let newRecord = CKRecord(contact: contactToSave)
        
        privateDB.save(newRecord) { (record, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let record = record else {return completion(.failure(.noData))}
            
            guard let contact = Contact(ckRecord: record) else {return completion(.failure(.unableToDecode))}
            
            self.contacts.append(contact)
            self.contacts = self.contacts.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            return completion(.success(contact))
        }
    }
    
    func fetchContacts(completion: @escaping (Result<String, CustomError>) -> Void) {
        
        let predicate = NSPredicate(value: true)

        let query = CKQuery(recordType: ContactStrings.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let records = records else {return completion(.failure(.unableToDecode))}
            
            let contacts = records.compactMap({ Contact(ckRecord: $0) })
            
            
            self.contacts = contacts.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            
            completion(.success("Successfully fetched contacts"))
        }
    }
    
    func updateContact(contact: Contact, name: String, lastInTouch: String, favorite: Bool, contactPhoto: UIImage, completion: @escaping (Result<Contact, CustomError>) -> Void) {
        
        contact.name = name
        contact.lastInTouch = lastInTouch
        contact.favorite = favorite
        contact.contactPhoto = contactPhoto
        
        let record = CKRecord(contact: contact)
        
        let updateOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        updateOperation.savePolicy = .changedKeys
        updateOperation.modifyRecordsCompletionBlock = { records, _, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let record = records?.first else {return completion(.failure(.noData))}
            
            guard let contact = Contact(ckRecord: record) else {return completion(.failure(.unableToDecode))}
            
            completion(.success(contact))
        }
        privateDB.add(updateOperation)
    }
    
    func delete(contact: Contact, completion: @escaping (Result<Bool, CustomError>) -> Void) {
        
        let deleteOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [contact.recordID])
        
        deleteOperation.savePolicy = .changedKeys
        deleteOperation.modifyRecordsCompletionBlock = { records, _, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if records?.count == 0 {
                completion(.success(true))
            } else {
                return completion(.failure(.noData))
            }
        }
        privateDB.add(deleteOperation)
    }
    
    func favoriteContacts() -> [Contact] {
        contacts.filter {
            $0.favorite
        }
    }
    
}//End of class
