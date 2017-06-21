//
//  LoginController.swift
//  firebaseDemo
//
//  Created by mhy on 17/5/15.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:34/255, green: 163/255,blue: 64/255, alpha: 1)
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setInputContainerView()
        setLoginButton()
        setProfileImageView()
        setSegmentedControl()
    }
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal )
        
        inputContainerHeightConstraint?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        
        nameTextFieldHeightConstraint?.isActive = false
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightConstraint?.isActive = true
        
        emailTextFieldHeightConstraint?.isActive = false
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightConstraint?.isActive = true
        
        PWTextFieldHeightConstraint?.isActive = false
        PWTextFieldHeightConstraint = PWTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        PWTextFieldHeightConstraint?.isActive = true
    }
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:80/255, green: 101/255,blue: 161/255, alpha: 1)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white ,for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        return button
        
    }()
    
    func handleRegisterLogin(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        guard let email = emailTextField.text, let password = PWTextField.text
            else{
                print("Form is not vaild")
                return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user,error) in
            
            if error != nil {
                print(error!)
                return
            }
            print("login success")
            self.dismiss(animated: true, completion: nil)
        
        })
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = PWTextField.text, let name = nameTextField.text
            else {
                print("Form is not vaild")
                return
        }
        let profileImage = ""
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            //let storageRef = FIRStorage.storage().reference()
            
            
            let ref = FIRDatabase.database().reference(fromURL: "https://fir-demo-480e3.firebaseio.com/")
            let userRef = ref.child("User").child(uid)
            let values = ["name" : name, "email": email, "profileImageUrl": profileImage]
            userRef.updateChildValues(values, withCompletionBlock: {(err, ref) in
                
                if err != nil {
                    print(err!)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
                //print("Saved user successfully into Firebase DB")
                
            })
            

            })
    }
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeperaterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:220/255, green: 220/255,blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeperaterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:220/255, green: 220/255,blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let PWTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    
    
    let profileImageView: UIView = {
        let view = UIImageView()
        view.image = UIImage(named: "Icon-60")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    func setProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
    }
    
    func setSegmentedControl(){
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    var inputContainerHeightConstraint: NSLayoutConstraint?
    var nameTextFieldHeightConstraint: NSLayoutConstraint?
    var emailTextFieldHeightConstraint: NSLayoutConstraint?
    var PWTextFieldHeightConstraint: NSLayoutConstraint?
    
    func setInputContainerView(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerHeightConstraint = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerHeightConstraint?.isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeperaterView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeperaterView)
        inputContainerView.addSubview(PWTextField)
        
        
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightConstraint?.isActive = true
        
        nameSeperaterView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperaterView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperaterView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightConstraint?.isActive = true
        
        emailSeperaterView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperaterView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperaterView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        PWTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        PWTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        PWTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        PWTextFieldHeightConstraint = PWTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        PWTextFieldHeightConstraint?.isActive = true
    }
    
    func setLoginButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    
}
