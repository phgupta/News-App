//
//  StoryDisplayViewController.swift
//  News App
//
//  Created by Saksham Bhalla on 10/5/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

class StoryDisplayViewController: UIViewController {
    
    // Global Variables
    var activeRow = 0
    var articles: [ArticleObject]? = []
    var username = "mystring"
    
    //Outlets
    
    @IBAction func backbuttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "backButtonArticleVC", sender: nil)
    }
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var textbody: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorLabel.text = articles![activeRow].author
        articleTitle.text = articles![activeRow].title
        textbody.text = articles![activeRow].body
        articleImage.downloadImage(from: (articles![activeRow].imageUrl!))
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "backButtonArticleVC") {
            
            let articleDisplayViewController = segue.destination as! ArticleTableViewController
        }
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



