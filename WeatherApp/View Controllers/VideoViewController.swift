//
//  VideoViewController.swift
//  WeatherApp
//
//  Created by James Furlong on 4/5/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {
    
    private var player : AVQueuePlayer!
    private var playerLayer : AVPlayerLayer!
    private var playerItem : AVPlayerItem!
    private var playerLooper : AVPlayerLooper!
    var weather : String!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func playVideo(weather: String) {
        let path = Bundle.main.path(forResource: weather, ofType: "mp4")
        let pathURL = URL(fileURLWithPath: path!)
        let duration = Int64(((Float64(CMTimeGetSeconds(AVAsset(url: pathURL).duration)) * 10.0) - 1) / 10.00)
        
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerItem = AVPlayerItem(url: pathURL)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem, timeRange: CMTimeRange(start: kCMTimeZero, end: CMTimeMake(duration, 1)))
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.frame = view.layer.bounds
        view.layer.insertSublayer(playerLayer, at: 1)
        player.play()
    }
    
    func loadWeatherMain() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
