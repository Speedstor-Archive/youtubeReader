//
//  VideoCell.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/13.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var stats: UILabel!
    @IBOutlet weak var likeRatio: UIProgressView!
    @IBOutlet weak var videoId: UILabel!
    
    
    func setVideo(video: Video){
        videoImageView.image = video.image
        videoTitleLabel.text = video.title
        channelName.text = video.channelName
        stats.text = video.stats
        likeRatio.progress = video.likeRatio
        videoId.text = video.videoId
    }
    
}
