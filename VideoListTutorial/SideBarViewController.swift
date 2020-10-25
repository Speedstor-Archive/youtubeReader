//
//  SideBarViewController.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/15.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit
import CoreData

class SideBarViewController: UIViewController {
    
    var menus: [Menu] = []
    @IBOutlet weak var menuTableView: UITableView!
    let feedParser: FeedParser = FeedParser();
    
    var channelIdList: [String] = []
    var exsistChannels = false
    
    let youtube: Youtube = Youtube(feedParser: FeedParser());
    
    
    var ifloggedin: [NSManagedObject] = []
    var loggedin = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Login")
        do{
            ifloggedin = try managedContext.fetch(fetchRequest)
        }catch let error as NSError {
            print("Failed to fetch stored data", error)
        }
        
        
        print("The app is currently -------  --- \(ifloggedin.count)")
        if(ifloggedin.count > 0){
            loggedin = true
            
            print("The app is currently -------  --- \(loggedin)")
        }else {
            loggedin = false
        }
        
        
        menus = createArray()
        
        //setMenu
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch(indexPath.row){
        case 0:
            //emtpy | swift sucks
            
            break;
        case 4:
            //empty
            
            break;
        case 1:
            //home
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let videoListVC = Storyboard.instantiateViewController(withIdentifier: "RevealView") as! SWRevealViewController
            print(videoListVC)
            present(videoListVC, animated: true)
            
            break;
        case 2:
            //search
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let videoListVC = Storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as! SearchNavigationController
            
            print(videoListVC)
            present(videoListVC, animated: true)
            break;
        case 3:
            //login | Logout
            if(loggedin){
                do {
                    let htmlString = try String(contentsOf: URL(string: "https://www.youtube.com/logout")!, encoding: .ascii)
                } catch let error {
                    print("Logout Error: \(error)")
                }
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                let managedContext = appDelegate.persistentContainer.viewContext
                managedContext.delete(ifloggedin[0] as NSManagedObject)
                
                loggedin = false
                menus = createArray()
                tableView.reloadData()
            }else{
                let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                let videoListVC = Storyboard.instantiateViewController(withIdentifier: "WebLoginScreen") as! WebLoginScreen
                
                videoListVC.url = "https://accounts.google.com/ServiceLogin"
                
                print(videoListVC)
                present(videoListVC, animated: true)
            }
            
            break;
        default:
            //videoList
            if(exsistChannels){
                let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    //            let videoListVC = Storyboard.instantiateViewController(withIdentifier: "ChannelListScreen") as! ChannelListScreen
                let videoListVC = Storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
                
                videoListVC.channelUrl = "channel/\(storedChannels[indexPath.row-5].value(forKeyPath: "channels") as! String)"
                
                print(videoListVC)
                
                //self.navigationController?.pushViewController(videoListVC, animated: true)
                present(videoListVC, animated: true)
            }
            break;
        }
        
    }
    
    @IBAction func aboutMeButtonPressed(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoListVC = Storyboard.instantiateViewController(withIdentifier: "AboutPageScreen") as! AboutPageScreen
        
        
        print(videoListVC)
        present(videoListVC, animated: true)
    }
    
    var storedChannels: [NSManagedObject] = []
    func fetching(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Store")
        do{
            storedChannels = try managedContext.fetch(fetchRequest)
        }catch let error as NSError {
            print("Failed to fetch stored data", error)
        }
    }
    
    //get from stored data
    func createArray() -> [Menu]{
        var returnVar: [Menu] = []
        returnVar.append(Menu(menuImg: #imageLiteral(resourceName: "480px-Blank_square.svg"), menuItem: "", menuViews: "", menuVideos: "", menuSubs: ""))
        returnVar.append(Menu(menuImg: #imageLiteral(resourceName: "101390-200"), menuItem: "Home", menuViews: "", menuVideos: "", menuSubs: ""))
        returnVar.append(Menu(menuImg: #imageLiteral(resourceName: "101791-200"), menuItem: "Search for Channels", menuViews: "", menuVideos: "", menuSubs: ""))
        
        //login or logout
        if(loggedin){
            returnVar.append(Menu(menuImg: #imageLiteral(resourceName: "Image-2"), menuItem: "Logout", menuViews: "", menuVideos: "", menuSubs: ""))
        }else{
            returnVar.append(Menu(menuImg: #imageLiteral(resourceName: "Image-2"), menuItem: "Login", menuViews: "", menuVideos: "", menuSubs: ""))
        }
        
        returnVar.append(Menu(menuImg: #imageLiteral(resourceName: "480px-Blank_square.svg"), menuItem: "", menuViews: "", menuVideos: "", menuSubs: ""))
        
        //get channelid list **
        fetching()
        if(storedChannels.count > 0){
            for i in 0...storedChannels.count-1{
                //trancribe
                let details = youtube.getDetailsFromId(channelId: storedChannels[i].value(forKeyPath: "channels") as! String)
                
                returnVar.append(Menu(menuImg: details.1, menuItem: details.0, menuViews: "\(shortenNumber(original: details.3)) views", menuVideos: "\(shortenNumber(original: details.4))", menuSubs: "\(shortenNumber(original: details.2)) subs"))
            }
            exsistChannels = true
        }else{
            returnVar.append(Menu(menuImg: #imageLiteral(resourceName: "Add-circular-button-thin-symbol.svg"), menuItem: "Search to Add Channels", menuViews: "", menuVideos: "", menuSubs: ""))
            exsistChannels = false
        }
        
        
        return returnVar
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
 

}



extension SideBarViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    //    run everytime a cell appears
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = menus[indexPath.row]

        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell

        cell.setMenu(menu: menu)

        return cell
    }

}
