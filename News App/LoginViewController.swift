//
//  LoginViewController.swift
//  News App
//
//  Created by Pranav Gupta on 11/16/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBAction func submitPressed(_ sender: Any) {
        //performSegue(withIdentifier: "toSourcesCollectionViewController", sender: Any?.self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        print ("LOGIN VC LOADED")
        // Do any additional setup after loading the view.
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "toArticleTableViewController") {
//
//            let collectionViewController = segue.destination as! SourcesCollectionViewController
//
//            collectionViewController.name = name.text!
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
