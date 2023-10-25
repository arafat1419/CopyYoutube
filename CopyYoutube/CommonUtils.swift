//
//  CommonUtils.swift
//  CopyYoutube
//
//  Created by Arafat on 12/10/23.
//

import Foundation
import UIKit

class CommonUtils {
    func formatWatchCount(_ count: Int) -> String {
        let thousand = 1000
        let million = thousand * thousand
        let billion = million * thousand
        
        if count < thousand {
            return "\(count)"
        } else if count < million {
            let kCount = Double(count) / Double(thousand)
            return String(format: "%.1fK", kCount)
        } else if count < billion {
            let mCount = Double(count) / Double(million)
            return String(format: "%.1fM", mCount)
        } else {
            let bCount = Double(count) / Double(billion)
            return String(format: "%.1fB", bCount)
        }
    }

    func timeAgoString(from date: Date?) -> String {
        if (date == nil) { return "" }
        
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfMonth, .month, .year], from: date!, to: now)
        
        if let year = components.year, year >= 1 {
            return year == 1 ? "1 year ago" : "\(year) years ago"
        }
        
        if let month = components.month, month >= 1 {
            return month == 1 ? "1 month ago" : "\(month) months ago"
        }
        
        if let week = components.weekOfMonth, week >= 1 {
            return week == 1 ? "1 week ago" : "\(week) weeks ago"
        }
        
        if let day = components.day, day >= 1 {
            return day == 1 ? "1 day ago" : "\(day) days ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
        }
        
        if let second = components.second, second >= 1 {
            return second == 1 ? "1 second ago" : "\(second) seconds ago"
        }
        
        return "Just now"
    }

    func dateFromString(_ dateString: String?) -> Date? {
        if (dateString == nil) {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return dateFormatter.date(from: dateString!)
    }
    
    func fetchImage(_ urlString: String, completion: @escaping(UIImage?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    completion(image, nil)
                }
            }.resume()
        }
    }
    
    func setupCircleImageView(_ image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
}
