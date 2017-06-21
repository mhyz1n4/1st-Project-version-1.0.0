//
//  UserInformationViewController.swift
//  firebaseDemo
//
//  Created by mhy on 2017/6/1.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit
import Firebase

class InformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "informations"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
        
        setupView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserInformation()
        
    }
    func loadUserInformation(){
        guard let ID = FIRAuth.auth()?.currentUser?.uid else {
            print("user not logged in")
            return
        }
        FIRDatabase.database().reference().child("User").child(ID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]{
                if let profileImageUrl = dictionary["profileImageUrl"] as? String, let url = URL(string: profileImageUrl){
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.profileImage.image = UIImage(data: data!)
                        }
                        
                        
                    }).resume()
                }
                self.userNameLabel.text = dictionary["name"] as? String
                
            }
        })
    }
    
    func uploadImage (image : UIImage){
        guard let uploadData = UIImageJPEGRepresentation(image, 0.1), let ID = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("User").child(ID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]{
                if dictionary["profileImageUrl"] as? String == ""{
                    let imageName = NSUUID().uuidString
                    let storageRef = FIRStorage.storage().reference().child("profileImages/\(imageName).jpg")
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        let userRef = FIRDatabase.database().reference().child("User").child(ID)
                        if let ImageUrl = metadata?.downloadURL()?.absoluteString{
                            userRef.updateChildValues(["profileImageUrl" : ImageUrl])
                        }
                        
                    })
                }else{
                    FIRDatabase.database().reference().child("User").child(ID).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String : AnyObject]{
                            let currentProfileImageUrl = dictionary["profileImageUrl"] as! String
                            
                            let storageRef = FIRStorage.storage().reference(forURL: currentProfileImageUrl)
                            storageRef.delete(completion: { (error) in
                                if error != nil{
                                    print(error!)
                                }else{
                                    print("delete \(currentProfileImageUrl) success")
                                }
                            })
                            let imageName = NSUUID().uuidString
                            let newStorageRef = FIRStorage.storage().reference().child("profileImages/\(imageName).png")
                            newStorageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                                let userRef = FIRDatabase.database().reference().child("User").child(ID)
                                if let ImageUrl = metadata?.downloadURL()?.absoluteString{
                                    userRef.updateChildValues(["profileImageUrl" : ImageUrl])
                                }
                            })

                        }
                    })
                    
                }
            }
        })
        
    }
    
    func handleBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    func handleChangeProfileImage(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func handleChangeUserName(){
        let alert = UIAlertController(title:"Enter new user name", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let nameText = alert.textFields?[0].text, let ID = FIRAuth.auth()?.currentUser?.uid{
                let userRef = FIRDatabase.database().reference().child("User").child(ID)
                userRef.updateChildValues(["name" : nameText])
                self.userNameLabel.text = nameText
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter User Name"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleChangeEmail(){
        if let ID = FIRAuth.auth()?.currentUser?.uid, let currentUser = FIRAuth.auth()?.currentUser{
            
            let alert1 = UIAlertController(title: "Re-reauthenticate User", message: "Please enter Email and Password to change login Email address", preferredStyle: .alert)
            
            alert1.addTextField(configurationHandler: { (textfield) in textfield.placeholder = "Eamil" })
            alert1.addTextField(configurationHandler: { (textfield) in
                textfield.placeholder = "password"
                textfield.isSecureTextEntry = true
            })
            
            let enterAction = UIAlertAction(title: "Enter", style: .default, handler: { (UIAlertAction) in
                if let email = alert1.textFields?[0].text, let password = alert1.textFields?[1].text{
                    let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
                    currentUser.reauthenticate(with: credential, completion: { (error) in
                        if let Errormessage = error?.localizedDescription {
                            self.showAlter(title: "Error", message: Errormessage)
                        }else{
                            self.changeAndUpdateEmail(ID: ID, currentUser: currentUser)
                        }
                    })
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in })
            
            alert1.addAction(enterAction)
            alert1.addAction(cancelAction)
            
            self.present(alert1, animated: true, completion: nil)
        }
    }
    
    func changeAndUpdateEmail(ID : String, currentUser : FIRUser){
        let alert2 = UIAlertController(title: "Authentication Success", message: "Please enter new Eamil address", preferredStyle: .alert)
        
        alert2.addTextField(configurationHandler: { (textfield) in
            textfield.placeholder = "Eamil"
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action) in
            if let newEmail = alert2.textFields?[0].text {
                currentUser.updateEmail(newEmail, completion: { (error) in
                    if let Errormessage = error?.localizedDescription {
                        self.showAlter(title: "Error", message: Errormessage)
                    }else{
                        let userRef = FIRDatabase.database().reference().child("User").child(ID)
                        userRef.updateChildValues(["email" : newEmail])
                        self.showAlter(title: "Success", message: "your eamil has been changed")
                    }
                })
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in })
        
        alert2.addAction(saveAction)
        alert2.addAction(cancelAction)

        self.present(alert2, animated: true, completion: nil)
    }
    
    func handleChangePassword(){
        if let ID = FIRAuth.auth()?.currentUser?.uid, let currentUser = FIRAuth.auth()?.currentUser{
            
            let alert1 = UIAlertController(title: "Re-reauthenticate User", message: "Please enter Email and Password to change Password: ", preferredStyle: .alert)
            
            alert1.addTextField(configurationHandler: { (textfield) in textfield.placeholder = "Eamil" })
            alert1.addTextField(configurationHandler: { (textfield) in
                textfield.placeholder = "password"
                textfield.isSecureTextEntry = true
            })
            
            let enterAction = UIAlertAction(title: "Enter", style: .default, handler: { (UIAlertAction) in
                if let email = alert1.textFields?[0].text, let password = alert1.textFields?[1].text{
                    let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
                    currentUser.reauthenticate(with: credential, completion: { (error) in
                        if let Errormessage = error?.localizedDescription {
                            self.showAlter(title: "Error", message: Errormessage)
                        }else{
                            self.changeAndUpdatePassword(ID: ID, currentUser: currentUser)
                        }
                    })
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in })
            
            alert1.addAction(enterAction)
            alert1.addAction(cancelAction)
            
            self.present(alert1, animated: true, completion: nil)
        }
    }
    
    func changeAndUpdatePassword (ID: String, currentUser: FIRUser) {
        let alert = UIAlertController(title: "Authentication Success", message: "Please enter Password twice to change current Password. Make sure both entry are identical", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Re-enter Password"
            textField.isSecureTextEntry = true
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let firstEntry = alert.textFields?[0].text, let secondEntry = alert.textFields?[1].text{
                if firstEntry == secondEntry {
                    currentUser.updatePassword(secondEntry, completion: { (error) in
                        if let Errormessage = error?.localizedDescription {
                            self.showAlter(title: "Error", message: Errormessage)
                        }else{
                            self.showAlter(title: "Success", message: "your password has been changed")
                        }
                    })
                }else{
                    let newAlert = UIAlertController(title: "Error", message: "your first and second entry are not the same", preferredStyle: .alert)
                    let OkAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                        self.present(alert, animated: true, completion: nil)
                    }
                    newAlert.addAction(OkAction)
                    self.present(newAlert, animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleLogout(){
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            self.showAlter(title: "Error", message: logoutError.localizedDescription)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = originalImage
        }else{
            print("something went wrong")
        }
        
        if let finalImage = selectedImage{
            self.profileImage.image = finalImage
            uploadImage(image: finalImage)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(profileImage)
        view.addSubview(changePasswordButton)
        view.addSubview(changeProfileImageButton)
        view.addSubview(changeUserNameButton)
        view.addSubview(changeEmailButton)
        view.addSubview(logOutButton)
        view.addSubview(userNameLabel)
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        userNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        changeProfileImageButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 60).isActive = true
        changeProfileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeProfileImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changeProfileImageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        changeUserNameButton.topAnchor.constraint(equalTo: changeProfileImageButton.bottomAnchor, constant: 15).isActive = true
        changeUserNameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeUserNameButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changeUserNameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        changeEmailButton.topAnchor.constraint(equalTo: changeUserNameButton.bottomAnchor, constant: 15).isActive = true
        changeEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeEmailButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changeEmailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        changePasswordButton.topAnchor.constraint(equalTo: changeEmailButton.bottomAnchor, constant: 15).isActive = true
        changePasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changePasswordButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changePasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        logOutButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 15).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.contentMode = .center
        label.text = "user name"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changePasswordButton : UIButton = {
        let button = UIButton()
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) , for: .normal)
        button.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        return button
    }()
    
    let changeProfileImageButton : UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Image", for: .normal)
        button.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) , for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfileImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        return button
    }()
    
    let changeUserNameButton : UIButton = {
        let button = UIButton()
        button.setTitle("Change User Name", for: .normal)
        button.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) , for: .normal)
        button.addTarget(self, action: #selector(handleChangeUserName), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        return button
    }()
    
    let changeEmailButton : UIButton = {
        let button = UIButton()
        button.setTitle("Change Email Address", for: .normal)
        button.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) , for: .normal)
        button.addTarget(self, action: #selector(handleChangeEmail), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        return button
    }()
    
    let logOutButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) , for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        return button
    }()
    
    let profileImage : UIImageView = {
        let image = UIImageView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChangeProfileImage))
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addGestureRecognizer(tapGesture)
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 40
        image.layer.masksToBounds = true
        image.backgroundColor = .blue
        return image
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlter(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(OkAction)
        self.present(alert, animated: true, completion: nil)
    }
}
