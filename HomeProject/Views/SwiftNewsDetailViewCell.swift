//
//  SwiftNewsDetailViewCell.swift
//  HomeProject
//
//  Created by Viresh Kumar Sharma on 2020-11-08.
//

import UIKit

class SwiftNewsDetailViewCell: UITableViewCell {
   @IBOutlet weak var articleImageView: UIImageView!
   @IBOutlet weak var body: UILabel!

// MARK: - Setting Data on Cell
func setData(bodyText: String?, selectedImage: UIImage?) {
        self.selectionStyle = .none
        self.body?.text = bodyText
        self.articleImageView?.image=selectedImage
    }
}
