//
//  ViewController.swift
//  DispatchSemaphore Example
//
//  Created by Pankaj Kulkarni on 28/09/20.
//

import UIKit

class ViewController: UIViewController {
//    let operationQueue = OperationQueue()
//    let dispatchGroup  = DispatchGroup()
    
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

    @IBAction func syncLoadImagePressed(_ sender: Any) {
        if let anImage = pathOfImages.randomElement(),
           let url = URL(string: anImage){
            imageView.image = syncFetchImage(fromUrl: url)
        }
    }
    
    fileprivate func normalApiCallToLoadImage() {
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
    
    @IBAction func loadImagePressed(_ sender: UIButton) {
        normalApiCallToLoadImage()
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
    
    
//    func fetchImage(fromUrl url: URL) -> UIImage? {
//        print("fetchImage: Entered")
//        var image: UIImage?
//
//        operationQueue.addOperation {
//            self.dispatchGroup.enter()
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//                print("fetchImage: Received response")
//                if let error = error {
//                    print("fetchImage Error:\(error.localizedDescription)")
//                }
//                guard let data = data else {
//                    print("fetchImage No data")
//                    return
//                }
//
//                image = UIImage(data: data)
//                self.dispatchGroup.leave()
//
//            }
//
//            task.resume()
//            _ = self.dispatchGroup.wait(timeout: .distantFuture)
//        }
//
//        print("fetchImage: Returning")
//        return image
//    }
    
    func syncFetchImage(fromUrl url: URL) -> UIImage? {
        var image: UIImage?
        print("fetchImage: Starting")
        
        let (data, response, error) = URLSession.shared.performSynchronously(url: url)
        print("fetchImage: Received response")
        if let error = error {
            print("fetchImage Error:\(error.localizedDescription)")
        }
        guard let imageData = data else {
            print("fetchImage No data")
            return nil
        }
        
        image = UIImage(data: imageData)
        print("fetchImage: returning image")
        return image
    }
        
    

}


extension URLSession {

    func performSynchronously(url: URL) -> (data: Data?, response: URLResponse?, error: Error?) {
        let semaphore = DispatchSemaphore(value: 0)

        var data: Data?
        var response: URLResponse?
        var error: Error?

        let task = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()

        return (data, response, error)
    }
}
