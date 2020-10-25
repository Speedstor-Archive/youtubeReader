//
//  SearchViewController.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/16.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var videos: [Video] = []
    let feedParser: FeedParser = FeedParser()
    let youtube: Youtube = Youtube(feedParser: FeedParser())
    
    var searchForVideo = true;
    
    var displayListType: Int = 0
    //0 - none
    //1 - video
    //2 - channel

    @IBOutlet var channelButton: UIButton!
    @IBOutlet var videoButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchField: UITextField!
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoListVC = Storyboard.instantiateViewController(withIdentifier: "RevealView") as! SWRevealViewController
        
        print(videoListVC)
        present(videoListVC, animated: true)
    }
    
    @IBAction func videoButtonPressed(_ sender: Any) {
        channelButton.setTitleColor(.gray , for: .normal)
        videoButton.setTitleColor(.init(red: 79/255, green: 146/255, blue: 1, alpha: 1), for: .normal)
        
        searchForVideo = true
    }
    
    @IBAction func channelButtonPressed(_ sender: Any) {
        videoButton.setTitleColor(.gray , for: .normal)
        channelButton.setTitleColor(.init(red: 79/255, green: 146/255, blue: 1, alpha: 1), for: .normal)
        
        searchForVideo = false
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if let query = searchField.text {
            if(searchForVideo){
                let list = youtube.searchForVideo(query: query)
                videos = createArrayForVideo(list: list)
                displayListType = 1
            }else{
                let list = youtube.searchForChannel(query: query)
                videos = createArrayForChannel(list: list)
                displayListType = 2
            }
            
            
            print("hi, before table reload")
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(displayListType == 1){
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let transcriptVC = Storyboard.instantiateViewController(withIdentifier: "TranscriptView") as! TranscriptView
            
            transcriptVC.image = videos[indexPath.row].image
            transcriptVC.videoTitle = videos[indexPath.row].title
            transcriptVC.channelName = videos[indexPath.row].channelName
            transcriptVC.stats = videos[indexPath.row].stats
            transcriptVC.likeRatio = videos[indexPath.row].likeRatio
            transcriptVC.videoId = videos[indexPath.row].videoId
            
            
            self.navigationController?.pushViewController(transcriptVC, animated: true)
        }else if(displayListType == 2){
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let channelListScreen = Storyboard.instantiateViewController(withIdentifier: "ChannelListScreen") as! ChannelListScreen
            
            channelListScreen.fromSearch = true
            channelListScreen.channelUrl = "channel/\(videos[indexPath.row].videoId)"
            
            self.navigationController?.pushViewController(channelListScreen, animated: true)
        }
    }
    
    func createArrayForChannel(list: [(String, UIImage, String, String, String, String)]) -> [Video]{
        //returns: channelName, channelImg, subcribers, viewCount, videoCount, channelId
        var tempVideos: [Video] = []
        
        for i in 0...list.count-1{
            
            let video = Video(videoId: list[i].5,image: list[i].1, title: list[i].0, channelName: "", stats: "\(shortenNumber(original: list[i].2)) subs . \(shortenNumber(original: list[i].3)) views", likeRatio: 1);
            tempVideos.append(video);
        }
        
        
        return tempVideos
    }
    
    
    
    func createArrayForVideo(list: [(UIImage, String, String, String, Float, String)]) -> [Video]{
        //list values:imgae, videoTItle, channelname, stats, likeRatio, videoId
        var tempVideos: [Video] = []
        
        for i in 0...list.count-1{ 
            let video = Video(videoId: list[i].5,image: list[i].0, title: list[i].1, channelName: list[i].2, stats: list[i].3, likeRatio: list[i].4);
            tempVideos.append(video);
        }
        
        return tempVideos
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
    
    
    //copied from: https://stackoverflow.com/questions/32041420/cropping-image-with-swift-and-put-it-on-center-position
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cgwidth: CGFloat = CGFloat(width)
        let cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        
        posX = 0
        posY = ((contextSize.height - cgheight) / 2)
        
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef)
        
        return image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    //    run everytime a cell appears
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
        
        cell.setVideo(video: video)
        
        return cell
    }
    
}
