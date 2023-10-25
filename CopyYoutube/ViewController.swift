//
//  ViewController.swift
//  CopyYoutube
//
//  Created by Arafat on 11/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    let controller = ApiController()
    var youtubeDatas: [YoutubeModel] = []
    
    @IBOutlet var youtubeTableView: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        youtubeTableView.dataSource = self
        youtubeTableView.delegate = self
        youtubeTableView.register(UINib(nibName: "YoutubeTableViewCell", bundle: nil), forCellReuseIdentifier: "YoutubeCell")
        youtubeTableView.refreshControl = refreshControl
        
        navigationBarConfig()
        
        loadingIndicator.transform = CGAffineTransformMakeScale(2, 2)
        loadingIndicator.startAnimating()
        setTableData()
    }
    
    @objc func refreshData() {
        // Fetch new data
        setTableData()
    }
    
    private func navigationBarConfig() {
        if let originalImage = UIImage(named: "IcYoutube") {
            let resizedImage = resizeImage(originalImage, targetSize: CGSize(width: 80, height: 64))
            let imageView = UIImageView(image: resizedImage)
            let customBarButtonItem = UIBarButtonItem(customView: imageView)
            
            navigationItem.leftBarButtonItem = customBarButtonItem
        }
        
    }
    
    private func setTableData() {
        controller.fetchData { (data, error) in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Failed to load data. Please try again later.")
                    self.loadingIndicator.stopAnimating()
                    self.setTableData()
                    self.youtubeTableView.refreshControl?.endRefreshing()
                }
            } else if let data = data {
                self.youtubeDatas = data
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.youtubeTableView.reloadData()
                    self.youtubeTableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: targetSize)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeCell", for: indexPath) as? YoutubeTableViewCell {
            let youtubeData = youtubeDatas[indexPath.row]
            
            
            let channelName = youtubeData.channelName ?? ""
            let watchCount = CommonUtils().formatWatchCount(youtubeData.watchCount ?? 0)
            let uploadDate = CommonUtils().timeAgoString(from: CommonUtils().dateFromString(youtubeData.uploadDate))
            
            CommonUtils().fetchImage(youtubeData.urlThumbnail ?? "") { image, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let image = image {
                    DispatchQueue.main.async {
                        cell.imgThumbnail.image = image
                    }
                }
            }
            
            CommonUtils().fetchImage(youtubeData.urlProfile ?? "") { image, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let image = image {
                    DispatchQueue.main.async {
                        cell.imgProfile.image = image
                        CommonUtils().setupCircleImageView(cell.imgProfile)
                    }
                }
            }
            
            cell.txtTitle.text = youtubeData.title
            cell.txtDesc.text = "\(channelName) | \(watchCount) views | \(uploadDate)"
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "moveToDetail", sender: youtubeDatas[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        if segue.identifier == "moveToDetail" {
            if let detaiViewController = segue.destination as? DetailViewController {
                detaiViewController.youtubeModel = sender as? YoutubeModel
            }
        }
    }
}
