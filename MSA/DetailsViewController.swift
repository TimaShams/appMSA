//
//  DetailsViewController.swift
//  MSA
//
//  Created by MacBook Pro on 16/10/20.
//  Copyright © 2020 FatemaShams. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    var book:[Book] = []
    
    @IBOutlet weak var title_: UILabel!
    @IBOutlet weak var description_: UILabel!
    @IBOutlet weak var image_: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var pages: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title_.text = book[0].title
        description_.text = book[0].description
        date.text = book[0].publishedDate
        author.text = book[0].id
        pages.text = String(book[0].pageCount!)
        image_.downloaded(from: book[0].imageLinks.thumbnail)
            

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
