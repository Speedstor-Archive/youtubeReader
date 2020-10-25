//
//  SearchNavigationController.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/16.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit

class SearchNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = Storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        print(controller)
        
        self.pushViewController(controller, animated: true)

        // Do any additional setup after loading the view.
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
