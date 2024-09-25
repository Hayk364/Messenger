//
//  MessageChatViewController.swift
//  Messenger
//
//  Created by АА on 17.09.24.
//

import UIKit

class MessageChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    let username = UserDefaults.standard.string(forKey: "username")
    let sendusername = UserDefaults.standard.string(forKey: "sendusername")
    
    var alertForError = UIAlertController()
    var messageTask = [String?]()
    var nameTask = [String?]()
    var messageTableView = UITableView()
    var sendButton = UIButton()
    var buttonHideKeyboard = UIButton()
    var messageTextField = UITextField()
    var timer: Timer?
    var messageTextFieldTopConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        self.title = sendusername
        
        createSendButton()
        createMessageTextField()
        createTabelView()
        createHideKeyboardButton()
        updateArrays()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
        }
        
    }
    func updateArrays(){
        self.messageTask = [String?]()
        self.nameTask = [String?]()
        DataMeneger.shared.getUserMessage(username ?? "", sendusername ?? "") { messages in
            for i in messages{
                if i.username == self.username && i.sendusername == self.sendusername{
                    self.messageTask.append(i.message!)
                    self.nameTask.append("Me")
                    print("This Message Send Me \(i.message!)")
                }else if i.username == self.sendusername && i.sendusername == self.username{
                    self.nameTask.append(i.username!)
                    self.messageTask.append(i.message!)
                    print("This Message Send \(i.username!) \(i.message!)")
                }
                
            }
        }
        DispatchQueue.main.async {
            self.messageTableView.reloadData()
        }
    }
    func createHideKeyboardButton(){
        self.buttonHideKeyboard.setTitle("↓", for: .normal)
        self.buttonHideKeyboard.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        self.buttonHideKeyboard.translatesAutoresizingMaskIntoConstraints = false
        self.buttonHideKeyboard.addTarget(self, action: #selector(HideKeyboard), for: .touchUpInside)
        self.buttonHideKeyboard.layer.cornerRadius = 10
        self.view.addSubview(self.buttonHideKeyboard)
            NSLayoutConstraint.activate([
                    self.buttonHideKeyboard.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 110),
                    self.buttonHideKeyboard.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor, constant: 390),
                    self.buttonHideKeyboard.widthAnchor.constraint(equalToConstant: 35),
                    self.buttonHideKeyboard.heightAnchor.constraint(equalToConstant: 35)
                ])
    }
    @objc func HideKeyboard(){
        self.view.endEditing(true)
    }
    //MARK: Create UpdateUI
    @objc func updateUI(){
        self.messageTableView.reloadData()
    }
    //MARK: Create Chat UI
    func createTabelView(){
        
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        self.messageTableView.backgroundColor = .clear
        self.messageTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.messageTableView)
        NSLayoutConstraint.activate([
            self.messageTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.messageTableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: -180),
            self.messageTableView.widthAnchor.constraint(equalToConstant: 380),
            self.messageTableView.heightAnchor.constraint(equalToConstant: 460)
        ])
        messageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(nameTask[indexPath.row]!):\(messageTask[indexPath.row]!)"
        return cell
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
        print(UserDefaults.standard.string(forKey: "lastOpenViewController")!)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(messageTask[indexPath.row]!)
    }
    //MARK: Create textField
    func createMessageTextField(){
        self.messageTextField.placeholder = "Message"
        self.messageTextField.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.8)
        self.messageTextField.translatesAutoresizingMaskIntoConstraints = false
        self.messageTextField.layer.cornerRadius = 10
        self.view.addSubview(self.messageTextField)
        NSLayoutConstraint.activate([
            self.messageTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: -30),
                self.messageTextField.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor, constant: 390),
                self.messageTextField.widthAnchor.constraint(equalToConstant: 320),
                self.messageTextField.heightAnchor.constraint(equalToConstant: 35)
            ])
    }
    //MARK: Create Send Button
    func createSendButton(){
        self.sendButton.setTitle("Send", for: .normal)
        self.sendButton.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.sendButton.addTarget(self, action: #selector(SendMessage), for: .touchUpInside)
        self.sendButton.layer.cornerRadius = 10
        self.view.addSubview(self.sendButton)
        NSLayoutConstraint.activate([
                self.sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 165),
                self.sendButton.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor, constant: 390),
                self.sendButton.widthAnchor.constraint(equalToConstant: 50),
                self.sendButton.heightAnchor.constraint(equalToConstant: 35)
            ])
    }
    
    @objc func SendMessage(){
        let text = self.messageTextField.text
        DataMeneger.shared.addMessageId { id in
            DataMeneger.shared.addUserMessage(id, self.username, self.sendusername,text) { isSend, error in
                print(isSend)
                DispatchQueue.main.async{
                    if isSend{
                        self.updateArrays()
                        self.messageTextField.text = ""
                    }else{
                        self.createAlertForError(error)
                    }
                }
               
            }
        }
    }
    func createAlertForError(_ error:String?){
        self.alertForError = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default)
        self.alertForError.addAction(action1)
        
        self.present(self.alertForError, animated: true)
    }
}
