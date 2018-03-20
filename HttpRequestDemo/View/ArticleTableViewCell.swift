//
//  ArticleTableViewCell.swift
//  HttpRequestDemo
//
//  Created by EthanLin on 2018/3/16.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

protocol LikeButtonDidTappedDelegate {
    func likeButtonDidTapped(index:IndexPath)
}

class ArticleTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var articleTopic: UILabel!
    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var delegate:LikeButtonDidTappedDelegate?
    var index:IndexPath?
    
    @IBAction func like(_ sender: UIButton) {
        if let index = index{
           delegate?.likeButtonDidTapped(index: index)
        }
    }
    
    @IBOutlet weak var whoLike: UILabel!
    
    
    func updateCellUI(article:Article){
        self.articleTopic.text = article.topic
        self.articleContent.text = article.content
        self.authorLabel.text = article.author

        var trueCount = 0
        for (key,value) in article.likes{
            if value == true{
               trueCount += 1
            }
        }
        self.whoLike.text = "\(trueCount)"
        
        if article.is_liked == true{
            likeButton.backgroundColor = .blue
            likeButton.tintColor = .white
        }else{
            likeButton.backgroundColor = .white
            likeButton.tintColor = .blue
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.articleTopic.backgroundColor = .purple
        self.articleTopic.textColor = .white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
