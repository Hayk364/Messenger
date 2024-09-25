//
//  Chats+CoreDataClass.swift
//  Messenger
//
//  Created by АА on 16.09.24.
//
//

import Foundation
import CoreData

@objc(Chats)
public class Chats: NSManagedObject {}
extension Chats{
    @NSManaged public var id:Int64
    @NSManaged public var sendusername:String?
    @NSManaged public var username:String?
    @NSManaged public var message:String?
}
extension Chats: Identifiable {}
