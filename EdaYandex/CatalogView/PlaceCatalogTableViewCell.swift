//
//  PlaceCatalogTableViewCell.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 21.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import UIKit
import SDWebImage
import Nuke
import Kingfisher

class PlaceCatalogTableViewCell: UITableViewCell {

    var urlString: String?
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    public func configure(place: Place, loaderLibrary: LoaderLibrary) {
        
        // name
        
        self.nameLabel?.text = place.name
        
        // image
        
        if let url = place.picture?.uri {
            urlString = url
                .replacingOccurrences(of: "{h}", with: "450")
                .replacingOccurrences(of: "{w}", with: "600")
            
            if let imageUrl = URL(string: "https://eda.yandex\(urlString ?? "")") {
                
                switch loaderLibrary {
                case .SDWebImage:
                    loadWithSDWebImage(imageUrl: imageUrl)
                case .Nuke_:
                    loadWithSDWebNuke(imageUrl: imageUrl)
                case .Kingfisher:
                    loadWithKingfisher(imageUrl: imageUrl)
                }
            }
        }
        
        // description

        if let deliveryConditions = place.deliveryConditions {
            self.deliveryLabel.text = deliveryConditions
        }
        
        if let rating = place.rating {
            self.ratingLabel.text = "\(rating)"
        }

    }
    
    private func loadWithKingfisher(imageUrl: URL) {
        
        self.mainImage.kf.setImage(with: imageUrl,
                                   placeholder: #imageLiteral(resourceName: "kingfisherPlaceholder"),
                                   options: [.transition(ImageTransition.fade(0.33))],
                                   progressBlock: { (receivedSize, expectedSize) in
                                        DispatchQueue.main.async{
                                            self.progressCompletion(receivedSize: Int(receivedSize), expectedSize: Int(expectedSize))
                                        }
                                    }) { (image, error, cacheType, url) in
                                        DispatchQueue.main.async{
                                            self.isCompleted()
                                        }
                                    }
        
    }
        
    private func loadWithSDWebNuke(imageUrl: URL) {
        
        let options = ImageLoadingOptions(placeholder: #imageLiteral(resourceName: "nukePlaceholder"), transition: .fadeIn(duration: 1), failureImage: nil, failureImageTransition: .fadeIn(duration: 0.33), contentModes: nil)
        
        Nuke.loadImage(with: imageUrl,
                       options: options,
                       into: self.mainImage,
                       progress: { (response, receivedSize, expectedSize) in
                            DispatchQueue.main.async {
                                self.progressCompletion(receivedSize: Int(receivedSize), expectedSize: Int(expectedSize))
                            }
                        }) { (response, error) in
                            DispatchQueue.main.async {
                                self.isCompleted()
                            }
        }

    }
    
    private func loadWithSDWebImage(imageUrl: URL) {
        
        self.mainImage?.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "sdPlaceholder"), options: .progressiveDownload, progress: { (receivedSize, expectedSize, targetURL) in
            DispatchQueue.main.async{
                self.progressCompletion(receivedSize: receivedSize, expectedSize: expectedSize)
            }
        }) { (image, error, cacheType, url) in
            DispatchQueue.main.async{
                self.isCompleted()
            }
        }
        
    }
    
    private func progressCompletion(receivedSize: Int, expectedSize: Int) {
            var progress: Float = 0.0
            if (expectedSize != 0) {
                progress = Float(receivedSize / expectedSize)
            }
            self.progressView.isHidden = false
            self.progressView.setProgress(progress, animated: true)
    }
    
    private func isCompleted() {
        self.progressView.isHidden = true
    }
    
}

