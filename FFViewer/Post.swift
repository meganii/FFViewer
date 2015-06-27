//
//  Posts.swift
//  FFViewer
//
//  Created by  Yuhei Tsubokawa on 2015/06/27.
//  Copyright (c) 2015年  Yuhei Tsubokawa. All rights reserved.
//

import Foundation

@objc(Post)
class Post : NSObject {
    var filename: String = ""
    var prop: Dictionary<String, String> = [:]
    var content: String = ""
}