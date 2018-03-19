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
    
    let apiManager = APIManager()
    
    
    //接收存下來的資料
    let username = UserDefaults.standard.string(forKey: "username")
    
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBAction func ensureButton(_ sender: UIButton) {
        apiManager.submitArticle(urlString: baseUrl, username: username!, postTopic: topicTextField.text!, postContent: contentTextView.text) { (article) in
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
