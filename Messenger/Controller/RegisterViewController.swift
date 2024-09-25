//
//  RegisterViewController.swift
//  Messenger
//
//  Created by АА on 16.09.24.
//

import UIKit

class RegisterViewController: UIViewController {
    var textFieldName = UITextField()
    var textFieldPassword = UITextField()
    
    var alertError = UIAlertController()
    
    var registerButton = UIButton()
    var hidePasswordButton = UIButton()
    var goToRegisterButton = UIButton()
    
    var mainLabel = UILabel()
    
    var activityLoad = UIActivityIndicatorView()
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        DataMeneger.shared.createActvityView { activity in
            DispatchQueue.main.async {
                self.activityLoad = activity
                self.view.addSubview(self.activityLoad)
                NSLayoutConstraint.activate([
                    self.activityLoad.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    self.activityLoad.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                ])
            }
        }
        createTextFields()
        createHidePasswordButton()
        createRegisterButton()
        goToRegister()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
        }
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
    func createRegisterButton(){
        self.registerButton.setTitle("Register", for: .normal)
        self.registerButton.isEnabled = true
        self.registerButton.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.registerButton.layer.cornerRadius = 20
        self.registerButton.addTarget(self, action: #selector(Register), for: .touchUpInside)
        self.view.addSubview(self.registerButton)
        
        NSLayoutConstraint.activate([
            self.registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.registerButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 430),
            self.registerButton.widthAnchor.constraint(equalToConstant: 200),
            self.registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    func registerButtonIsEnabled() {
        DispatchQueue.main.async {
            let isNameNotEmpty = !(self.textFieldName.text?.isEmpty ?? true)
            let isPasswordNotEmpty = !(self.textFieldPassword.text?.isEmpty ?? true)
            
            if isNameNotEmpty && isPasswordNotEmpty {
                self.registerButton.isEnabled = true
                self.registerButton.backgroundColor = .blue
            } else {
                self.registerButton.isEnabled = false
                self.registerButton.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)

            }
        }
    }
    @objc func updateUI(){
        registerButtonIsEnabled()
    }
    @objc func Register(){
        let textName = self.textFieldName.text
        let textPassword = self.textFieldPassword.text
        let activity = self.activityLoad
        DataMeneger.shared.findUser(textName,textPassword) { isFind, error, user in
            print(isFind)
            DataMeneger.shared.startAnimating(activity) { _ in
                DispatchQueue.main.async {
                    activity.isHidden = false
                    activity.startAnimating()
                    sleep(UInt32(0.3))
                    if isFind{
                        DispatchQueue.main.async{
                            activity.isHidden = true
                            activity.stopAnimating()
                            self.createErrorAlert("Username has been used")
                        }
                    }
                    else{
                        DataMeneger.shared.addUserId { id in
                            DataMeneger.shared.createUser(id, textName, textPassword)
                            DispatchQueue.main.async{
                                activity.isHidden = true
                                activity.stopAnimating()
                                print("True Register")
                                UserDefaults.standard.set(textName, forKey: "username")
                                self.navigationController?.viewControllers = [HomeViewController()]
                            }
                        }
                    }
                }
            }
            
        }
    }
}
