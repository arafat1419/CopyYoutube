//
//  YoutubeModel.swift
//  CopyYoutube
//
//  Created by Arafat on 12/10/23.
//

import Foundation
import UIKit

struct YoutubeModel: Codable {
    let id: Int?
    let title: String?
    let urlThumbnail: String?
    let urlProfile: String?
    let channelName: String?
    let watchCount: Int?
    let uploadDate: String?
}
