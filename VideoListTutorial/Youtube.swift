//
//  Youtube.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/15.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import Foundation
import UIKit

class Youtube{
    var feedParser: FeedParser
    
    init(feedParser: FeedParser){
        self.feedParser = feedParser
    }
    
    func getChannelImgFromId(channelId: String) -> UIImage{
        var urlToImg = feedParser.getPage(url: "https://www.googleapis.com/youtube/v3/channels?part=snippet&id=\(channelId)&fields=items%2Fsnippet%2Fthumbnails%2Fmedium&key=AIzaSyB5IrG-c2YhKYREnQ_cm9szfXKemeYf7LY")
        
        urlToImg = feedParser.subString(original: urlToImg, from: "\"url\": \"", to: "\"")
        
        return getImgFromUrl(url: urlToImg)
    }
    
    //returnValues:    videoType
    //returnValues[i]: imgUrl, videoId, videoTitle, channelName, stats
    func getRecommended() -> [[[String]]]{
        var returnVar: [[[String]]] = []
        var htmlString: String = ""
        do {
            htmlString = try String(contentsOf: URL(string: "https://www.youtube.com")!, encoding: .ascii)
        } catch let error {
            print("Error: \(error)")
        }
        let listTypeVideos = feedParser.subStringAll(original: htmlString, from: "<span class=\"branded-page-module-title-text\"", to: "<div class=\"feed-item-dismissal-notices\"></div>")
        
        if(listTypeVideos.count > 0){
            for i in 0...listTypeVideos.count-1{
                returnVar.append([[String]]())
                returnVar[i].append([feedParser.subString(original: listTypeVideos[i], from: ">", to: "</span>")])
                
                let videoList = feedParser.subStringAll(original: listTypeVideos[i], from: "<li class=\"yt-shelf-grid-item", to: "<div class=\"yt-lockup-notifications-container hid\">")
                if(videoList.count > 0){
                    for a in 0...videoList.count-1{
                        var incompleteImgUrl = feedParser.subString(original: videoList[a], from: "<img", to: ">")
                        let videoId = feedParser.subString(original: videoList[a]
                            , from: "href=\"/watch?v=", to: "\"")
                        let incompleteTitle = feedParser.subString(original: videoList[a], from: "class=\" yt-ui-ellipsis", to: "<")
                        var stats = feedParser.subString(original: videoList[a], from: "<ul class=\"yt-lockup-meta", to: "</ul>")
                        var incompletechannelName = feedParser.subString(original: videoList[a], from: "<a href=\"/channel/", to: "</a>")
                        if(incompletechannelName.count > 300){
                            incompletechannelName = feedParser.subString(original: videoList[a], from: "<a href=\"/user/", to: "</a>")
                        }
                        let statsTemp = feedParser.subStringAll(original: stats, from: "<li>", to: "</li>")
                        
                        if(statsTemp.count == 2){
                            stats = "\(statsTemp[0]) . \(statsTemp[1])"
                        }else {
                            stats = ""
                        }
                        
//                        if(a == 7 && i == 0) {print("----- "+videoList[a])}
//                        if(a == 1 && i == 0) {print("----- "+incompleteImgUrl)}
                        incompleteImgUrl = "https://"+feedParser.subString(original: incompleteImgUrl, from: "\"https://", to: "\"")
                        
                        returnVar[i].append([incompleteImgUrl, videoId, feedParser.subStringToEnd(original: incompleteTitle, find: ">"), feedParser.subStringToEnd(original: incompletechannelName, find: ">"), stats])
                    }
                }
            }
        }
        
        return returnVar
    }
    
