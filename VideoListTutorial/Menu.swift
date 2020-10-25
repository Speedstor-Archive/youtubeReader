//
//  Menu.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/15.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import Foundation

class Menu {
    var menuImg: UIImage
    var menuItem: String
    var menuViews: String
    var menuVideos: String
    var menuSubs: String
    
    init(menuImg: UIImage, menuItem: String, menuViews: String, menuVideos: String, menuSubs: String){
        self.menuImg = menuImg
        self.menuItem = menuItem
        self.menuViews = menuViews
        self.menuVideos = menuVideos
        self.menuSubs = menuSubs
    }
}
