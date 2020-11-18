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
    var clickedOn:Bool = false
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!

override func viewDidLoad() {
    super.viewDidLoad()
    button1.tag=1;
    button2.tag=2;
    button3.tag=3;
    button4.tag=4;
    downloadJson(URLString: redditURL1)
}
    
@IBAction func choosingURL(sender: UIButton) {
    
    if !clickedOn{
        
        clickedOn = true;
        
        switch sender.tag {
        
         case 1:
            downloadJson(URLString: redditURL1)

         case 2:
            downloadJson(URLString: redditURL2)

         case 3:
            downloadJson(URLString: redditURL3)
            
        case 4:
            downloadJson(URLString: redditURL4)

         default:
            downloadJson(URLString: redditURL1)

         }
        
    }
   
}

//// MARK: - Download Json Method
func downloadJson (URLString: String) {
    if let jsonURL = URL(string: URLString) {
      jsonURL.asyncDownload { [self] data, response, error in
        guard let data = data else {
          // print("URLSession dataTask error:", error ?? "nil")
            return
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            if let dictionary = jsonObject as? [String: Any],
               let dataDic = dictionary["data"] as? [String:Any],
               let results = dataDic["children"] as? [[String: Any]] {
                DispatchQueue.main.async {
                    refreshTableView()
                    parseJson(results: results)
                    let topRow = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
                    clickedOn = false;
                }
            }
        } catch {
           // print("JSONSerialization error:", error)
        }
    }
   }
}
    
func refreshTableView() {
    self.Articles.removeAll()
    self.imagesArray.removeAll()
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
            if let url = NSURL(string: dataDic!["thumbnail"] as? String ?? "") {
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
    destination.selectedImage = imagesArray[indexPath.row]
    }
  }
}

// MARK: - Extension for UITableview DataSource
extension SwiftNewsListViewController: UITableViewDataSource {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Articles.count
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftNewsTableViewCell", for: indexPath) as! SwiftNewsTableViewCell
     let article = Articles[indexPath.row]
     cell.setData(article: article, imagesArray: imagesArray, indexPath: indexPath)
    return cell
  }
}
