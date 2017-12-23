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
        // Check for validity of NewsTag and switch to appropriate version.
        
        let versionNum = name.text!
        switch versionNum {

        case "0001":
            print("Version 1: Current Version.")
            UserDefaults.standard.set(1, forKey: "VersionNum")
            UserDefaults.standard.set(versionNum, forKey: "UserID")
            performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
            
        case "0002":
            print("Version 2: Neutral Version.")
            UserDefaults.standard.set(2, forKey: "VersionNum")
            UserDefaults.standard.set(versionNum, forKey: "UserID")
            performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)

        case "0003":
            print("Version 3: 10-Day Version.")
            UserDefaults.standard.set(3, forKey: "VersionNum")
            UserDefaults.standard.set(versionNum, forKey: "UserID")
            performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)

        default:
            print("Error")
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
