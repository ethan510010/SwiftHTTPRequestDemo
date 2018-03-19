//
//  ArticleModel.swift
//  HttpRequestDemo
//
//  Created by EthanLin on 2018/3/19.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import Foundation

struct Article:Codable {
    var likes:[String:Bool]
    var author:String
    var content:String
    var id:Int
    var topic:String
    var is_liked:Bool
}
