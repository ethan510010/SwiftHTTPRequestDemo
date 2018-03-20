//
//  EditArticleViewController.swift
//  HttpRequestDemo
//
//  Created by EthanLin on 2018/3/19.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

class EditArticleViewController: UIViewController {
    
    
    let baseUrl = "https://us-central1-shavenking-me-1dfe2.cloudfunctions.net/posts/"
    
    let username = UserDefaults.standard.string(forKey: "username")
    
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBAction func ensureButton(_ sender: UIButton) {
        APIManager.shared.submitArticle(urlString: baseUrl, username: username!, postTopic: topicTextField.text!, postContent: contentTextView.text!) { (article) in
            print("ok")
        }
        self.navigationController?.popViewController(animated: true)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
