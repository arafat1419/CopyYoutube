//
//  ApiController.swift
//  CopyYoutube
//
//  Created by Arafat on 12/10/23.
//

import Foundation

class ApiController {
    func fetchData(completion: @escaping ([YoutubeModel]?, Error?) -> Void) {
        print("Running")
        if let url = URL(string: "https://a32b-180-247-4-125.ngrok-free.app/ios/youtubeData") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error")
                    completion(nil, error)
                } else if let data = data {
                    do {
                        print("Data")
                        print(data)
                        let decodeData = try JSONDecoder().decode([YoutubeModel].self, from: data)
                        completion(decodeData, nil)
                    } catch {
                        print("Catch")
                        completion(nil, error)
                    }
                }
            }.resume()
        }
    }
}
