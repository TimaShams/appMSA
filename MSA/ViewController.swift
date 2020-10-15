//
//  ViewController.swift
//  MSA
//
//  Created by MacBook Pro on 30/9/20.
//  Copyright © 2020 FatemaShams. All rights reserved.
//  https://medium.com/flawless-app-stories/json-parsing-with-codable-in-swift-4bc516d99d8c

import UIKit


struct myList: Decodable {
    let list: [Book]
}

struct Book: Decodable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String
    let title: String
    let publishedDate: String
    let description: String?
    let pageCount: Int?
    let imageLinks: imageLinksDecode
}

struct imageLinksDecode: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}


class ViewController: UIViewController {
    

    @IBOutlet weak var allBooksTable: UITableView!
    
    var bookList:myList? = nil {
    didSet {
        
        DispatchQueue.main.async {
            self.allBooksTable.reloadData()
        }
       }
    }

    let baseURL = "https://ipvefa0rg0.execute-api.us-east-1.amazonaws.com/dev/books?lang=fr&term=the+power+of"
    
    // fetch 15 items for each batch

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allBooksTable.dataSource = self
        self.allBooksTable.delegate = self

        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        
        request.setValue(
            "jFXzWHx7SkK6",
            forHTTPHeaderField: "api-key"
        )

        request.httpMethod = "GET"

        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(myList.self,
                                                               from: data)
                    
                    DispatchQueue.main.async {
                       self.bookList = decodedData
                     }
                    

                    print("===================================")
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


extension ViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! bookTableViewCell
                cell.bookName.text = bookList?.list[indexPath.row].title
        if bookList?.list[indexPath.row].imageLinks.smallThumbnail != nil{
        cell.img.downloaded(from: (bookList?.list[indexPath.row].imageLinks.smallThumbnail)!)
            
        }

                return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        newVC.book = (bookList?.list[indexPath.row])!
        self.show(newVC, sender: self)

    }
    
    

    
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
