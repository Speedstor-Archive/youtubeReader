//
//  GetTranscript.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/15.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import Foundation

class GetTranscript{
    var feedParser: FeedParser
    
    init(feedParser: FeedParser){
        self.feedParser = feedParser
    }
    
    func getTranscriptFromVideo(videoId: String) -> String {
        let url = getTranscriptLink(videoId: videoId)
        return getSentencesAsString(url: url)
    }
    
    func getSentencesAsString(url: String) -> String{
        var returnVar: [String] = []
        let page = feedParser.getPage(url: url)
        
        let lines = feedParser.subStringAll(original: page, from: "<p", to: "</p>")
        
        
        var returnVar2:String = "";
        //restyle transcript
        if(lines.count > 0){
            for i in 0...lines.count-1{
                returnVar.append(feedParser.subStringToEnd(original: lines[i], find: ">"))
                
    //            returnVar[i] = returnVar[i].replacingOccurrences(of: "<span ", with: "<font color=\"")
    //            returnVar[i] = returnVar[i].replacingOccurrences(of: "</span>", with: "</font>")
    //            returnVar[i] = returnVar[i].replacingOccurrences(of: "\">", with: "")
    //            returnVar[i] = returnVar[i].replacingOccurrences(of: "&#39;", with: "'")
    //
    //            returnVar[i] = returnVar[i].replacingOccurrences(of: "style=\"s3", with: "green\">")
    //            returnVar[i] = returnVar[i].replacingOccurrences(of: "style=\"s4", with: "red\">")
                
                returnVar[i] = returnVar[i].replacingOccurrences(of: "<span ", with: "")
                returnVar[i] = returnVar[i].replacingOccurrences(of: "</span>", with: "")
                returnVar[i] = returnVar[i].replacingOccurrences(of: "\">", with: "")
                returnVar[i] = returnVar[i].replacingOccurrences(of: "&#39;", with: "'")
                
                returnVar[i] = returnVar[i].replacingOccurrences(of: "style=\"s3", with: "")
                returnVar[i] = returnVar[i].replacingOccurrences(of: "style=\"s4", with: "")
                
                returnVar2 += " \(returnVar[i])"
            }
        }else{
            returnVar2 = "No transcripts are available for video"
        }
        
        return returnVar2
    }
    
    func getSentences(url: String) -> [[String]]{
        var returnVar: [[String]] = []
        let page = feedParser.getPage(url: url)
        
        let lines = feedParser.subStringAll(original: page, from: "<p", to: "</p>")
        
        for i in 0...lines.count-1{
            returnVar.append([String]())
            returnVar[i].append(feedParser.subStringToEnd(original: lines[i], find: ">"))                  //transcript
            returnVar[i].append(feedParser.subString(original: lines[i], from: "begin=\\\"", to: "\\\""))  //start time
            returnVar[i].append(feedParser.subString(original: lines[i], from: "end=\\\"", to: "\\\""))    //end time
        }
        
        //restyle transcript
        for i in 0...returnVar.count-1{
            returnVar[i][0] = returnVar[i][0].replacingOccurrences(of: "<span ", with: "")
            returnVar[i][0] = returnVar[i][0].replacingOccurrences(of: "</span>", with: "")
            returnVar[i][0] = returnVar[i][0].replacingOccurrences(of: "\">", with: "")
            returnVar[i][0] = returnVar[i][0].replacingOccurrences(of: "&#39;", with: "'")
            
            returnVar[i][0] = returnVar[i][0].replacingOccurrences(of: "style=\"s3", with: "")
            returnVar[i][0] = returnVar[i][0].replacingOccurrences(of: "style=\"s4", with: "")
            
        }
        
        return returnVar
    }
    
    func getTranscriptLink(videoId: String) -> String{
        
        let page = feedParser.getPage(url: "https://www.youtube.com/watch?v=\(videoId)")
        
        var searchRange = page.startIndex..<page.endIndex
        
        //fromIndex
        var initPointer: Int = 0
        if let index = page.range(of: "https:\\/\\/www.youtube.com\\/api\\/timedtext")?.lowerBound{
            initPointer = page.distance(from: page.startIndex, to: index)
            searchRange = index..<page.endIndex
        }
        
        //toIndex
        var finalPointer: Int = initPointer
        if let index = page.range(of: "\"", options: .caseInsensitive, range: searchRange)?.lowerBound{
            finalPointer = page.distance(from: page.startIndex, to: index)
        }
        
        var returnLink = String(page[initPointer ..< finalPointer])
        returnLink = returnLink.replacingOccurrences(of: "\\/", with: "/")
        returnLink = returnLink.replacingOccurrences(of: "\\\\u0026", with: "&")
        returnLink = returnLink.replacingOccurrences(of: "\\", with: "")
        
        returnLink += "&fmt=ttml"
//        returnLink += "&tlang=zh-Hant"
        
        return returnLink
    }
    
    
}
