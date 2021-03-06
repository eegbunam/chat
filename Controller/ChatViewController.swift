//
//  ChatViewController.swift
//  ChatApp Prototype
//
//  Created by Daramfon Akpan on 5/23/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var collectionName:String = ""
    var messages:[Message] = []
    var signInIndicator = false
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        rightBarButton()
        //navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "mcidentifier")
        loadData()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //add a listener to see when user is signed in or signed out
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil{
                self.signInIndicator = true
            }
            else{
                self.signInIndicator = false
                print(self.signInIndicator)
                
            }
        }
        
    }
    
    func rightBarButton(){
        
        let signOutButton = UIButton(type: .system)
        let inviteButton = UIButton(type: .system)
        inviteButton.setImage(UIImage(systemName: "plus"), for: .normal)
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.addTarget(self, action: #selector(self.signOutButtonPressed), for: .touchUpInside)
        inviteButton.addTarget(self, action: #selector(self.inviteButtonPressed), for: .touchUpInside)
        //assigns aspect fit to be the content mode of the cartbutton
        signOutButton.contentMode = .scaleAspectFit
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: signOutButton),UIBarButtonItem(customView: inviteButton)]
    }
    
    @objc func signOutButtonPressed(){
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    @objc func inviteButtonPressed(){
        
        //creating link Parameter
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/recipes"
        
        let recipeIDQueryItem = URLQueryItem(name: "recipeID", value: "rcp_apple_pie")
        components.queryItems = [recipeIDQueryItem]
        
        guard let linkParameter = components.url else{return}
        print("testing 1,2: \(linkParameter.absoluteString)")
        
        //Creating the big dynamic link
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://chatappprototype.page.link")else{
            print("Could not create FDL components")
            return
        }
        if let myBundleId = Bundle.main.bundleIdentifier{
        shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        //temporary use google photos
        shareLink.iOSParameters?.appStoreID = "962194608"
        
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Testing"
        
        guard let longURL = shareLink.url else{return}
        print("The long dynamic link is \(longURL.absoluteString)")
        
        shareLink.shorten { (url, warnings, error) in
            if let error = error{
                print("Oh no! Got an error!\(error)")
            }
            if let warnings = warnings{
                for warning in warnings{
                    print("FDL Warning:\(warning)")
                }
            }
            guard let url = url else{return}
            print("I have a url:\(url.absoluteString)")
            self.showShareSheet(url: url)
        }
        
        
        
        
    }
    func showShareSheet(url:URL){
        let promoText = "Join the group chat using the link above"
        let activityVC = UIActivityViewController(activityItems: [promoText,url], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    func loadData(){
        db.collection(collectionName).order(by: "dateField").addSnapshotListener{ (querySnapshot, err) in
            self.messages = []
            if let err = err {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                if let querySnapshot = querySnapshot?.documents{
                    for document in querySnapshot {
                        let data = document.data()
                        print("\(data)")
                        if let sender = data["messageSender"] as? String, let body = data["messageBody"] as? String{
                            let latestMessage = Message(sender: sender, body: body)
                            self.messages.append(latestMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at:indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        //checks if user is signed in, and then adds new collection.
        //adding data to firebase.
        if signInIndicator {
            if let messageTxt = self.messageTextField.text, let currentUserEmail = Auth.auth().currentUser?.email{
                
                db.collection(collectionName).addDocument(data: ["messageBody":messageTxt,"messageSender":currentUserEmail, "dateField":Date().timeIntervalSince1970]) { (error) in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added with ID: Group Messages")
                        self.messageTextField.text = ""
                    }
                }
                
            }
        }
        
        
    }
    
}
extension ChatViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mcidentifier", for: indexPath) as! MessageCell
        if let email = Auth.auth().currentUser?.email{
            if messages[indexPath.row].sender == email{
                cell.messageText.text = messages[indexPath.row].body
                cell.updateViews()
                cell.sentByMe()
                
            }
            else{
                cell.messageText.text = messages[indexPath.row].body
                cell.updateViews()
                cell.notSentByMe()
            }
        }
        return cell
        
    }
    
}
