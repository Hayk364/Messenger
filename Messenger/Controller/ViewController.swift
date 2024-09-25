//
//  ViewController.swift
//  Messenger
//
//  Created by АА on 16.09.24.
//

import UIKit

class ViewController: UIViewController,UIApplicationDelegate {
    var textFieldName = UITextField()
    var textFieldPassword = UITextField()
    
    var alertError = UIAlertController()
    
    var loginButton = UIButton()
    var hidePasswordButton = UIButton()
    var goToRegisterButton = UIButton()
    
    var mainLabel = UILabel()
    
    var activityLoad = UIActivityIndicatorView()
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
        DataMeneger.shared.createActvityView { activity in
            DispatchQueue.main.async {
                self.activityLoad = activity
                self.view.addSubview(activity)
                
                NSLayoutConstraint.activate([
                    self.activityLoad.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    self.activityLoad.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                ])
            }
        }
        
        createTextFields()
        createHidePasswordButton()
        createLoginButton()
        goToRegister()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
        print(UserDefaults.standard.string(forKey: "lastOpenViewController")!)
    }
    //MARK: Create Error Alert
    func createErrorAlert(_ error:String?){
        self.alertError = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        self.alertError.addAction(action)
        self.present(self.alertError, animated: true)
    }
    //MARK: Create TextFields
    func createTextFields(){
        //Create Activity View
//        self.activityLoad = UIActivityIndicatorView(style: .large)
//        self.activityLoad.color = .gray
//        self.activityLoad.translatesAutoresizingMaskIntoConstraints = false
//        self.activityLoad.isHidden = true
//        self.view.addSubview(self.activityLoad)
//        NSLayoutConstraint.activate([
//            self.activityLoad.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            self.activityLoad.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
//        ])
        
        
        //Create TextField For UserName
        self.textFieldName.placeholder = "Name"
        self.textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldName.layer.cornerRadius = 20
        self.textFieldName.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
        self.textFieldName.textAlignment = .center
        self.view.addSubview(self.textFieldName)
        
        NSLayoutConstraint.activate([
            self.textFieldName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 250),
            self.textFieldName.widthAnchor.constraint(equalToConstant: 200),
            self.textFieldName.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //Create TextField ForPassword
        self.textFieldPassword.placeholder = "Password"
        self.textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldPassword.layer.cornerRadius = 20
        self.textFieldPassword.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
        self.textFieldPassword.textAlignment = .center
        self.textFieldPassword.isSecureTextEntry = true
        self.view.addSubview(self.textFieldPassword)
        
        NSLayoutConstraint.activate([
            self.textFieldPassword.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldPassword.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 330),
            self.textFieldPassword.widthAnchor.constraint(equalToConstant: 200),
            self.textFieldPassword.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    //MARK: Create Buttons
    func createHidePasswordButton(){
        self.hidePasswordButton.setTitle("𓁹", for: .normal)
        self.hidePasswordButton.backgroundColor = .none;  self.view.addSubview(self.hidePasswordButton)
        self.hidePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.hidePasswordButton.addTarget(self, action: #selector(hidePassword), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.hidePasswordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 80),
            self.hidePasswordButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 335),
            self.hidePasswordButton.widthAnchor.constraint(equalToConstant: 40),
            self.hidePasswordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    @objc func hidePassword(){
        self.view.endEditing(true)
        if self.textFieldPassword.isSecureTextEntry{
            self.textFieldPassword.isSecureTextEntry = !self.textFieldPassword.isSecureTextEntry
            self.hidePasswordButton.setTitleColor(.blue, for: .normal)
        }
        else{
            self.textFieldPassword.isSecureTextEntry = !self.textFieldPassword.isSecureTextEntry
            self.hidePasswordButton.setTitleColor(.white, for: .normal)
        }
    }
    func goToRegister(){
        self.goToRegisterButton.setTitle("Register", for: .normal)
        self.goToRegisterButton.addTarget(self, action: #selector(GoToRegisterPage), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.goToRegisterButton)
    }
    @objc func GoToRegisterPage(){
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    //Create LoginButton
    func createLoginButton(){
        self.loginButton.setTitle("Login", for: .normal)
        self.loginButton.isEnabled = true
        self.loginButton.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.layer.cornerRadius = 20
        self.loginButton.addTarget(self, action: #selector(Login), for: .touchUpInside)
        loginButtonIsEnabled()
        self.view.addSubview(self.loginButton)
        
        NSLayoutConstraint.activate([
            self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loginButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 430),
            self.loginButton.widthAnchor.constraint(equalToConstant: 200),
            self.loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    func loginButtonIsEnabled() {
        DispatchQueue.main.async {
            let isNameNotEmpty = !(self.textFieldName.text?.isEmpty ?? true)
            let isPasswordNotEmpty = !(self.textFieldPassword.text?.isEmpty ?? true)
            
            if isNameNotEmpty && isPasswordNotEmpty {
                self.loginButton.isEnabled = true
                self.loginButton.backgroundColor = .blue
            } else {
                self.loginButton.isEnabled = false
                self.loginButton.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)

            }
        }
    }
    @objc func updateUI(){
        loginButtonIsEnabled()
    }
    @objc func Login(){
        let textName = self.textFieldName.text
        let textPassword = self.textFieldPassword.text
        let activity = self.activityLoad
        DataMeneger.shared.findUser(textName,textPassword) { isFind, error, user in
            print(isFind)
            DataMeneger.shared.startAnimating(activity) { _ in
                activity.isHidden = false
                activity.startAnimating()
                DispatchQueue.global().async{
                    sleep(UInt32(0.3))
                    if isFind{
                        DispatchQueue.main.async {
                            activity.stopAnimating()
                            activity.isHidden = true
                            UserDefaults.standard.setValue(user?.username, forKey: "username")
                            print("True", UserDefaults.standard.string(forKey: "username") as Any)
                            self.navigationController?.viewControllers = [HomeViewController()]
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.createErrorAlert(error)
                            activity.stopAnimating()
                            activity.isHidden = true
                        }
                    }
                }
                
            }
        }
    }
}

