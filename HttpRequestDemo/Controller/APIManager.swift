//
//  APIManager.swift
//  HttpRequestDemo
//
//  Created by EthanLin on 2018/3/19.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import Foundation

class APIManager{
    
    static let shared = APIManager()
    //GET Request
    func fetchArticle(urlString:String,parameters:[String:String],completion:@escaping([Article]?)->Void){
        let url = URL(string: urlString)
        if let url = url{
           var request = URLRequest(url: url)
            for (key,value) in parameters{
                request.addValue(value, forHTTPHeaderField: key)
            }
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error!.localizedDescription)
                }else{
                    if let data = data{
                        do{
                            let jsonDecoder = JSONDecoder()
                            let articles = try jsonDecoder.decode([Article].self, from: data)
                            completion(articles)
                        }catch{
                            dump(error)
                            print("parse Json error")
                            completion(nil)
                            return
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    //POST Request
    func submitArticle(urlString:String,username:String,postTopic:String,postContent:String,completion:@escaping(Article?)->Void){
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(username, forHTTPHeaderField: "username")
        let postArticle = POSTArticle(topic: postTopic, content: postContent)
        do {
            let jsonEncoder = JSONEncoder()
            let postData = try jsonEncoder.encode(postArticle)
            request.httpBody = postData
        } catch  {
            print("Encoder error")
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                if let data = data{
                    do{
                        let jsonDecoder = JSONDecoder()
                        let postArticle = try jsonDecoder.decode(Article.self, from: data)
                        completion(postArticle)
                    }catch{
                        completion(nil)
                        print(error.localizedDescription)
                        print("post decoder error")
                    }
                }
            }
        })
        task.resume()
    }
    
    //DELETE
    func deleteArticle(username:String,whichArticle:Int,completion:@escaping()->Void){
        let baseURL = "https://us-central1-shavenking-me-1dfe2.cloudfunctions.net/posts/\(whichArticle)/"
        let url = URL(string: baseURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue(username, forHTTPHeaderField: "username")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 204{
                       completion()
                    }
                }
            }
        }
        task.resume()
    }
    
    
    //POST like
    func submitLikeForSpecifiedArticle(username:String,whichArticle:Int,completion:@escaping()->Void){
        let baseURL = "https://us-central1-shavenking-me-1dfe2.cloudfunctions.net/posts/\(whichArticle)/likes/"
        let url = URL(string: baseURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue(username, forHTTPHeaderField: "username")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 200{
                        completion()
                    }
                }
            }
        }
        task.resume()
    }
    
    //DELETE like
    func deleteLikeForSpecifiedArticle(username:String,whichArticle:Int,completion:@escaping()->Void) {
        let baseURL = "https://us-central1-shavenking-me-1dfe2.cloudfunctions.net/posts/\(whichArticle)/likes/"
        let url = URL(string: baseURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue(username, forHTTPHeaderField: "username")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 204{
                        completion()
                    }
                }
            }
        }
        task.resume()
    }
}
