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
    
    var photos: PFRelation? {
        didSet {
            if let relation = photos {
                relation.query().findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    if error == nil {
                        switch objects.count {
                        case 1:
                            self.imageView1 = UIImageView(frame: self.bounds)
                            
                            self.imageView2 = UIImageView()
                            self.imageView3 = UIImageView()
                            self.imageView4 = UIImageView()
                            self.imageView5 = UIImageView()
                            
                            self.addSubview(self.imageView1)
                            self.addSubview(self.imageView2)
                            self.addSubview(self.imageView3)
                            self.addSubview(self.imageView4)
                            self.addSubview(self.imageView5)
                            
                            let photos = objects as [PFObject]
                            let photo: PFObject = objects[0] as PFObject
                            let imageFile: PFFile = photo[TablePhoto.Image] as PFFile
                            
                            self.loadImage(self.imageView1, file: imageFile)
                            
//                            self.loadImages(photos)
                            
//                            let photo: PFObject = objects[0] as PFObject
//                            
//                            println("photo Description = \(photo[TablePhoto.Description])")
//                            println("photo ImageWidth = \(photo[TablePhoto.ImageWidth])")
//                            println("photo ImageHeight = \(photo[TablePhoto.ImageHeight])")
//                            
//                            let imageFile: PFFile = photo[TablePhoto.Image] as PFFile
//                            
//                            self.imageFile1 = imageFile
                            
//                            self.imageView1.image = ImagePlaceholder.Image
////                            if let theFile = imageFile {
//                                imageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
//                                    if error == nil {
//                                        if let image = UIImage(data: imageData) {
//                                            self.imageView1.image = image
//                                        }
//                                    }
//                                }
////                            }
                            
                            
//                            self.loadImage(self.imageView1, file: imageFile)
                            
//                            file.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
//                                if error == nil {
//                                    if let image = UIImage(data:imageData) {
//                                        self.imageView1.image = image
//                                    }
//                                }
//                            })
//
//                            let file: PFFile = objects[0][TablePhoto.Image] as PFFile
//                            file.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
//                                if error == nil {
//                                    if let image = UIImage(data:imageData) {
//                                        self.imageView1.image = image
//                                    }
//                                }
//                            })
//                            
//                            if let file: PFFile = objects[0][TablePhoto.Image] as? PFFile {
//                                file.getDataInBackgroundWithBlock { (imageData, error) -> Void in
//                                    if error == nil {
//                                        if let image = UIImage(data:imageData) {
//                                            self.imageView1.image = image
//                                        }
//                                    }
//                                }
//                            }
                            
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
    
    func loadImage(imageView: UIImageView, file: PFFile?) {
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
    
    
/*
    var duangTableDataRow: DuangTableDataRow? {
        didSet {
            if let row = duangTableDataRow {
                
//                if let image = row.getImageArray(0) {
//                    cellImageView.image = image
//                }
                
                
                println("row.imageFileArray = \(row.imageFileArray)")
                
                if let imageFileArray = row.imageFileArray {
                    switch imageFileArray.count {
                    case 1:
                        println("hello")
                        
//                    case 2:
                        
                    default:
                        break
                    }
                }
                
                
                
//                swich row.imageFileArray.count {
//                    case 1:
//                    
//                }
                
//                if let imageFile = row.getImageFileArray(0) {
//                    imageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
//                        if error == nil {
//                            if let image = UIImage(data:imageData) {
//                                self.cellImageView.image = image
//                            }
//                        }
//                    }
//                }
            }
        }
    }*/
}
