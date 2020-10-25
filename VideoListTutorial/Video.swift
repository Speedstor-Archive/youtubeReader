//
//  Video.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/13.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import Foundation
import UIKit

class Video{
    
    var image: UIImage
    var title: String
    var channelName: String
    var stats: String
    var likeRatio: Float
    var videoId: String
    
    init(videoId: String, image: UIImage, title: String, channelName: String, stats: String, likeRatio: Float){
        self.image = image
        self.title = title
        self.channelName = channelName
        self.stats = stats
        self.likeRatio = likeRatio
        self.videoId = videoId
    }
    
}

