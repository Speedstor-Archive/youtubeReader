//
//  TranscriptView.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/15.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit

class TranscriptView: UIViewController {
    //inherit
    var image: UIImage?
    var videoTitle: String?
    var channelName: String?
    var stats: String?
    var likeRatio: Float?
    var videoId: String?
    let getTranscript: GetTranscript = GetTranscript(feedParser: FeedParser());
    
    //init Variables
    @IBOutlet weak var videoImg: UIImageView!
    @IBOutlet weak var VideoTitle: UILabel!
    @IBOutlet weak var videoChannelName: UILabel!
    @IBOutlet weak var videoStats: UILabel!
    @IBOutlet weak var videoLikes: UIProgressView!
    @IBOutlet weak var videoTranscript: UITextView!
    
    var transcriptArray: [[String]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoImg.image = image
        VideoTitle.text = videoTitle
        videoChannelName.text = channelName
        videoStats.text = stats
        videoLikes.progress = Float(likeRatio!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        videoTranscript.text = getTranscript.getTranscriptFromVideo(videoId: videoId ?? "LhhW3xqhCzg")
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
