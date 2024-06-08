//
//  ArticalCell.swift
//  NewsApp
//
//  Created by Shaimaa Mohammed on 08/06/2024.
//

import UIKit
import NewsCore
import SDWebImage

class ArticalCell: UITableViewCell {
    //Mark:-outlet
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articalContent: UILabel!
    @IBOutlet weak var articletitle: UILabel!
    var action: (() -> ())?
    
    
    //Mark:-functions
    func setDataToArticalCell(ArticalModel:Article){
        articalContent.text = ArticalModel.content
        articletitle.text = ArticalModel.title

        guard let imgURL = ArticalModel.urlToImage else {
            return
        }
        articleImage.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "placeholder.png"))
    }
    
    
    @IBAction func readMore(_ sender: Any) {
        action?()
    }
    
    @IBAction func IsFavbtnDidTapped(_ sender: Any) {
        print("should implment realm here")
        
    }
   
}
