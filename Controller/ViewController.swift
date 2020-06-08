//
//  ViewController.swift
//  ChatApp Prototype
//
//  Created by Daramfon Akpan on 5/22/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 15
        signUpButton.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
        signUpButton.layer.borderWidth = 2
        signUpButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if let email = emailTextfield.text, let password = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                }
                else{
                    self.performSegue(withIdentifier: "mainScreen", sender:self)
                }
                
            }
        }
        
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "SignUpVC", sender: self)
        
    }
    
    
    
}

