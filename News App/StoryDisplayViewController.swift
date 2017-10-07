//
//  StoryDisplayViewController.swift
//  News App
//
//  Created by Saksham Bhalla on 10/5/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

class StoryDisplayViewController: UIViewController {

    var activeRow = 0
    var articles: [ArticleObject]? = []
    var username = "mystring"
    @IBOutlet weak var textbody: UITextView!
    @IBOutlet weak var storybody: UILabel!
    @IBOutlet weak var storyimg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("story display active row: ", activeRow)
        textbody.text = articles![activeRow].body
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
