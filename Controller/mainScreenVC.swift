//
//  mainScreenVC.swift
//  ChatApp Prototype
//
//  Created by Daramfon Akpan on 6/7/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import SCLAlertView

class mainScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarButton()

        // Do any additional setup after loading the view.
    }
    func rightBarButton(){
        
        let createGroupBtn = UIButton(type: .system)
        let joinGroupBtn = UIButton(type: .system)
        createGroupBtn.setTitle("Create/Join Group", for: .normal)
        createGroupBtn.addTarget(self, action: #selector(self.messageButtonPressed), for: .touchUpInside)
        joinGroupBtn.setTitle("Join Group", for: .normal)
        joinGroupBtn.addTarget(self, action: #selector(self.joinGroupButtonPressed), for: .touchUpInside)
        //assigns aspect fit to be the content mode of the cartbutton
        createGroupBtn.contentMode = .scaleAspectFit
        joinGroupBtn.contentMode = .scaleAspectFit

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: createGroupBtn)]
    }
    @objc func messageButtonPressed(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: false,contentViewBorderColor: #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
          )
        let alert = SCLAlertView(appearance: appearance)

        let txt = alert.addTextField("Enter your group name")
        txt.layer.borderWidth = 0
        txt.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        alert.addButton("Done", backgroundColor: #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1), textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), showTimeout: nil) {
            if let txt = txt.text{
                if txt != ""{
            self.performSegue(withIdentifier: "chatScreen", sender: txt)
                }else{
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
        alert.showEdit("Group Chat", subTitle: "Enter Group Name")
        //performSegue(withIdentifier: "chatScreen", sender: self)
        
        
    }
    @objc func joinGroupButtonPressed(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: false,contentViewBorderColor: #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
          )
        let alert = SCLAlertView(appearance: appearance)

        let txt = alert.addTextField("Enter your group name")
        txt.layer.borderWidth = 0
        txt.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        alert.addButton("Done", backgroundColor: #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1), textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), showTimeout: nil) {
            if let txt = txt.text{
                if txt != ""{
            self.performSegue(withIdentifier: "chatScreen", sender: txt)
                }else{
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
        alert.showEdit("Group Chat", subTitle: "Enter Group Name")
        //performSegue(withIdentifier: "chatScreen", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //type casting & unwrapping itemsVC to a variable called itemsVC.
                if let chatVC = segue.destination as? ChatViewController{
        //checks if category is not equals to nil.
                    assert(sender as? String != nil)
        //calls the initItems function in ItemsVC class.
                    chatVC.collectionName = sender as! String
    }
    }
}
