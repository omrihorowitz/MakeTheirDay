//
//  Message.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import AVKit
import UIKit
import CloudKit

struct MessageStrings {
    static let recordTypeKey = "Message"
    fileprivate static let contactKey = "contact"
    fileprivate static let subjectKey = "subject"
    fileprivate static let bodyKey = "body"
    fileprivate static let avAssetKey = "avAsset"
    static let appleUserRefKey = "appleUserRef"
}

class Message {
    var contact: Contact
    var subject: String
    var body: String
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    
    var messageType: AVAsset? {
        get {
            guard let avData = self.avData else {return nil}
            return avData.getAVAsset()
        } set {
            guard let session = AVAssetExportSession(asset: newValue!, presetName: AVAssetExportPresetHighestQuality),
                  let url = session.outputURL else {return}
            avData = try? Data(contentsOf: url)
        }
    }
    
    var avData: Data?
    
    var avAsset: CKAsset {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
            
            do {
                try avData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }

    init(contact: Contact, subject: String = "", body: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference, messageType: AVAsset? = nil) {
        self.contact = contact
        self.subject = subject
        self.body = body
        self.recordID = recordID
        self.appleUserRef = appleUserRef
        self.messageType = messageType
    }
} //end of class

//MARK: - Extensions

extension Data {
      func getAVAsset() -> AVAsset? {
          let directory = NSTemporaryDirectory()
          let fileName = "\(NSUUID().uuidString).mp4"
        guard let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName]) else {return nil}
          try? self.write(to: fullURL)
        let asset = AVAsset(url: fullURL)
          return asset
      }
}

extension Message {

    convenience init?(ckRecord: CKRecord) {
        guard let contact = ckRecord[MessageStrings.contactKey] as? Contact,
              let subject = ckRecord[MessageStrings.subjectKey] as? String,
              let body = ckRecord[MessageStrings.bodyKey] as? String,
              let appleUserRef = ckRecord[MessageStrings.appleUserRefKey] as? CKRecord.Reference else { return nil }

        var foundData: Data?

        if let avAsset = ckRecord[MessageStrings.avAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: avAsset.fileURL!)
                foundData = data
            } catch {
                print("Could not tranform asset to data")
            }
        }

        self.init(contact: contact, subject: subject, body: body, recordID: ckRecord.recordID, appleUserRef: appleUserRef, messageType: foundData?.getAVAsset())
    }
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension CKRecord {

    convenience init(message: Message) {

        self.init(recordType: MessageStrings.recordTypeKey, recordID: message.recordID)

        setValuesForKeys([
            MessageStrings.contactKey : message.contact,
            MessageStrings.subjectKey : message.subject,
            MessageStrings.bodyKey : message.body,
            MessageStrings.appleUserRefKey : message.appleUserRef,
            MessageStrings.avAssetKey : message.avAsset
        ])
    }
}
