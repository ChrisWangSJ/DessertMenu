//
//  CollectionCell.swift
//  FetchMenu
//
//  Created by Chenyu Yan on 6/4/23.
//

import Foundation
import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var dessertImageView: UIImageView!
    @IBOutlet weak var dessertName: UILabel!
    @IBOutlet weak var dessertID: UILabel!
    
    var urlString: String! {
        didSet {
            dessertImageView.loadFrom(urlString)
        }
    }
    
    var nameStr: String! {
        didSet{
            dessertName.text = nameStr
        }
    }
    
    var idStr: String! {
        didSet{
            dessertID.text = idStr
        }
    }
    
}
