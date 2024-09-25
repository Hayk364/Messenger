//
//  DataMeneger.swift
//  Messenger
//
//  Created by АА on 16.09.24.
//

import Foundation
import UIKit
import CoreData

public final class DataMeneger: NSObject{
    public static let shared = DataMeneger()
    private override init() {}
    
    private lazy var appDelegate:AppDelegate = {
        DispatchQueue.main.sync {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }()
    
    private var context: NSManagedObjectContext{
        return appDelegate.persistentContainer.viewContext
    }
    public func createActvityView(complition: @escaping (UIActivityIndicatorView) -> (Void)){
        var activity = UIActivityIndicatorView()
        
        activity = UIActivityIndicatorView(style: .large)
        activity.color = .gray
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.isHidden = true
        complition(activity)
    }
    public func stopAnimating(_ activity:UIActivityIndicatorView,complition:@escaping (UIActivityIndicatorView) -> (Void)){
        complition(activity)
    }
    public func startAnimating(_ activity:UIActivityIndicatorView,complition:@escaping (UIActivityIndicatorView) -> (Void)){
        complition(activity)
    }
    public func addMessageId(complition:@escaping (Int64) -> Void){
        DispatchQueue.global(qos: .userInteractive).async{
            let fetchRequest = NSFetchRequest<Chats>(entityName: "Chats")
            do{
                let messages = try self.context.fetch(fetchRequest)
                let count = Int64(messages.count + 1)
                complition(count)
            }
            catch{
                let error = error as NSError
                print("Error -- \(error)")
            }
        }
    }
    public func getDataBase(complition:@escaping ([UsersRegisterData]?,[Chats]?) -> Void){
        DispatchQueue.global(qos: .userInteractive).async {
            let UserfetchRequest = NSFetchRequest<UsersRegisterData>(entityName: "UsersRegisterData")
            let ChatfetchRequest = NSFetchRequest<Chats>(entityName: "Chats")
                do{
                    let users = try self.context.fetch(UserfetchRequest)
                    let chats = try self.context.fetch(ChatfetchRequest)
                    complition(users, chats)
                }catch{
                    let error = error as NSError
                    print("Error -- \(error)")
                    complition(nil,nil)
                }
            }
    }
    public func getUserSendName(complition:@escaping ([String?]) -> Void){
        var array = [String?]()
        DispatchQueue.global(qos: .utility).async {
            let fetchRequest = NSFetchRequest<UsersRegisterData>(entityName: "UsersRegisterData")
            do{
                let users = try? self.context.fetch(fetchRequest)
                for item in users!{
                    array.append(item.username)
                }
                DispatchQueue.main.async {
                    complition(array)
                }
            }
        }
    }
    public func addMessageID(complition: @escaping (Int64) -> Void){
        DispatchQueue.global(qos: .utility).async {
            let fetchRequest = NSFetchRequest<Chats>(entityName: "Chats")
            do{
                let messages = try self.context.fetch(fetchRequest)
                let count = Int64(messages.count + 1)
                DispatchQueue.main.async {
                    complition(count)
                }
            }
            catch{
                let error = error as NSError
                print("Error -- \(error).")
            }
        }
    }
    public func addUserId(complition: @escaping (Int64) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchRequest = NSFetchRequest<UsersRegisterData>(entityName: "UsersRegisterData")
            do{
                let users = try self.context.fetch(fetchRequest)
                let count = Int64(users.count + 1)
                DispatchQueue.main.async {
                    complition(count)
                }
            }
            catch{
                let error = error as NSError
                print("Error -- \(error).")
            }
        }
    }
    public func removeDuplicates<T: Equatable>(from array: [T]) -> [T] {
        var result = [T]()
        for value in array {
            if !result.contains(value) {
                result.append(value)
            }
        }
        return result
    }
    public func getMyChats(_ username:String?,complition:@escaping ([String?],String?) -> (Void)){
        DispatchQueue.global(qos: .userInteractive).async {
            let fetchRequest = NSFetchRequest<Chats>(entityName: "Chats")
            fetchRequest.predicate = NSPredicate(format: "username = %@", username!)
            do{
                let chats = try self.context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    var myChats = [String?]()
                    for i in chats{
                        myChats.append(i.sendusername!)
                    }
                    complition(myChats,nil)
                }
            }
            catch{
                let error = error as NSError
                complition([nil],error as? String)
            }
        }
    }
    public func createUser(_ id:Int64,_ userName: String?,_ password:String?){
        DispatchQueue.global(qos: .userInteractive).async{
            guard let userName = userName, let password = password else { return }
                guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "UsersRegisterData", in: self.context) else { return }
                DispatchQueue.main.async{
                    let user = UsersRegisterData(entity: userEntityDescription, insertInto: self.context)
                    user.id = id
                    user.username = userName
                    user.password = password
                    do{
                        try self.context.save()
                        print("True Save")
                    }
                    catch{
                        let error = error as NSError
                        print("Error --- \(error)")
                    }
                }
            }
        }
    public func findUser(_ username:String?,_ password:String?,complition: @escaping (Bool,String?,UsersRegisterData?) -> Void){
        DispatchQueue.global(qos: .userInteractive).async{
            let fetchRequest = NSFetchRequest<UsersRegisterData>(entityName: "UsersRegisterData")
            fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username!,password!)
            do{
                let users = try self.context.fetch(fetchRequest) as [UsersRegisterData]
                DispatchQueue.main.async {
                    if let user = users.first{
                        complition(true,nil,user)
                    }
                    else{
                        complition(false,"User is not Undefind",nil)
                    }
                }
            }
            catch{
                let error = error as NSError
                complition(false, String(describing: error),nil)
            }
        }
    }
    public func addUserMessage(_ id:Int64,_ username:String?,_ sendusername:String?,_ usermessage:String?,complition:@escaping (Bool,String?) -> Void){
        DispatchQueue.global(qos: .userInteractive).async{
            guard let chatsEntityName = NSEntityDescription.entity(forEntityName: "Chats", in: self.context) else { return }
            DispatchQueue.main.async {
                guard let username = username,let sendusername = sendusername,let usermessage = usermessage else { return }
                let message = Chats(entity: chatsEntityName, insertInto: self.context)
                message.id = id
                message.message = usermessage
                message.username = username
                message.sendusername = sendusername
                do{
                    try self.context.save()
                    complition(true, nil)
                }catch{
                    let error = error as NSError
                    complition(true, String(describing: error))
                }
            }
        }
    }
    public func getUserMessage(_ username:String,_ sendusername:String,complition:@escaping ([Chats]) -> Void){
        DispatchQueue.global(qos: .utility).async{
            let fetchRequest = NSFetchRequest<Chats>(entityName: "Chats")
            fetchRequest.predicate = NSPredicate(format: "(username == %@ OR sendusername == %@) OR (username == %@ OR sendusername == %@)", username, sendusername, sendusername, username)
            do{
                let messages = try self.context.fetch(fetchRequest)
                complition(messages)
            }catch{
                let error = error as NSError
                print("Error fetching data: \(error)")
            }
        }
    }
}
