//
//  FFViewer.swift
//  FFViewer
//
//  Created by  Yuhei Tsubokawa on 2015/06/27.
//  Copyright (c) 2015年  Yuhei Tsubokawa. All rights reserved.
//

import Cocoa

class FFViewer : NSObject {
    
    let sourcePath = "/Users/meganii/Work/MacOSXApplication/doc"
    let outputPath = "/Users/meganii/Work/MacOSXApplication/replaceDoc/"
    
    func output (posts : [Post]) {
        print("output")
        
        for post in posts {
            var yaml = createYAML(post.prop)
            File.write(outputPath + post.filename, content: yaml + post.content)
        }
    }
    
    func createYAML(dic: Dictionary<String, String>) -> String {
        var yaml = "---\n"
        
        if dic["layout"] != nil {
            yaml += "layout: " + dic["layout"]! + "\n"
        }
        
        if dic["title"] != nil {
            yaml += "title: " + dic["title"]! + "\n"
        }
        
        if dic["date"] != nil {
            yaml += "date: " + dic["date"]! + "\n"
        }
        
        if dic["comments"] != nil {
            yaml += "comments: " + dic["comments"]! + "\n"
        }
        
        if dic["category"] != nil {
            yaml += "category: " + dic["category"]! + "\n"
        }
        
        if dic["tags"] != nil {
            yaml += "tags: " + dic["tags"]! + "\n"
        }
        
        if dic["published"] != nil {
            yaml += "published: " + dic["published"]! + "\n"
        }
        
        if dic["img"] != nil {
            yaml += "img: " + dic["img"]! + "\n"
        }
        
        yaml += "---\n"
        return yaml
    }
    
    func load() -> [Post] {
        
        var posts: [Post] = []
        
        
        // filemaneger
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(sourcePath, error: nil)!
        
        
        let pattern = "---"
        let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
        
        
        for file in contents {
            var filename = file as! NSString
            
            // exclude .DS_Store
            if filename == ".DS_Store" {
                continue
            }

            // exclude vim backup files
            if filename.substringFromIndex(filename.length-1) == "~" {
                continue
            }

            var content: NSString = NSString(contentsOfFile: sourcePath.stringByAppendingPathComponent(filename as String), encoding: NSUTF8StringEncoding, error: nil)!
            
            let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            var matches=regex?.matchesInString(content as String, options: nil, range:NSMakeRange(0,  content.length)) as! Array<NSTextCheckingResult>
            
            // Extract Frontmatter
            var str = content.substringFromIndex(matches[0].range.length + 1 ) as NSString
            str = str.substringToIndex(matches[1].range.location - 4)
            
            
            var post = Post()
            var text = content.substringFromIndex(matches[1].range.location + 4)
            post.content = text
            post.filename = filename as String
            
            let yamlElements = str.componentsSeparatedByString("\n")
            for element in yamlElements {
                var keyVal = element.componentsSeparatedByString(":")
                if keyVal.count > 1 {
                    var value = ltrim(element.substringFromIndex(keyVal[0].length+1))
                    post.prop[(keyVal[0] as! String)] = value
                }
            }
            
            posts.append(post)
        }
        
        return posts
    }
    
    func ltrim(string: NSString) -> String {
        var str = string.copy() as! NSString
        if str.length == 0 {
            return str as String
        }
        
        while isStartWithEmpty(str) {
            str = str.substringFromIndex(1)
        }
        return str as String;
    }
    
    func isStartWithEmpty(str: NSString) -> Bool {
        if str.length == 0 {
            return false
        }
        
        if str.substringToIndex(1) == " " {
            return true
        }
        
        return false
    }
    
    func replace(posts: [Post], before: String, after: String) -> [Post] {
    
        for post in posts {
            if post.prop["category"] == before {
                post.prop["category"] = after
            }
        }
        
        return posts
    }

}
