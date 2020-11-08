//
//  SwiftNewsDetailViewController.swift
//  HomeProject
//
//  Created by Viresh Kumar Sharma on 2020-11-08.
//

import UIKit

class SwiftNewsDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var selectedArticle: Article!
    var selectedImage: UIImage?
    
override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedArticle.title
    }
}

// MARK: - Extension for UITableview DataSource
extension SwiftNewsDetailViewController: UITableViewDataSource {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1;
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftNewsDetailViewCell", for: indexPath) as! SwiftNewsDetailViewCell
    cell.setData(bodyText: selectedArticle.selftext, selectedImage: selectedImage)
    return cell
  }
}
