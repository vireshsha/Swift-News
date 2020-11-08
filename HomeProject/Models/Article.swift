//
//  SwiftNews.swift
//  HomeProject
//
//  Created by Viresh Kumar Sharma on 2020-11-06.
//

import Foundation

struct Article: Codable {
    let title: String?, thumbnail: String?, selftext: String?
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      title = try container.decodeIfPresent(String.self, forKey: .title)
      thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
      selftext = try container.decodeIfPresent(String.self, forKey: .selftext)
    }
}


