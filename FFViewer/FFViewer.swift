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
    
    let ffTag = "---\n"
    
    func output (posts : [Post]) {
        print("output")
        for post in posts {
            
            var frontformatter = ffTag
            let keys: Array = Array(post.prop.keys)
            for key in keys {
                frontformatter += key + ": " + post.prop[key]! + "\n"
            }
            frontformatter += ffTag
            File.write(outputPath + post.filename, content: frontformatter + post.content)
        }
    }
    
    func load() -> [Post] {
        
        var posts: [Post] = []
        
        
        // filemaneger
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(sourcePath, error: nil)!
        
        
        let pattern = "---"
        let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
        
        
        for file in contents {
            var filename = file as NSString
            
            // exclude .DS_Store
            if filename == ".DS_Store" {
                continue
            }

            // exclude vim backup files
            if filename.substringFromIndex(filename.length-1) == "~" {
                continue
            }

            var content: NSString = NSString(contentsOfFile: sourcePath.stringByAppendingPathComponent(filename), encoding: NSUTF8StringEncoding, error: nil)!
            
            let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            var matches=regex?.matchesInString(content, options: nil, range:NSMakeRange(0,  content.length)) as Array<NSTextCheckingResult>
            
            // Extract Frontmatter
            var str = content.substringFromIndex(matches[0].range.length + 1 ) as NSString
            str = str.substringToIndex(matches[1].range.location - 4)
            
            
            var post = Post()
            var text = content.substringFromIndex(matches[1].range.location + 4)
            post.content = text
            post.filename = filename
            
            let yamlElements = str.componentsSeparatedByString("\n")
            for element in yamlElements {
                var keyVal = element.componentsSeparatedByString(":")
                if keyVal.count > 1 {
                    post.prop[(keyVal[0] as String)] = (keyVal[1] as String)
                }
            }
            
            posts.append(post)
        }
        
        return posts
    }
}
