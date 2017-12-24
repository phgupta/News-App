//
//  LoginViewController.swift
//  News App
//
//  Created by Pranav Gupta on 11/16/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Global variables
    let NewsTagArray = ["0001", "0002", "0003"]
    
    
    // Outlets
    @IBOutlet weak var name: UITextField!
    @IBAction func submitPressed(_ sender: Any) {

        let versionNum = name.text!
        
        // Save version number and UserID to UserDefaults.
        switch versionNum {
        case "0001":
            UserDefaults.standard.set(1, forKey: "VersionNum")
            UserDefaults.standard.set(versionNum, forKey: "UserID")
            performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
            
        case "0002":
            UserDefaults.standard.set(2, forKey: "VersionNum")
            UserDefaults.standard.set(versionNum, forKey: "UserID")
            performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)

        case "0003":
            UserDefaults.standard.set(3, forKey: "VersionNum")
            UserDefaults.standard.set(versionNum, forKey: "UserID")
            performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)

        default:
            print("Error: Incorrect Tag.")
        }
    }
    
    
    // Default functions
    override func viewDidLoad() {
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
}
