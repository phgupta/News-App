//
//  LoginViewController.swift
//  News App
//
//  Created by Pranav Gupta on 11/16/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // Global variables
    var userID: String = ""
    var notNewuser: Bool = false
    var USERS: [String] = [""]
    
    // Outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBAction func submitPressed(_ sender: Any) {
    
        let userID = name.text!
        // Validating user input
    
        if (USERS.contains(userID)) {
        
            switch String(userID.prefix(3)) {
            // Bias without message
            case "BOM":
                UserDefaults.standard.set(1, forKey: "VersionNum")
                UserDefaults.standard.set(userID, forKey: "UserID")
                performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
            
            // No bias condition
            case "NBX":
                UserDefaults.standard.set(2, forKey: "VersionNum")
                UserDefaults.standard.set(userID, forKey: "UserID")
                performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
            
            // Bias with message
            case "BWM":
                UserDefaults.standard.set(3, forKey: "VersionNum")
                UserDefaults.standard.set(userID, forKey: "UserID")
                performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
                
            default:
                // Display error message to UI here
                createAlert(title: "Error!", message: "Tag is not valid.")
            }
        } else {
            
            // Display error message to UI here
            createAlert(title: "Error!", message: "Tag is not valid.")
        }
    }

    @IBOutlet weak var backgroundimage: UIImageView!
    

    // Default functions
    override func viewDidLoad() {
        
        let ref = Database.database().reference() // Getting all users from database
        //print(ref.description)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                for child in snapshot.children {
                    let key = (child as AnyObject).key as String
                    self.USERS.append(key)
                }
            let userSaved = UserDefaults.standard.string(forKey: "UserID")
            if (userSaved != nil) {
                if (self.USERS.contains(userSaved!)) {
                    self.performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
                }
                else {
                    self.createAlert(title: "Message", message: "We're sorry to inform that your subscription was expired!")
                }
            }
        }
        })
        

        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: backgroundImage.frame.size.width, height: backgroundImage.frame.size.height))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        backgroundImage.addSubview(overlay)
        
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func createAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
