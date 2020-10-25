//
//  XMLParser.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/14.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import Foundation


class FeedParser{
    let myURLString: String = "https://www.youtube.com/feeds/videos.xml?channel_id=UC6emPPqCDRjspc36ukZ7FdA"
    
    init(){
        
//        print(string);
    }
    
    func getChannelRss(channelUrl: String) -> String{
        //url as the url to channel
        var channelRss = "";
        //if channel url is custom
        if channelUrl.contains("user"){
            channelRss += "https://www.youtube.com/feeds/videos.xml?user="
            
            channelRss += subStringToEnd(original: channelUrl, find: "user/")
            
        }else if channelUrl.contains("channel"){
            channelRss += "https://www.youtube.com/feeds/videos.xml?channel_id="
            
            channelRss += subStringToEnd(original: channelUrl, find: "channel/")
        }
        
        return channelRss
    }
    
    func getChannelId(channelUrl: String) -> String{
        //url as the url to channel
        var channelRss = "";
        //if channel url is custom
        if channelUrl.contains("user"){
            
            channelRss += subStringToEnd(original: channelUrl, find: "user/")
            
        }else if channelUrl.contains("channel"){
            
            channelRss += subStringToEnd(original: channelUrl, find: "channel/")
        }
        
        return channelRss
    }
    
    
    func getVideoList(rssUrl: String) -> [[String]]{
        var result: [[String]] = []
        var entries: [String] = []
        let rssPage: String = getPage(url: rssUrl)
        
        entries = subStringAll(original: rssPage, from: "<entry>", to: "</entry>")
        
        for i in 0...entries.count-1{
            result.append([String]());
            result[i].append(subString(original: entries[i], from: "<id>", to: "</id>"))
            result[i].append(subString(original: entries[i], from: "<yt:videoId>", to: "</yt:videoId>"))
            result[i].append(subString(original: entries[i], from: "<yt:channelId>", to: "</yt:channelId>"))
            result[i].append(subString(original: entries[i], from: "<title>", to: "</title>"))
            result[i].append(subString(original: entries[i], from: "<name>", to: "</name>"))
            result[i].append(subString(original: entries[i], from: "<uri>", to: "</uri>"))
            result[i].append(subString(original: entries[i], from: "<published>", to: "</published>"))
            result[i].append(subString(original: entries[i], from: "<updated>", to: "</updated>"))
            result[i].append(subString(original: entries[i], from: "<media:title>", to: "</media:title>"))
            result[i].append(subString(original: entries[i], from: "<media:content", to: "/>"))
            result[i].append(subString(original: entries[i], from: "<media:thumbnail", to: "/>"))
            result[i].append(subString(original: entries[i], from: "<media:description>", to: "</media:description>"))
            result[i].append(subString(original: entries[i], from: "<media:starRating", to: " min=\"1\" max=\"5\"/>"))
            result[i].append(subString(original: entries[i], from: "<media:statistics views=\"", to: "\"/>"))
        }
        
        print("Retrieved video list of channel: _\(result[1][4])_, with _\(result.count)_ videos")
        return result
    }
    
    
    func getPage(url: String) -> String{
        var htmlString: String = ""
        guard let myURL = URL(string: url) else {
            print("Error: \(url) doesn't seem to be a valid URL")
            return "-1"
        }
        
        do {
            htmlString = try String(contentsOf: myURL, encoding: .ascii)
        } catch let error {
            print("Error: \(error)")
        }
        
        return htmlString
    }
    
    
    
    
    
    //String manipulation
    func subStringToEnd(original: String, find: String) -> String{
        var pointer: Int = 0
        
        if let index = original.range(of: find)?.upperBound{
            pointer = original.distance(from: original.startIndex, to: index)
        }
        let returnVar = String(original[pointer ..< original.count])
        
        return returnVar
    }
    
    func subString(original: String, from: String, to: String) -> String{
        var searchRange = original.startIndex..<original.endIndex
        
        //fromIndex
        var initPointer: Int = 0
        if let index = original.range(of: from)?.upperBound{
            initPointer = original.distance(from: original.startIndex, to: index)
            searchRange = index..<original.endIndex
        }
        
        //toIndex
        var finalPointer: Int = initPointer
        if let index = original.range(of: to, options: .caseInsensitive, range: searchRange)?.lowerBound{
            finalPointer = original.distance(from: original.startIndex, to: index)
        }
        
        let returnVar = String(original[initPointer ..< finalPointer])
        
        return returnVar
    }
    
    func subStringFrom(start: Int, original: String, from: String, to: String) -> String{
        let search = original.substring(fromIndex: start)
        
        //fromIndex
        var initPointer: Int = 0
        if let index = search.range(of: from)?.upperBound{
            initPointer = search.distance(from: original.startIndex, to: index)
        }
        
        //toIndex
        var finalPointer: Int = initPointer
        if let index = search.range(of: to)?.lowerBound{
            finalPointer = search.distance(from: original.startIndex, to: index)
        }
        
        let returnVar = String(search[initPointer ..< finalPointer])
        
        return returnVar
    }
    
    func subStringAll(original: String, from: String, to: String) -> [String]{
        var returnVar: [String] = []
        var searchRange = original.startIndex..<original.endIndex
        
        while let range = original.range(of: from, options: .caseInsensitive, range: searchRange)?.upperBound {
            searchRange = range..<original.endIndex
            let initPointer = original.distance(from: original.startIndex, to: range)
            
            //toIndex
            var finalPointer: Int = initPointer
            if let index = original.range(of: to, options: .caseInsensitive, range: searchRange)?.lowerBound{
                finalPointer = original.distance(from: original.startIndex, to: index)
            }
            
            returnVar.append(String(original[initPointer ..< finalPointer]))
        }
        
        
        return returnVar
    }
    
}



//copied from: https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
