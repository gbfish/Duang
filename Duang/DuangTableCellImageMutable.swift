//
//  DuangTableCellImageMutable.swift
//  Duang
//
//  Created by David Yu on 15/3/25.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DuangTableCellImageMutable: UITableViewCell
{
    
    var imageView1 = UIImageView()
    var imageView2 = UIImageView()
    var imageView3 = UIImageView()
    var imageView4 = UIImageView()
    var imageView5 = UIImageView()
    
    var imageFile1: PFFile? {
        didSet {
            imageFile1?.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                if error == nil {
                    self.imageView1.image = UIImage(data: imageData)
//                    if let image = UIImage(data: imageData) {
//                        self.imageView1.image = image
//                    }
                }
            })
        }
    }
    
    
    
    func loadImages(objects: [PFObject]) {
        var imageViewArray = [imageView1, imageView2, imageView3, imageView4, imageView5]
        
        for var index = 0; index < objects.count; ++index {
            let photo: PFObject = objects[index] as PFObject
            let imageFile: PFFile = photo[TablePhoto.Image] as PFFile
            imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                if error == nil {
                    self.imageView1.image = UIImage(data: imageData)
                }
            })
        }

    }
    
    var hasAddImageViews = false
    
    func addImageViews() {
        if !hasAddImageViews {
            imageView1.contentMode = UIViewContentMode.ScaleAspectFill
            imageView2.contentMode = UIViewContentMode.ScaleAspectFill
            imageView3.contentMode = UIViewContentMode.ScaleAspectFill
            imageView4.contentMode = UIViewContentMode.ScaleAspectFill
            imageView5.contentMode = UIViewContentMode.ScaleAspectFill
            imageView1.clipsToBounds = true
            imageView2.clipsToBounds = true
            imageView3.clipsToBounds = true
            imageView4.clipsToBounds = true
            imageView5.clipsToBounds = true
            addSubview(imageView1)
            addSubview(imageView2)
            addSubview(imageView3)
            addSubview(imageView4)
            addSubview(imageView5)
            hasAddImageViews = true
        }
    }
    
    
    var photos: PFRelation? {
        didSet {
            addImageViews()
            imageView1.hidden = true
            imageView2.hidden = true
            imageView3.hidden = true
            imageView4.hidden = true
            imageView5.hidden = true
            
            let spacing: CGFloat = 4.0
            
            if let relation = photos {
                relation.query().findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    if error == nil {
                        let photos = objects as [PFObject]
                        switch photos.count {
                        case 1:
                            self.loadImage(self.imageView1, rect: self.bounds, file: self.getFile(photos, index: 0))
                            
                        case 2:
                            let rect1 = CGRectMake(0.0, 0.0, (self.bounds.width - spacing) / 2, self.bounds.height)
                            let rect2 = CGRectMake(rect1.width + spacing , 0.0, rect1.width, self.bounds.height)
                            
                            self.loadImage(self.imageView1, rect: rect1, file: self.getFile(photos, index: 0))
                            self.loadImage(self.imageView2, rect: rect2, file: self.getFile(photos, index: 1))
                            
                        case 3:
                            let rect1 = CGRectMake(0.0, 0.0, (self.bounds.width - spacing) / 2, self.bounds.height)
                            let rect2 = CGRectMake(rect1.width + spacing , 0.0, rect1.width, (self.bounds.height - spacing) / 2)
                            let rect3 = CGRectMake(rect2.origin.x , rect2.height + spacing, rect2.width , rect2.height)
                            
                            self.loadImage(self.imageView1, rect: rect1, file: self.getFile(photos, index: 0))
                            self.loadImage(self.imageView2, rect: rect2, file: self.getFile(photos, index: 1))
                            self.loadImage(self.imageView3, rect: rect3, file: self.getFile(photos, index: 2))
                            
                        case 4:
                            let rect1 = CGRectMake(0.0, 0.0, self.bounds.width, self.bounds.height - spacing - ((self.bounds.width - (spacing * 2)) / 3))
                            let rect2 = CGRectMake(0.0 , rect1.height + spacing, (self.bounds.width - (spacing * 2)) / 3, (self.bounds.width - (spacing * 2)) / 3)
                            let rect3 = CGRectMake(rect2.width + spacing , rect2.origin.y, rect2.width, rect2.height)
                            let rect4 = CGRectMake(rect3.origin.x + rect2.width + spacing , rect2.origin.y, rect2.width, rect2.height)
                            
                            self.loadImage(self.imageView1, rect: rect1, file: self.getFile(photos, index: 0))
                            self.loadImage(self.imageView2, rect: rect2, file: self.getFile(photos, index: 1))
                            self.loadImage(self.imageView3, rect: rect3, file: self.getFile(photos, index: 2))
                            self.loadImage(self.imageView4, rect: rect4, file: self.getFile(photos, index: 3))
                            
                        case 5:
                            let rect1 = CGRectMake(0.0, 0.0, self.bounds.width - ((self.bounds.height - (spacing * 2)) / 3) - spacing, (self.bounds.height - spacing) / 2)
                            let rect2 = CGRectMake(0.0 , rect1.height + spacing, rect1.width , rect1.height)
                            let rect3 = CGRectMake(rect1.width + spacing , 0, (self.bounds.height - (spacing * 2)) / 3, (self.bounds.height - (spacing * 2)) / 3)
                            let rect4 = CGRectMake(rect3.origin.x, rect3.height + spacing, rect3.width , rect3.height)
                            let rect5 = CGRectMake(rect3.origin.x, rect4.origin.y + rect3.height + spacing, rect3.width , rect3.height)
                            
                            self.loadImage(self.imageView1, rect: rect1, file: self.getFile(photos, index: 0))
                            self.loadImage(self.imageView2, rect: rect2, file: self.getFile(photos, index: 1))
                            self.loadImage(self.imageView3, rect: rect3, file: self.getFile(photos, index: 2))
                            self.loadImage(self.imageView4, rect: rect4, file: self.getFile(photos, index: 3))
                            self.loadImage(self.imageView5, rect: rect5, file: self.getFile(photos, index: 4))
                            
                        default:
                            break
                        }
                        println("objects = \(objects.count)")
                        
                        
                    } else {
                        
                    }
                })
            }
            
            

        }
    }
    
    func getFile(photos: [PFObject], index: NSInteger) -> PFFile {
        let photo: PFObject = photos[index] as PFObject
        return photo[TablePhoto.Image] as PFFile
    }
    
    func loadImage(imageView: UIImageView, rect: CGRect, file: PFFile?) {
        imageView.hidden = false
        imageView.frame = rect
        imageView.image = ImagePlaceholder.Image
        if let theFile = file {
            theFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                if error == nil {
                    if let image = UIImage(data: imageData) {
                        imageView.image = image
                    }
                }
            }
        }
    }
}
