//
//  OpenCVController.swift
//  Scaner Demo
//
//  Created by Sashko Shel on 14.02.2022.
//

import UIKit

class OpenCVController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageData: UIImage?
    var grayImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (imageData != nil) {
            let rotatedImage = OpenCVWrapper.rotateCW(self.imageData!)
            self.grayImage = OpenCVWrapper.toGray(rotatedImage)
            imageView.image = self.grayImage
        }
        
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @IBAction func switchImage(_ sender: Any) {
        if (imageView.image == imageData) {
            imageView.image = self.grayImage
        } else {
            imageView.image = self.imageData
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GPUImageSegue" {
            let GPUImageController = segue.destination as! GPUImageController
            GPUImageController.imageData = self.imageView.image
        }
    }
    
    @IBAction func nextFilter(_ sender: Any) {
        self.performSegue(withIdentifier: "GPUImageSegue", sender: nil) //must be in main dispatch
    }
}
