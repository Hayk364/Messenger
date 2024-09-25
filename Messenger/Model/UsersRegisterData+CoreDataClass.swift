//
//  UsersRegisterData+CoreDataClass.swift
//  Messenger
//
//  Created by АА on 16.09.24.
//
//

import Foundation
import CoreData

@objc(UsersRegisterData)
public class UsersRegisterData: NSManagedObject {

}
extension UsersRegisterData {
    @NSManaged public var id: Int64
    @NSManaged public var username: String?
    @NSManaged public var password: String?

}

extension UsersRegisterData : Identifiable {}
