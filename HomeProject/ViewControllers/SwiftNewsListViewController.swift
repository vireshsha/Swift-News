//
//  SwiftNewsViewController.swift
//  HomeProject
//
//  Created by Viresh Kumar Sharma on 2020-11-06.
//

import UIKit

class SwiftNewsListViewController: UIViewController {
    
  @IBOutlet weak var tableView: UITableView!
   var Articles = [Article]()
   var imagesArray = [UIImage?]()

override func viewDidLoad() {
       super.viewDidLoad()
       downloadJson()
}

// MARK: - Download Json Method
func downloadJson() {
    if let jsonURL = URL(string: redditURL) {
      jsonURL.asyncDownload { [self] data, response, error in
        guard let data = data else {
           //print("URLSession dataTask error:", error ?? "nil")
            return
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            if let dictionary = jsonObject as? [String: Any],
               let dataDic = dictionary["data"] as? [String:Any],
               let results = dataDic["children"] as? [[String: Any]] {
                DispatchQueue.main.async {
                    parseJson(results: results)
                }
            }
        } catch {
           // print("JSONSerialization error:", error)
      }
    }
  }
}

// MARK: - Json Parsing Method
func parseJson(results: [[String: Any]])  {
  results.forEach {child in
       let dataDic = child["data"] as? [String:Any]
       do{
        let jData = try JSONSerialization.data(withJSONObject: dataDic!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let articleJson = try JSONDecoder().decode(Article.self, from:jData)
        self.Articles.append(articleJson)
        
        // creating a blank image for not received URLS from JSON
        var image = UIImage(named: "placeholder.jpg")
           if let url = NSURL(string: dataDic!["thumbnail"] as! String) {
               if (UIApplication.shared.canOpenURL(url as URL)) {
                   let imageUrl = URL(string: dataDic!["thumbnail"] as! String)
                     // print("imageURL= \(String(describing: imageUrl))")
                    let imageData = try Data(contentsOf: imageUrl!)
                    image = UIImage(data: imageData)
                }
              }
        self.imagesArray.append(image)
       // print("imagesArray = \(self.imagesArray)")
        }catch let error as NSError  {
             print("error:", error)
         }
       }
   // print("Articles-Array= \(self.Articles)")
   self.tableView.isHidden = false;
   self.tableView.reloadData()
}

// MARK: - Prepare Segue Method
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  if let destination = segue.destination as? SwiftNewsDetailViewController,
    let indexPath = tableView.indexPathForSelectedRow {
    destination.selectedArticle = Articles[indexPath.row]
    destination.selectedImage = imagesArray [indexPath.row]
    }
  }
}
    
// MARK: - Extension for download json
extension URL {
    func asyncDownload(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: self, completionHandler: completion)
        .resume()
    }
}

// MARK: - Extension for UITableview DataSource
extension SwiftNewsListViewController: UITableViewDataSource {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(Articles.count>0){
        return Articles.count
    }
    return 0;
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftNewsTableViewCell", for: indexPath) as! SwiftNewsTableViewCell
     let article = Articles[indexPath.row]
     cell.setData(article: article, imagesArray: imagesArray, indexPath: indexPath)
    return cell
  }
}
