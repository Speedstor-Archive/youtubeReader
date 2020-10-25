//
//  MenuCell.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/15.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var menuImg: UIImageView!
    @IBOutlet weak var menuItem: UILabel!
    @IBOutlet weak var menuVideos: UILabel!
    @IBOutlet weak var menuViews: UILabel!
    @IBOutlet weak var menuSubs: UILabel!
    
    func setMenu(menu: Menu){
        menuImg.image = menu.menuImg
        menuItem.text = menu.menuItem
        menuVideos.text = menu.menuVideos
        menuViews.text = menu.menuViews
        menuSubs.text = menu.menuSubs
    }

}
