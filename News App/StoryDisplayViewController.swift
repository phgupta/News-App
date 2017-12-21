//
//  StoryDisplayViewController.swift
//  News App
//
//  Created by Saksham Bhalla on 10/5/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

class StoryDisplayViewController: UIViewController {
    
    // Variables
    var articles: [ArticleObject]? = []
    var articlePos: Int = -1
    var username = "mystring"
    var date: String = ""
    var unformattedDate: String = ""
    
    
    //Outlets
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var textbody: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    
    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter()
        authorLabel.text = articles![articlePos].author
        articleTitle.text = articles![articlePos].title
        textbody.text = articles![articlePos].body
        articleImage.downloadImage(from: (articles![articlePos].imageUrl!))
        dateDisplay.text = date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateFormatter() {
        
        let months = ["01": "January", "02": "February","03": "March", "04": "April",
                    "05": "May", "06": "June", "07": "July", "08": "August",
                    "09": "September", "10": "October", "11": "November", "12": "December"]
        
        unformattedDate = articles![articlePos].published_at!
        var arr = unformattedDate.components(separatedBy: "-")
        var arr2 = arr[2].components(separatedBy: "T")
        
        let year = arr[0]
        let month = String(months[arr[1]]!)
        let day = arr2[0]
        
        date = day + " " + month + " " + year
        
//        if (month == "01") {
//            month = "January"
//        }
//
//        else if (month == "02") {
//            month = "February"
//        }
//
//        else if (month == "03") {
//            month = "March"
//        }
//
//        else if (month == "04") {
//            month = "April"
//        }
//
//        else if (month == "05") {
//            month = "May"
//        }
//
//        else if (month == "06") {
//            month = "June"
//        }
//
//        else if (month == "07") {
//            month = "July"
//        }
//
//        else if (month == "08") {
//            month = "August"
//        }
//
//        else if (month == "09") {
//            month = "September"
//        }
//
//        else if (month == "10") {
//            month = "October"
//        }
//
//        else if (month == "11") {
//            month = "November"
//        }
//
//        else if (month == "12") {
//            month = "December"
//        }
//        date = day + " " + month + " " + year
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



