//
//  ViewController.swift
//  E-Commerce App
//
//  Created by Mac on 22/05/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var productTableView : UITableView!

    // MARK: Varaibles
    var productArray: [Product] = []
    var ratingArray: [Rating] = []
    
    
    
    // MARK: VC LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        fetchDataFromStoreAPI()
    }
    
    // MARK: Fetch Data Method
    func fetchDataFromStoreAPI(){
        
        let urlString = "https://fakestoreapi.com/products"
        guard let url = URL(string: urlString) else { return }
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            if let error = error {
            } else {
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data
                else {
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
                    
                    for dictionary in jsonObject {
                        let title = dictionary["title"] as? String
                        let price = dictionary["price"] as? Double
                        let description = dictionary["description"] as? String
                        let category = dictionary["category"] as? String
                        let image = dictionary["image"] as? String
                        let rating = dictionary["rating"] as? [String: Any]
                        let rate = rating?["rate"] as? Double
                        let count = rating?["count"] as? Int
                        
                        let productData = Product(title: title ?? "", price: price ?? 0, description: description ?? "", category: category ?? "", image: image ?? "", rate: rate ?? 0, count: count ?? 0)
                        
                        self.productArray.append(productData)
                        
                        DispatchQueue.main.async {
                            self.productTableView.reloadData()
                        }
                    }
                } catch {
                    print("Error:\(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
}



extension ViewController {
    
    func backData() {
        
        guard let secVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
            return
        }
        
    }
}


// MARK: UITableViewDataSource Protocol
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let productCell = self.productTableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductDetailTableViewCell else {
            return UITableViewCell()
        }
        productCell.titleLable.text = productArray[indexPath.row].title
        guard let imageURl = URL(string: productArray[indexPath.row].image) else {
            return productCell
        }
        productCell.productImage.downloadImage(from: imageURl)
        productCell.ratingLable.text = String("Rating:\(productArray[indexPath.row].rate)")
        
        return productCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let secVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
            return
        }
        secVC.titleContainer = ("title:\(productArray[indexPath.row].title)")
        secVC.descriptionContainer = ("description:\(productArray[indexPath.row].description)")
        secVC.ratingContainer = String(productArray[indexPath.row].rate)
        self.navigationController?.pushViewController(secVC, animated: true)
        
        secVC.passDataClosure = {(rating) in
            
            self.productArray[indexPath.row].rate = Double(rating!) ?? 0
            self.productTableView.reloadData()
        }
        
    }
}


// MARK: UITableViewDataSource Protocol
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}


// MARK: Download Image Method
extension UIImageView {
    func downloadImage(from url: URL){
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { data, response, error in
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
    }
}
