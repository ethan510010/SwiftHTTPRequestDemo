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
    
    let username = UserDefaults.standard.string(forKey: "username")
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            APIManager.shared.deleteArticle(username: username!, whichArticle: articles[indexPath.row].id, completion: {
                self.articles.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })

        }
    }
}

extension ArticleViewController:LikeButtonDidTappedDelegate{
    func likeButtonDidTapped(index: IndexPath) {
        
        articles[index.row].is_liked = !articles[index.row].is_liked
        if articles[index.row].is_liked == true{
            APIManager.shared.submitLikeForSpecifiedArticle(username: username!, whichArticle: articles[index.row].id, completion: {
                self.articles[index.row].likes[self.username!] = true
                DispatchQueue.main.async {
                    self.articleTableView.reloadData()
                }
            })
        }else if articles[index.row].is_liked == false{
            APIManager.shared.deleteLikeForSpecifiedArticle(username: username!, whichArticle: articles[index.row].id, completion: {
                self.articles[index.row].likes[self.username!] = false
                DispatchQueue.main.async {
                    self.articleTableView.reloadData()
                }
            })
        }
    }
    
    
}
