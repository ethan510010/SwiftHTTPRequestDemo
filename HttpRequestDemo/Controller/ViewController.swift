//
//  ViewController.swift
//  HttpRequestDemo
//
//  Created by EthanLin on 2018/3/16.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func ensureButton(_ sender: UIButton) {
        UserDefaults.standard.set(textField.text, forKey: "username")
        performSegue(withIdentifier: "goToView2", sender: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.string(forKey: "username")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

