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
    var date: String = ""
    var unformattedDate: String = ""
    
    
    //Outlets
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var textbody: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var articleTitle: UILabel!

    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter()
        
        authorLabel.text = articles![articlePos].author
        articleTitle.text = articles![articlePos].title
        textbody.text = articles![articlePos].body
        textbody.sizeToFit()
        articleImage.downloadImage(from: (articles![articlePos].imageUrl!))
        dateDisplay.text = date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // There was nothing wrong with the if statements you wrote! So many lines of code just bothered me and I changed it lol
    // It does the same thing you did!
    func dateFormatter() {
        
        let months = ["01": "January", "02": "February","03": "March", "04": "April",
                    "05": "May", "06": "June", "07": "July", "08": "August",
                    "09": "September", "10": "October", "11": "November", "12": "December"]
        
        unformattedDate = getCurrentDate()
        var arr = unformattedDate.components(separatedBy: "-")
        
        let year = arr[0]
        let month = String(months[arr[1]]!)
        let day = arr[2]
        
        date = day + " " + month + " " + year
    }
    
    func getCurrentDate() -> String {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.timeZone = NSTimeZone(abbreviation: "PST")! as TimeZone
        return String(formatter.string(from: date as Date).prefix(10))
    }
}



