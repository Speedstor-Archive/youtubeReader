//
//  WebLoginScreen.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/17.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit
import CoreData

class WebLoginScreen: UIViewController {
    @IBOutlet var webView: UIWebView!
    @IBOutlet var backButton: UIButton!
    
    
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        do {
//            let htmlString = try String(contentsOf: URL(string: "https://www.youtube.com/logout")!, encoding: .ascii)
//        } catch let error {
//            print("Error: ](error)")
//        }
        
        
        backButton.setTitleColor(.lightGray, for: .normal)
        
        if let _ = url{
            
        }else{
            url = "https://accounts.google.com/ServiceLogin"
        }
        
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        webView.loadRequest(URLRequest(url: URL(string: "https://www.youtube.com/feed/account")!))
        
        backButton.setTitleColor(.init(red: 79/255, green: 146/255, blue: 1, alpha: 1), for: .normal)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        var htmlString: String = ""

        do {
            htmlString = try String(contentsOf: URL(string: "https://www.youtube.com")!, encoding: .ascii)


        } catch let error {
            print("Error: \(error)")
        }


        if(htmlString.contains("https://accounts.google.com/ServiceLogin")){

        }else{
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext

            let entity = NSEntityDescription.entity(forEntityName: "Login", in: managedContext)!
            let item = NSManagedObject(entity: entity, insertInto: managedContext)

            item.setValue(true, forKey: "loggedIn")

            do{
                try managedContext.save()

            } catch let error as NSError {
                print("Failed to save login Status:  --  ", error)
            }
        }


        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoListVC = Storyboard.instantiateViewController(withIdentifier: "RevealView") as! SWRevealViewController


        print(videoListVC)
        present(videoListVC, animated: true)

        
    }
    
    

}
