//
//  HomeViewController.swift
//  Messenger
//
//  Created by АА on 16.09.24.
//

import UIKit

class HomeViewController: UIViewController,UIApplicationDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let username = UserDefaults.standard.string(forKey: "username")
    
    var searchTextField = UITextField()
    
    var searchButton = UIButton()
    var logOutButton = UIButton()
    var goToMyChatsButton = UIButton()
    var alertForError = UIAlertController()

    var task = [String?]()
    var usersTabelView = UITableView()
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SceneDelegate()
        scene.viewController = self
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        createSearchTextField()
        createSearchButton()
        createLogOutButton()
        createGoToChatsButton()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
        }
    }
    @objc func updateUI(){
        self.usersTabelView.reloadData()
    }
    //MARK: Create Users Table View
    func createTabelView(){
        self.usersTabelView.delegate = self
        self.usersTabelView.dataSource = self
        self.usersTabelView.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        self.usersTabelView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.usersTabelView)
        NSLayoutConstraint.activate([
            self.usersTabelView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.usersTabelView.topAnchor.constraint(equalTo: self.searchButton.bottomAnchor, constant: 10),
            self.usersTabelView.widthAnchor.constraint(equalToConstant: 380),
            self.usersTabelView.heightAnchor.constraint(equalToConstant: 500)
        ])
        usersTabelView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTabelView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = task[indexPath.row]
        return cell
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
        print(UserDefaults.standard.string(forKey: "lastOpenViewController")!)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.setValue(task[indexPath.row]!, forKey: "sendusername")
        self.navigationController?.pushViewController(MessageChatViewController(), animated: true)
    }
    //MARK: Create Search TextField
    func createSearchTextField(){
        self.searchTextField.placeholder = "Search username..."
        self.searchTextField.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.8)
        self.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.searchTextField.textAlignment = .left
        self.searchTextField.layer.cornerRadius = 10
        self.view.addSubview(self.searchTextField)
        
        NSLayoutConstraint.activate([
            self.searchTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            self.searchTextField.widthAnchor.constraint(equalToConstant: 380),
            self.searchTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    //MARK: Create SearchButton
    func createSearchButton(){
        self.searchButton.setTitle("Search", for: .normal)
        self.searchButton.backgroundColor = .blue
        self.searchButton.addTarget(self, action: #selector(Search), for: .touchUpInside)
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.layer.cornerRadius = 10
        
        self.view.addSubview(self.searchButton)
        NSLayoutConstraint.activate([
                self.searchButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.searchButton.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 10),
                self.searchButton.widthAnchor.constraint(equalToConstant: 380),
                self.searchButton.heightAnchor.constraint(equalToConstant: 35)
            ])
    }
    @objc func Search(){
        self.view.endEditing(true)
        DataMeneger.shared.getUserSendName { users in
            let text = self.searchTextField.text
            self.task = [String?]()
            if text == "root"{
                for i in users{
                    self.task.append(i)
                }
            }
            else{
                guard let searchText = text?.lowercased() else { return }
                            for i in users {
                                guard let user = i?.lowercased() else { continue }
                                if user == searchText {
                                    let first = user.prefix(1).uppercased()
                                    let userDrop = user.dropFirst()
                                    let newUser = first + userDrop
                                    print(newUser)
                                    self.task.append(newUser)
                                    break
                                } else if user.hasPrefix(searchText) {
                                    let first = user.prefix(1).uppercased()
                                    let userDrop = user.dropFirst()
                                    
                                    let newUser = first + userDrop
                                    print(newUser)
                                    self.task.append(newUser)
                                }
                            }
            }
        }
        createTabelView()
    }
    //MARK: Create GoToChats Button
    func createGoToChatsButton(){
        self.goToMyChatsButton.setTitle("Chat", for: .normal)
        self.goToMyChatsButton.backgroundColor = .blue
        self.goToMyChatsButton.translatesAutoresizingMaskIntoConstraints = false
        self.goToMyChatsButton.addTarget(self, action: #selector(GoToChat), for: .touchUpInside)
        self.view.addSubview(self.goToMyChatsButton)
        NSLayoutConstraint.activate([
                self.goToMyChatsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.goToMyChatsButton.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor, constant: 670),
                self.goToMyChatsButton.widthAnchor.constraint(equalToConstant: 380),
                self.goToMyChatsButton.heightAnchor.constraint(equalToConstant: 35)
            ])
    }
    @objc func GoToChat(){
        self.navigationController?.pushViewController(ChatsViewController(), animated: true)
    }
    //MARK: Create LogOut Button
    func createLogOutButton(){
        self.logOutButton.setTitle("LogOut", for: .normal)
        self.logOutButton.backgroundColor = .blue
        self.logOutButton.translatesAutoresizingMaskIntoConstraints = false
        self.logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        self.view.addSubview(self.logOutButton)
        NSLayoutConstraint.activate([
                self.logOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.logOutButton.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor, constant: 620),
                self.logOutButton.widthAnchor.constraint(equalToConstant: 380),
                self.logOutButton.heightAnchor.constraint(equalToConstant: 35)
            ])
    }
    @objc func logOut(){
        self.navigationController?.viewControllers = [ViewController()]
    }
    func createAlertForError(_ error:String?){
        self.alertForError = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default)
        self.alertForError.addAction(action1)
        
        self.present(self.alertForError, animated: true)
    }
}
