//
//  ImageListViewController.swift
//  DispatchSemaphore Example
//
//  Created by Pankaj Kulkarni on 28/09/20.
//

import UIKit

class ImageListViewController: UIViewController {
    
    let pathOfImages = [
        "https://images.dog.ceo/breeds/papillon/n02086910_4505.jpg",
        "https://images.dog.ceo/breeds/clumber/n02101556_984.jpg",
        "https://images.dog.ceo/breeds/bullterrier-staffordshire/n02093256_5139.jpg",
        "https://images.dog.ceo/breeds/terrier-dandie/n02096437_1926.jpg",
        "https://images.dog.ceo/breeds/finnish-lapphund/mochilamvan.jpg",
        "https://images.dog.ceo/breeds/bluetick/n02088632_3531.jpg",
        "https://images.dog.ceo/breeds/weimaraner/n02092339_4169.jpg"
    ]
    
    var images = [UIImage]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = 225
    }
    
    @IBAction func loadImagesPressed(_ sender: UIButton) {
        images.removeAll()
        tableView.reloadData()
        
        for imagePath in pathOfImages.shuffled() {
            let url = URL(string: imagePath)!
            
//            DispatchQueue.global(qos: .default).async {
                print("Fetching image: \(imagePath)")
                let (data, response, error) = URLSession.shared.performSynchronously(url: url)
                
                if let imageData = data,
                   let image = UIImage(data: imageData) {
                    self.images.append(image)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
//            }
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell {
            imageCell.dogImageView.image = images[indexPath.row]
            return imageCell
        }
        
        return UITableViewCell()
    }
}
