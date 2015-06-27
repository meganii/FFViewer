//
//  FFViewer.swift
//  FFViewer
//
//  Created by  Yuhei Tsubokawa on 2015/06/27.
//  Copyright (c) 2015年  Yuhei Tsubokawa. All rights reserved.
//

import Cocoa

class FFViewer : NSObject {
    
    func output (posts : [Post]) {
        print("output")
        for post in posts {
            
            var frontformatter = "--\n"
            let keys: Array = Array(post.prop.keys)
            for key in keys {
                frontformatter += key + ": " + post.prop[key]! + "\n"
            }
            frontformatter += "---\n"
            File.write("/Users/meganii/Work/MacOSXApplication/replaceDoc/" + post.filename, content: frontformatter + post.content)
        }
    }
    
    func load() -> [Post] {
        
        var posts: [Post] = []
        
        let documentsPath = "/Users/meganii/Work/MacOSXApplication/doc"
        
        // filemaneger
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(documentsPath, error: nil)!
        
        
        let pattern = "---"
        let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
        
        
        for file in contents {
            if file as String == ".DS_Store" {
                continue
            }

            var content: NSString = NSString(contentsOfFile: documentsPath.stringByAppendingPathComponent(file as String), encoding: NSUTF8StringEncoding, error: nil)!
            
            let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            var matches=regex?.matchesInString(content, options: nil, range:NSMakeRange(0,  content.length)) as Array<NSTextCheckingResult>
            
            // Extract Frontmatter
            var str = content.substringFromIndex(matches[0].range.length + 1 ) as NSString
            str = str.substringToIndex(matches[1].range.location - 4)
            
            
            var post = Post()
            var text = content.substringFromIndex(matches[1].range.location + 4)
            post.content = text
            post.filename = file as String
            
            let cells = str.componentsSeparatedByString("\n")
            for cell in cells {
                var keyVal = cell.componentsSeparatedByString(":")
                if keyVal.count > 1 {
                    post.prop[(keyVal[0] as String)] = (keyVal[1] as String)
                }
            }
            
            posts.append(post)
        }
        
        return posts
    }
}
