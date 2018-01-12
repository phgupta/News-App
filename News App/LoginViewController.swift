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
    let versions = ["NBC", "BOM", "BWM"]
    
    
    // Outlets
    @IBOutlet weak var name: UITextField!
    @IBAction func submitPressed(_ sender: Any) {

        let versionNum = name.text!
        
        // Validating user input
        if (versionNum.count != 6) {
            // Display error message to UI here
            print("Error: Incorrect input")
        } else {
            if (versions.contains(String(versionNum.prefix(3))) && Int(versionNum.suffix(3))! < 201) {
                
                switch String(versionNum.prefix(3)) {
                // Bias without message
                case "BOM":
                    UserDefaults.standard.set(1, forKey: "VersionNum")
                    UserDefaults.standard.set(versionNum, forKey: "UserID")
                    performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
                
                // No bias condition
                case "NBC":
                    UserDefaults.standard.set(2, forKey: "VersionNum")
                    UserDefaults.standard.set(versionNum, forKey: "UserID")
                    performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
                
                // Bias with message
                case "BWM":
                    UserDefaults.standard.set(3, forKey: "VersionNum")
                    UserDefaults.standard.set(versionNum, forKey: "UserID")
                    performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
                    
                default:
                    // Display error message to UI here
                    print("Error: Incorrect Tag.")
                }
            } else {
                
                // Display error message to UI here
                print("Error: Incorrect input")
            }
        }
        
        /*
        // Only 0001, 0002 and 0003 which denote version1,2,3 for now are valid inputs.
        // We need to change this to the valid usertags provided to us by Saif.
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
        */
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
