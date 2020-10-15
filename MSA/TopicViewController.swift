//
//  TopicViewController.swift
//  MSA
//
//  Created by MacBook Pro on 15/10/20.
//  Copyright © 2020 FatemaShams. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
    
    let topics = ["Horror","Romance" , "Nooo" , "kkk" ]

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topicCell",
                                                      for: indexPath) as! TopicCollectionViewCell
        cell.topicLabel.text = topics[indexPath.row]
        
        return cell
    }
    
    @IBOutlet weak var topicsCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicsCV.delegate = self
        topicsCV.dataSource = self
        topicsCV.reloadData()
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
