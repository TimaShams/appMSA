//
//  ViewController.swift
//  MSA
//
//  Created by MacBook Pro on 30/9/20.
//  Copyright © 2020 FatemaShams. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emptyImage: UIImageView!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var searchText: UITextField!

    var language = "au"
    var keywords = "power"
    let connection = Network()
    
    var bookList:myList? = nil {
        didSet {
            
            DispatchQueue.main.async {
                self.loaded()
            }
        }
    }
    
    let lang = ["Englsih","Français","漢語"]
    
    @IBOutlet weak var picker: UIPickerView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collection.delegate = self
        self.collection.dataSource = self
        self.picker.delegate = self
        self.picker.dataSource = self
        self.collection.isHidden = true
        self.loading.isHidden = true
        picker.isHidden = true
        
    }
    
    
    func onload() {
        apiCall()
        collection.isHidden = true
        loading.isHidden = false
        loading.startAnimating()
        
    }
    
    func loaded() {
        loading.stopAnimating()
        loading.isHidden = true
        collection.isHidden = false
        collection.reloadData()
        picker.isHidden = false
        emptyImage.isHidden = true
    }
    // fetch 15 items for each batch
    

    
    @IBAction func search(_ sender: Any) {
        
        print(searchText.text)
        if(searchText.text != "" )
        {
            keywords =  (searchText.text?.replacingOccurrences(of: " ", with: "+"))!
        }
        else
        {
            keywords = "Modern+Software"
        }
        self.onload()

        
    }
    
    
    func apiCall(){
        
        let baseURL = "https://ipvefa0rg0.execute-api.us-east-1.amazonaws.com/dev/books?lang="+self.language+"&term="+keywords
        
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



extension ViewController: UIPickerViewDataSource , UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lang.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return lang[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if row == 0 {
            language = "au"
        }
        if row == 1 {
            language = "fr"
            
        }
        if row == 2 {
            language = "zh"
        }
        
        onload()
        
    }
}




extension ViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! BooksCollectionViewCell
        

        cell.bookTitle.text = bookList?.list[indexPath.row].title
        if bookList?.list[indexPath.row].imageLinks.smallThumbnail != nil{
            cell.bookCover.downloaded(from: (bookList?.list[indexPath.row].imageLinks.smallThumbnail)!)
            
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        newVC.book = [(bookList?.list[indexPath.row])!]
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

