//
//  VideoListScreen.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/13.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit
import CoreData

class VideoListScreen: UIViewController{
    
    var channelUrl: String?
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    var videos: [Video] = []
    let youtube: Youtube = Youtube(feedParser: FeedParser())
    
    var ifloggedin: [NSManagedObject] = []
    var loggedin = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        
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
        
        var list: [[[String]]] = []
        if(loggedin){
            list = youtube.getRecommended()
        }else{
            list = youtube.getTrending()
        }
        videos = createArray(list: list)
        
        
        
        
//        set delegate
        tableView.delegate = self
        tableView.dataSource = self
    }
    
        
    func reloadContent(channelUrl: String){
        let list = youtube.getRecommended()
        videos = createArray(list: list)
        
        
        tableView.reloadData()
    }
    
    
    func sideMenus(){
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 340
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let transcriptVC = Storyboard.instantiateViewController(withIdentifier: "TranscriptView") as! TranscriptView
        
        
        
        transcriptVC.image = videos[indexPath.row].image
        transcriptVC.videoTitle = videos[indexPath.row].title
        transcriptVC.channelName = videos[indexPath.row].channelName
        transcriptVC.stats = videos[indexPath.row].stats
        transcriptVC.likeRatio = videos[indexPath.row].likeRatio
        transcriptVC.videoId = videos[indexPath.row].videoId
        
        
        self.navigationController?.pushViewController(transcriptVC, animated: true)
    }
        

    
    
    
    func createArray(list: [[[String]]]) -> [Video]{
        var tempVideos: [Video] = []
        
        
        print("is this running -- \(list.count)")
            //setupVariables ----
            //setupImage
        if(list.count > 0){
            for i in 0...list.count-1{
                if(list[i].count > 0){
                    for a in 0...list[i].count-1{
                        if(list[i][a].count == 1){
                                tempVideos.append(Video(videoId: "",image: #imageLiteral(resourceName: "480px-Blank_square.svg"), title: list[i][0][0], channelName: "", stats: "speedz", likeRatio: 0.7))
                        }else{
                            let url = URL(string: list[i][a][0])
                            let data = try? Data(contentsOf: url!)
                            var img = UIImage(data: data!)!
                            
                            img = cropToBounds(image: img, width: 480, height: 270)
                        
                            tempVideos.append(Video(videoId: list[i][a][1],image: img, title: list[i][a][2], channelName: list[i][a][3], stats: list[i][a][4], likeRatio: 1))
                        }
                        
                    }
                }
            }
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
}



extension VideoListScreen: UITableViewDataSource, UITableViewDelegate{
    
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
