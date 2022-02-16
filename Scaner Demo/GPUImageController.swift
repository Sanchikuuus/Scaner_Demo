//
//  GPUImageController.swift
//  Scaner Demo
//
//  Created by Sashko Shel on 15.02.2022.
//

import UIKit
import GPUImage

class GPUImageController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pixellateSlider: UISlider!
    
    var imageData: UIImage?
    var filter = GPUImagePixellateFilter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (imageData != nil) {
            filter.fractionalWidthOfAPixel = CGFloat(pixellateSlider.value)
            imageView.image = filter.image(byFilteringImage: imageData)
        }
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    @IBAction func repixellateImage(_ sender: Any) {
        filter.fractionalWidthOfAPixel = CGFloat(pixellateSlider.value)
        imageView.image = filter.image(byFilteringImage: imageData)
    }
}
