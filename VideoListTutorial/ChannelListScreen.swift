//
//  VideoListScreen.swift
//  VideoListTutorial
//
//  Created by jackson on 2019/4/13.
//  Copyright © 2019 Speedstor. All rights reserved.
//

import UIKit
import CoreData

class ChannelListScreen: UIViewController {
    
    var channelUrl: String?
    var fromSearch: Bool?
    var channelId: String = ""
    
    var storedChannels: [NSManagedObject] = []
    
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var addChannelButtonViewHeightContranst: NSLayoutConstraint!
    @IBOutlet var addChannelButtonView: UIView!
    @IBOutlet var addChannelButton: UIButton!
    @IBOutlet var channelImg: UIImageView!
    @IBOutlet var channelNameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var videos: [Video] = []
    let feedParser:FeedParser = FeedParser();
    let youtube: Youtube = Youtube(feedParser: FeedParser())
    
    var storedChannelIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(channelUrl == nil){
            channelUrl = "https://www.youtube.com/user/LinusTechTips"
        }
        
        addChannelButtonViewHeightContranst.constant = CGFloat(0)
        addChannelButton.isHidden = true
        
        channelId = feedParser.getChannelId(channelUrl: channelUrl!)
        let channelName = youtube.getDetailsFromId(channelId: channelId)
//        let channelRssUrl = feedParser.getChannelRss(channelUrl: channelUrl!)
        let channelRssUrl = feedParser.getChannelRss(channelUrl: channelUrl!)
        //get List
        let list = feedParser.getVideoList(rssUrl: channelRssUrl)
        
        
        if let _ = fromSearch{
            var alreadyHave = false
            
            fetching()
            if(storedChannels.count > 0){
                for i in 0...storedChannels.count-1{
                    if(channelId == storedChannels[i].value(forKeyPath: "channels") as! String){
                        alreadyHave = true
                        storedChannelIndex = i
                    }
                }
            }
            
            if(alreadyHave){
                addChannelButtonViewHeightContranst.constant = CGFloat(0)
                addChannelButton.isHidden = true
                removeButton.isHidden = false
            }else{
                addChannelButtonViewHeightContranst.constant = CGFloat(58)
                addChannelButton.isHidden = false
                removeButton.isHidden = true
            }
        }else{
            fetching()
            for i in 0...storedChannels.count-1{
                if(channelId == storedChannels[i].value(forKeyPath: "channels") as! String){
                    storedChannelIndex = i
                }
            }
            
            addChannelButtonViewHeightContranst.constant = CGFloat(0)
            addChannelButton.isHidden = true
            removeButton.isHidden = false
        }
        
        channelImg.image = channelName.1
        channelNameLabel.text = channelName.0
        //blur Image
        let darkBlur = UIBlurEffect(style: .regular)
        // 2
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = channelImg.bounds
        blurView.alpha = 0.95
        // 3
        channelImg.addSubview(blurView)
        
        videos = createArray(list: list)
        
//        set delegate
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(storedChannels[storedChannelIndex] as NSManagedObject)
//        self.save(nil)
        
        
        addChannelButtonViewHeightContranst.constant = CGFloat(58)
        addChannelButton.isHidden = false
        removeButton.isHidden = true
    }
    
    @IBAction func addChannelButtonPress(_ sender: Any) {
        
//        let appDelegate = UIApplication.shared.delegate
//        let managedContext = appDelegate.persistentContainer.ViewContext
        
        let alert = UIAlertController(title: "Add Channel to Sidebar", message: "", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Add", style: .default){ [unowned self] action in
//            guard let textField = alert.textFields?.first, let itemToAdd = textField.text else {return}
            self.save(self.channelId)
            
            
            self.addChannelButtonViewHeightContranst.constant = CGFloat(0)
            self.addChannelButton.isHidden = true
            self.removeButton.isHidden = false
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
//        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func fetching(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Store")
        do{
            storedChannels = try managedContext.fetch(fetchRequest)
        }catch let error as NSError {
            print("Failed to fetch stored data", error)
        }
    }
    
    func save(_ itemName: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Store", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        
        item.setValue(itemName, forKey: "channels")
        
        
        do{
            try managedContext.save()
            
        } catch let error as NSError {
            print("Failed to save channel", error)
        }
    }
    
    
    
    
    @IBAction func backButton(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoListVC = Storyboard.instantiateViewController(withIdentifier: "RevealView") as! SWRevealViewController
        
        
        print(videoListVC)
        
        //self.navigationController?.pushViewController(videoListVC, animated: true)
        present(videoListVC, animated: true)
    }
    
    func reloadContent(channelUrl: String){
        let channelRssUrl = feedParser.getChannelRss(channelUrl: channelUrl)
        //get List
        let list = feedParser.getVideoList(rssUrl: channelRssUrl)
        videos = createArray(list: list)
        
        tableView.reloadData()
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
        

    
    
    
    func createArray(list: [[String]]) -> [Video]{
        var tempVideos: [Video] = []
        
        var img: UIImage = #imageLiteral(resourceName: "beginner-first-app")
        
        var url = URL(string: "https://i3.ytimg.com/vi/Jd2GOHfSS5o/hqdefault.jpg")
        var data = try? Data(contentsOf: url!)
        
        
        for i in 0...list.count-1{
            //setupVariables ----
            //setupImage
            url = URL(string: feedParser.subString(original: list[i][10], from: "\"", to: "\" w"))
            data = try? Data(contentsOf: url!)
            img = UIImage(data: data!)!
            img = cropToBounds(image: img, width: 480, height: 270)
            
            let views = list[i][13]
            let likeString = feedParser.subString(original: list[i][12], from: "average=\"", to: "\"")
            let likeRatio:Float = Float(likeString)!/5
            
            
            let video = Video(videoId: list[i][1],image: img, title: list[i][3], channelName: list[i][4], stats: "\(shortenNumber(original: views)) views . 1 year ago", likeRatio: likeRatio);
            tempVideos.append(video);
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



extension ChannelListScreen: UITableViewDataSource, UITableViewDelegate{
    
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
