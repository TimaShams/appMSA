//
//  DetailsViewController.swift
//  MSA
//
//  Created by MacBook Pro on 16/10/20.
//  Copyright © 2020 FatemaShams. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    
    @IBOutlet weak var link: UIButton!
    @IBAction func openLink(_ sender: Any) {
        
        if let url = URL(string: self.thebookInfo!.selfLink+"") {
             UIApplication.shared.open(url, options: [:])
         }
        
    }
    
    var thebookInfo:theBook? = nil {
    didSet {
        DispatchQueue.main.async {
            self.author.text = self.thebookInfo?.authors[0]
            self.price.text = self.thebookInfo?.authors[0]

        }
       }
     }

    
    var book:[Book] = []
    var lang = "au"

    
    @IBOutlet weak var title_: UILabel!
    @IBOutlet weak var description_: UILabel!
    @IBOutlet weak var image_: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var pages: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title_.text = book[0].title
        description_.text = book[0].description
        date.text = book[0].publishedDate
        pages.text = String(book[0].pageCount!)
        image_.downloaded(from: book[0].imageLinks.thumbnail)
        v1.design()
        v2.design()
        v3.design()
        apiCall()
        print(book[0].id)
    }
    


    func apiCall(){
        
        let baseURL = "https://ipvefa0rg0.execute-api.us-east-1.amazonaws.com/dev/books/"+book[0].id+"?lang="+lang
        
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        
        request.setValue(
            "jFXzWHx7SkK6",
            forHTTPHeaderField: "api-key"
        )

        request.httpMethod = "GET"

        print(baseURL)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(theBook.self,
                                                               from: data)
                    
                    DispatchQueue.main.async {
                       self.thebookInfo = decodedData
                     }
                    
                    print("+++++++++++++++++++++++++++++++++")
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    //print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            } else {
                // Handle unexpected error
            }
        }
        
        
        task.resume()
        
        
        
    }
    
}

extension UIView{
    func design() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    
    
}

