//
//  DetailViewController.swift
//  CopyYoutube
//
//  Created by Arafat on 12/10/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var btnSubscribe: UIButton!
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var txtTitle: UILabel!
    @IBOutlet var txtDesc: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var txtName: UILabel!
    
    var youtubeModel: YoutubeModel? = nil
    
    private var isSubscribe = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
    }
    
    @IBAction func setSubscribed(_ sender: UIButton) {
        isSubscribe = !isSubscribe
        btnSubscribe.setTitle(isSubscribe ? "Unsubscribe" : "Subscribe", for: .normal)
    }
    
    private func setData() {
        if let youtubeData = youtubeModel {
            let channelName = youtubeData.channelName ?? ""
            let watchCount = CommonUtils().formatWatchCount(youtubeData.watchCount ?? 0)
            let uploadDate = CommonUtils().timeAgoString(from: CommonUtils().dateFromString(youtubeData.uploadDate))
            
            CommonUtils().fetchImage(youtubeData.urlThumbnail ?? "") { image, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let image = image {
                    DispatchQueue.main.async {
                        self.imgThumbnail.image = image
                    }
                }
            }
            
            CommonUtils().fetchImage(youtubeData.urlProfile ?? "") { image, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let image = image {
                    DispatchQueue.main.async {
                        self.imgProfile.image = image
                        CommonUtils().setupCircleImageView(self.imgProfile)
                    }
                }
            }
            
            txtTitle.text = youtubeData.title
            txtDesc.text = "\(watchCount) views | \(uploadDate)"
            txtName.text = channelName
        }
    }
}
