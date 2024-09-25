//
//  Chats+CoreDataProperties.swift
//  Messenger
//
//  Created by АА on 16.09.24.
//
//

import Foundation
import CoreData


extension Chats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chats> {
        return NSFetchRequest<Chats>(entityName: "Chats")
    }


}


