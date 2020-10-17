//
//  NetworkData.swift
//  MSA
//
//  Created by MacBook Pro on 18/10/20.
//  Copyright © 2020 FatemaShams. All rights reserved.
//

import Foundation


class Network {
    
    
    var bookList:myList? = nil
    
    func apiCall(language:String , keywords:String) -> myList? {
        
        let baseURL = "https://ipvefa0rg0.execute-api.us-east-1.amazonaws.com/dev/books?lang="+language+"&term="+keywords
        
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
                    
                  //  DispatchQueue.main.async {
                        self.bookList = decodedData
                  //   }
                    

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
  
        return self.bookList
    }

}
