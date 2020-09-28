//
//  ViewController.swift
//  DispatchSemaphore Example
//
//  Created by Pankaj Kulkarni on 28/09/20.
//

import UIKit

class ViewController: UIViewController {
    
    let pathOfImages = [
        "https://images.dog.ceo/breeds/papillon/n02086910_4505.jpg",
        "https://images.dog.ceo/breeds/clumber/n02101556_984.jpg",
        "https://images.dog.ceo/breeds/bullterrier-staffordshire/n02093256_5139.jpg",
        "https://images.dog.ceo/breeds/terrier-dandie/n02096437_1926.jpg",
        "https://images.dog.ceo/breeds/finnish-lapphund/mochilamvan.jpg",
        "https://images.dog.ceo/breeds/bluetick/n02088632_3531.jpg",
        "https://images.dog.ceo/breeds/weimaraner/n02092339_4169.jpg"
    ]

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func loadImagePressed(_ sender: UIButton) {
        imageView.image = nil
        if let anImage = pathOfImages.randomElement(),
           let url = URL(string: anImage){
            
            print("Selected image is: \(anImage)")
            
            requestImageFile(url: url) { (image, error) in
                
                guard error == nil else {
                    print("Error fetching image: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
                
            }
        }
    }
    func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
            
        }
        
        task.resume()
    }
    
    

}