    //returnValues:    videoType
    //returnValues[i]: imgUrl, videoId, videoTitle, channelName, stats
    func getTrending() -> [[[String]]]{
        var returnVar: [[[String]]] = []
        var htmlString: String = ""
        do {
            htmlString = try String(contentsOf: URL(string: "https://www.youtube.com")!, encoding: .ascii)
        } catch let error {
            print("Error: \(error)")
        }
        let listTypeVideos = feedParser.subStringAll(original: htmlString, from: "<span class=\"branded-page-module-title-text\"", to: "<div class=\"feed-item-dismissal-notices\"></div>")
        
        
        if(listTypeVideos.count > 0){
            for i in 0...listTypeVideos.count-1{
                returnVar.append([[String]]())
                returnVar[i].append([feedParser.subString(original: listTypeVideos[i], from: ">", to: "</span>")])
                
                let videoList = feedParser.subStringAll(original: listTypeVideos[i], from: "<li class=\"yt-shelf-grid-item", to: "</ul></div>")
                
                
                if(videoList.count > 0){
                    for a in 0...videoList.count-1{
                        var incompleteImgUrl = feedParser.subString(original: videoList[a], from: "<img", to: ">")
                        let videoId = feedParser.subString(original: videoList[a]
                            , from: "href=\"/watch?v=", to: "\"")
                        let incompleteTitle = feedParser.subString(original: videoList[a], from: "class=\" yt-ui-ellipsis", to: "<")
                        var stats = feedParser.subStringToEnd(original: videoList[a], find: "\"><ul class=\"yt-lockup-meta")+"</li>"
                        var incompletechannelName = feedParser.subString(original: videoList[a], from: "<a href=\"/channel/", to: "</a>")
                        if(incompletechannelName.count > 300){
                            incompletechannelName = feedParser.subString(original: videoList[a], from: "<a href=\"/user/", to: "</a>")
                        }
                        
                        let statsTemp = feedParser.subStringAll(original: stats, from: "<li>", to: "</li>")
                        
                        if(statsTemp.count == 2){
                            stats = "\(statsTemp[0]) . \(statsTemp[1])"
                        }else {
                            stats = ""
                        }
                        
                        //                        if(a == 7 && i == 0) {print("----- "+videoList[a])}
                        //                        if(a == 1 && i == 0) {print("----- "+incompleteImgUrl)}
                        incompleteImgUrl = "https://"+feedParser.subString(original: incompleteImgUrl, from: "\"https://", to: "\"")
                        
                        returnVar[i].append([incompleteImgUrl, videoId, feedParser.subStringToEnd(original: incompleteTitle, find: ">"), feedParser.subStringToEnd(original: incompletechannelName, find: ">"), stats])
                    }
                }
            }
        }
        
        return returnVar
    }
    
    func getChannelNameFromId(channelId: String) -> String{
        var urlToId = feedParser.getPage(url: "https://www.googleapis.com/youtube/v3/channels?part=snippet%2Cstatistics&fields=items&id=\(channelId)&key=AIzaSyB5IrG-c2YhKYREnQ_cm9szfXKemeYf7LY")
        
        urlToId = feedParser.subString(original: urlToId, from: "\"title\": \"", to: "\"")
        
        return urlToId
    }
    
    func getDetailsFromId(channelId: String) -> (String, UIImage, String, String, String, String){
        //returns: channelName, channelImg, subcribers, viewCount, videoCount
        
        let urlToStats = feedParser.getPage(url: "https://www.googleapis.com/youtube/v3/channels?part=snippet%2Cstatistics&fields=items&id=\(channelId)&key=AIzaSyB5IrG-c2YhKYREnQ_cm9szfXKemeYf7LY")
        
        let urlToImg = feedParser.subString(original: urlToStats, from: "\"url\": \"", to: "\"")
        
        return (feedParser.subString(original: urlToStats, from: "\"title\": \"", to: "\""),            //Name
                getImgFromUrl(url: urlToImg),                                                           //Img
                feedParser.subString(original: urlToStats, from: "\"subscriberCount\": \"", to: "\""),  //subs
                feedParser.subString(original: urlToStats, from: "\"viewCount\": \"", to: "\""),        //views
                feedParser.subString(original: urlToStats, from: "\"videoCount\": \"", to: "\""),       //videosNum
                channelId)
        
    }
    
