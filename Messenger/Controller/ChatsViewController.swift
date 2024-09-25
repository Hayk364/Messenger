//
//  ChatsViewController.swift
//  Messenger
//
//  Created by АА on 17.09.24.
//

import UIKit

class ChatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let username = UserDefaults.standard.string(forKey: "username")
    
    var task = [String?]()
    var myChatsTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        updateMyChatsTask()
        createTableView()
        print(username!)
    }
    func createTableView() {
        myChatsTableView = UITableView()
        myChatsTableView.delegate = self
        myChatsTableView.dataSource = self
        myChatsTableView.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        myChatsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.myChatsTableView)
        NSLayoutConstraint.activate([
            self.myChatsTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.myChatsTableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.myChatsTableView.widthAnchor.constraint(equalToConstant: 350),
            self.myChatsTableView.heightAnchor.constraint(equalToConstant: 400)
        ])
        myChatsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = task[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MessageChatViewController(), animated: true)
        if let senduser = self.task[indexPath.row]{
            UserDefaults.standard.set(senduser, forKey: "sendusername")
            print("Chat With \(senduser) open")
        }

    }
    func updateMyChatsTask() {
        DataMeneger.shared.getMyChats(self.username) { chats,error in
            var tempTask = [String?]()
            if let error = error{
                print(error)
            }
            else{
                tempTask = DataMeneger.shared.removeDuplicates(from: chats)
                DispatchQueue.main.async {
                    self.task = tempTask
                    for i in self.task{
                        print(i!)
                    }
                    self.myChatsTableView.reloadData()
                }
            }
        }
    }
    
}
