//
//  Message.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 3/5/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import FirebaseAuth

class Message: NSObject {
    
    var text:String?
    
    var toId:String?
    
    var isIncoming:Bool?
    
    var imageUrl:String?
    
    var videoUrl:String?
    
    var imageVideo:String?
    
    var NumberMedia:Int?
    
    var date:TimeInterval?
    
    init(dictionary:[String:Any]) {
        super.init()
        self.isIncoming = dictionary["isIncoming"] as? Bool
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.date = dictionary["date"] as? TimeInterval
    
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageVideo = dictionary["imageVideo"] as? String
        self.NumberMedia = dictionary["NumberMedia"] as? Int
        self.videoUrl = dictionary["videoUrl"] as? String
    }
}

 func localMediaPhoto(imageName: String, caption: String) -> Media {
    guard let image = UIImage(named: imageName) else {
        fatalError("Image is nil")
    }
    
    let photo = Media(image: image, caption: caption)
    return photo
}

 func webMediaPhoto(url: String, caption: String?) -> Media {
    guard let validUrl = URL(string: url) else {
        fatalError("Image is nil")
    }
    
    var photo = Media()
    if let _caption = caption {
        photo = Media(url: validUrl, caption: _caption)
    } else {
        photo = Media(url: validUrl)
    }
    return photo
}

 func webMediaVideo(url: String, previewImageURL: String? = nil) -> Media {
    guard let validUrl = URL(string: url) else {
        fatalError("Video is nil")
    }

    let photo = Media(videoURL: validUrl, previewImageURL: URL(string: previewImageURL ?? ""))
    return photo
}