    func getImgFromUrl(url: String) -> UIImage{
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!)
        return UIImage(data: data!)!
    }
    
    func searchForChannel(query: String) -> [(String, UIImage, String, String, String, String)]{
        var returnVar: [(String, UIImage, String, String, String, String)] = []
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=8&q=\(query.replacingOccurrences(of: " ", with: "+"))&type=channel&key=AIzaSyB5IrG-c2YhKYREnQ_cm9szfXKemeYf7LY"
        
        let json = feedParser.getPage(url: url)
        
        let channelId = feedParser.subStringAll(original: json, from: "\"channelId\": \"", to: "\"")
        
        for i in 0...(channelId.count-2)/2{
            returnVar.append(getDetailsFromId(channelId: channelId[i*2]))
        }
        
        return returnVar
    }
    
    func searchForVideo(query: String) -> [(UIImage, String, String, String, Float, String)]{
        var returnVar: [(UIImage, String, String, String, Float, String)] = []
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=28&q=\(query.replacingOccurrences(of: " ", with: "+"))&type=video&key=AIzaSyB5IrG-c2YhKYREnQ_cm9szfXKemeYf7LY"
        let json = feedParser.getPage(url: url)
        
        let videoId = feedParser.subStringAll(original: json, from: "\"videoId\": \"", to: "\"")
        
        for i in 0...videoId.count-1{
            returnVar.append(getVideoDetailsFromId(videoId: videoId[i]))
        }
        
        return returnVar
    }
    
    //return values: imgae, videoTItle, channelname, stats, likeRatio, videoId
    func getVideoDetailsFromId(videoId: String) -> (UIImage, String, String, String, Float, String){
        let url = "https://www.googleapis.com/youtube/v3/videos?part=snippet%2C%20statistics&id=\(videoId)&key=AIzaSyB5IrG-c2YhKYREnQ_cm9szfXKemeYf7LY"
        let json = feedParser.getPage(url: url)
            
        let img = feedParser.subStringAll(original: json, from: "\"url\": \"", to: "\",")
        let videoTitle = feedParser.subString(original: json, from: "\"title\": \"", to: "\"")
        let channelName = feedParser.subString(original: json, from: "\"channelTitle\": \"", to: "\"")
        let viewCount = feedParser.subString(original: json, from: "\"viewCount\": \"", to: "\"")
        let uploadDate = feedParser.subString(original: json, from: "\"publishedAt\": \"", to: "\"")
        let like = feedParser.subString(original: json, from: "\"likeCount\": \"", to: "\"")
        let dislike = feedParser.subString(original: json, from: "\"dislikeCount\": \"", to: "\"")
        
        var url2: URL = URL(string: img[0])!
        if(img.count > 0){
            url2 = URL(string: img[img.count-1])!
        }
        let data = try? Data(contentsOf: url2)
        let returnImg = UIImage(data: data!)!
        
        
        var numLike: Int = 0
        var numDislike: Int = 0
        if let i = Int(like){
            numLike = i
        }
        if let i = Int(dislike){
            numDislike = i
        }
        var likeRatio: Float = 0
        if(numLike != 0 || numDislike != 0){
            let total = numLike + numDislike
            likeRatio = Float(Float(numLike) / Float(total))
        }else{
            likeRatio = 0
        }
            
        let stats: String = "\(shortenNumber(original: viewCount)) views . \(getDatePassed(fromDate: uploadDate))"
        
        
        return (returnImg, videoTitle, channelName, stats, likeRatio, videoId)
    }
    
    func shortenNumber(original: String) -> String{
        var returnVar: String = ""
        
        if original.count > 9{
            returnVar = original[0 ..< original.count-9]
            returnVar += "B"
        }else if original.count > 6{
            returnVar = original[0 ..< original.count-6]
            returnVar += "M"
        }else if original.count > 3{
            returnVar = original[0 ..< original.count-3]
            returnVar += "K"
        }else{
            returnVar = original
        }
        
        return returnVar
    }
    
    
    //2019-04-14T19:00:36.000Z
    func getDatePassed(fromDate: String) -> String{
        let dateCom = Date()
        let calendar = Calendar.current
        var datePassed: String = "date error"
        var date: [Int] = []
        date.append(calendar.component(.year, from: dateCom))   //0 - year
        date.append(calendar.component(.month, from: dateCom))  //1 - month
        date.append(calendar.component(.day, from: dateCom))    //2 - day
        date.append(calendar.component(.hour, from: dateCom))   //3 - hour
        date.append(calendar.component(.minute, from: dateCom)) //4 - minute
        
        //bottleNeck
        let fromdate: [Int] = [Int(fromDate[0 ..< 3])!, Int(fromDate[5 ..< 6])!, Int(fromDate[8 ..< 9])!, Int(fromDate[11 ..< 12])!]
        if(fromdate[0] == date[0]){
            if(fromdate[1] == date[1]){
                if(fromdate[2] == date[2]){
                    if(fromdate[3] == date[3]){
                        if(fromdate[4] == date[4]){
                            datePassed = "Just Now"
                        }else{
                            datePassed = "\(date[4] - fromdate[4]) minutes ago"
                        }
                    }else{
                        datePassed = "\(date[3] - fromdate[3]) hours ago"
                    }
                }else{
                    datePassed = "\(date[2] - fromdate[2]) days ago"
                }
            }else{
                datePassed = "\(date[1] - fromdate[1]) months ago"
            }
        }else{
            datePassed = "\(date[0] - fromdate[0]) years ago"
        }
        
        return datePassed
    }
}
