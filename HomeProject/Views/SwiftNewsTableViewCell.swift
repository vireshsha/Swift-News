//
//  SwiftNewsListViewControllerCell.swift
//  HomeProject
//
//  Created by Viresh Kumar Sharma on 2020-11-06.
//

import UIKit

class SwiftNewsTableViewCell: UITableViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var articleImageView: UIImageView!

// MARK: - Setting Data on Cell
func setData(article: Article, imagesArray: [UIImage?], indexPath: IndexPath) {
        self.selectionStyle = .none
        title.text = article.title
    if(imagesArray.count>0){
         articleImageView.image = imagesArray[indexPath.row]
        }
    }
}
