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
//    let apiManager = APIManager()
    
    
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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //GET Request
        APIManager.shared.fetchArticle(urlString: baseUrl, parameters: ["username":username!]) { (articles) in
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
            
            APIManager.shared.deleteArticle(username: username!, whichArticle: articles[indexPath.row].id, completion: {
                self.articles.remove(at: indexPath.row)
                //因為現在在APIManager(網路請求)中更新UI，所以要在main線程進行更新UI
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
//                    self.articleTableView.reloadData()
                }
            })

        }
    }
}

extension ArticleViewController:LikeButtonDidTappedDelegate{
    func likeButtonDidTapped(index: IndexPath) {
        
        //點擊改變狀態
        articles[index.row].is_liked = !articles[index.row].is_liked
        
        //決定現在使用者是要加上文章的喜歡還是刪除文章的喜歡
        if articles[index.row].is_liked == true{
            APIManager.shared.submitLikeForSpecifiedArticle(username: username!, whichArticle: articles[index.row].id, completion: {
                self.articles[index.row].likes[self.username!] = true
                DispatchQueue.main.async {
                    self.articleTableView.reloadData()
                }
            })
//            apiManager.submitLikeForSpecifiedArticle(username: username!, whichArticle: articles[index.row].id)
//            articles[index.row].likes.count += 1
        }else if articles[index.row].is_liked == false{
            APIManager.shared.deleteLikeForSpecifiedArticle(username: username!, whichArticle: articles[index.row].id, completion: {
                self.articles[index.row].likes[self.username!] = false
                DispatchQueue.main.async {
                    self.articleTableView.reloadData()
                }
            })
//            apiManager.deleteLikeForSpecifiedArticle(username: username!, whichArticle: articles[index.row].id)
        }

            //因為現在沒有在APIManager(網路請求)中更新UI，所以預設就是在主執行緒，不用寫Main線程
//            self.articleTableView.reloadData()
        
    }
    
    
}
