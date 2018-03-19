//
//  ArticleViewController.swift
//  HttpRequestDemo
//
//  Created by EthanLin on 2018/3/16.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    let baseUrl = "https://us-central1-shavenking-me-1dfe2.cloudfunctions.net/posts/"
    
    //實體化APIManager
    let apiManager = APIManager()
    
    
    //接收存下來的資料
    let username = UserDefaults.standard.string(forKey: "username")
    
    //創建一個articles來接受網路下載下來的
    var articles = [Article]()
    
    
    @IBOutlet weak var articleTableView: UITableView!
    
    @IBAction func goEditArticleVC(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editArticle", sender: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
//        apiManager.fetchArticle(urlString: baseUrl, parameters: ["username":username!]) { (articles) in
//            if let articleArray = articles{
//              self.articles = articleArray
////              print(self.articles.count)
//              DispatchQueue.main.async {
//                    self.articleTableView.reloadData()
//                }
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apiManager.fetchArticle(urlString: baseUrl, parameters: ["username":username!]) { (articles) in
            if let articleArray = articles{
                self.articles = articleArray
                DispatchQueue.main.async {
                    self.articleTableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
//        var article: Article?
//        article?.likes.count
//        for like in article?.likes.enumerated() {
//            
//        }
    }
    
}

extension ArticleViewController:UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        //設定委派
        cell.index = indexPath
        cell.delegate = self
        //
        cell.updateCellUI(article: articles[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.articleTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //刪除某列的文章
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            apiManager.deleteArticle(username: username!, whichArticle: indexPath.row + 1)
            DispatchQueue.main.async {
                 self.articleTableView.reloadData()
            }
        }
    }
}

extension ArticleViewController:LikeButtonDidTappedDelegate{
    func likeButtonDidTapped(index: IndexPath) {
        
        articles[index.row].is_liked = !articles[index.row].is_liked
//        print("article\(index.row + 1) : \(articles[index.row].is_liked)")
        
        //決定現在使用者是要加上文章的喜歡還是刪除文章的喜歡
        if articles[index.row].is_liked == true{
            apiManager.submitLikeForSpecifiedArticle(username: username!, whichArticle: index.row + 1)
        }else if articles[index.row].is_liked == false{
            apiManager.deleteLikeForSpecifiedArticle(username: username!, whichArticle: index.row + 1)
        }
        DispatchQueue.main.async {
            self.articleTableView.reloadData()
        }
    }
    
    
}
