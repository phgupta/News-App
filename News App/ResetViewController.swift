//
//  ResetViewController.swift
//  News App
//
//  Created by Pranav Gupta on 11/29/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        performSegue(withIdentifier: "toSourceViewController", sender: nil)
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        biaser.setBiasingScore(score: 50)
        performSegue(withIdentifier: "toSourceViewController", sender: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
