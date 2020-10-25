//
//  AboutPageScreen.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/17.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit

class AboutPageScreen: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        webView.loadRequest(URLRequest(url: URL(string: "https://www.speedstor.net")!))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoListVC = Storyboard.instantiateViewController(withIdentifier: "RevealView") as! SWRevealViewController
        
        
        print(videoListVC)
        present(videoListVC, animated: true)
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
