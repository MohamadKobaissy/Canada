//
//  Models.swift
//  CCIAZ
//
//  Created by MBPR on 11/26/18.
//  Copyright © 2018 IDS Mac. All rights reserved.
//

import Foundation

class item {
    var key: String
    var value: String
    var savedImg: UIImage?
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}



class HomeMenuItem {
    var Image: String
    var Title: String
    var Color: UIColor
    var Link: String
    
    init(Image:String,Title: String,Color : UIColor ,Link : String)  {
        self.Image = Image
        self.Title = Title
        self.Color = Color
        self.Link = Link
    }
}



class LibraryItem {
    var label: String
    var title: String
    var type: String
    
    init(label:String,title: String, type : String){
        self.label = label
        self.title = title
        self.type = type
    }
}



class CategoryItem {
    var id: Int
    var title , image: String
    var savedImg: UIImage?
    var isImageUpdated = false
    var parent = 0
    
    init(id:Int, title: String, image : String){
        self.id = id
        self.title = title
        self.image = image
    }
}



//class InterestedPlaceItem: Codable {
//    var placeId: Int
//    var isInterested: Bool
//
//    init(placeId: Int, isInterested: Bool){
//        self.placeId = placeId
//        self.isInterested = isInterested
//    }
//}



class CommentItem: Codable {
    var user: String
    var msg: String
    var images: [String]

    init(user: String, msg: String, images: [String]){
        self.user = user
        self.msg = msg
        self.images = images
    }
}




class ProductItem {
    var id: Int
    var total, title, image, price, city, date: String
    var content: String?
    
    var savedImg: UIImage?
    var mediaImgs = [UIImage]()
    
    var sponserd: Int = 0
    var details = ProductItemDetails()
    var descriptions: String = ""
    var publisherId: Int = 0
    var publisher, email, phone, facebook: String
    var twitter: String = ""
    var publisherImage: String = ""
    var gallery: [Gallery] = []
    
    var category: String = ""
    var currency: String = ""
    var address: String = ""
    var isNegociable: Bool = false
    var categoryDetails = [item]()

    var read: Int = 0
    var fav: String = ""
    var report: String = ""
    
    var status = 0, refused = 0, pPhone = 0
    
    var city_id: Int = 0, category_id: Int = 0, country_id = 0
    
    init(id: Int, total: String, title: String, image: String, content: String, price: String, city: String, date: String) {
        self.id = id
        self.total = total
        self.title = title
        self.image = image
        self.content = content
        self.price = price
        self.city = city
        self.date = date
        self.publisher = ""
        self.email = ""
        self.phone = ""
        self.facebook = ""
    }

    init(id: Int, title: String, sponserd: Int, content: String?, details: ProductItemDetails, image: String, price: String, descriptions: String, city: String, date: String, publisher: String, email: String, phone: String, facebook: String, twitter: String, publisherImage: String, gallery: [Gallery]) {
        self.id = id
        self.title = title
        self.sponserd = sponserd
        self.content = content
        self.details = details
        self.image = image
        self.price = price
        self.descriptions = descriptions
        self.city = city
        self.date = date
        self.publisher = publisher
        self.email = email
        self.phone = phone
        self.facebook = facebook
        self.twitter = twitter
        self.publisherImage = publisherImage
        self.gallery = gallery
        self.total = ""
    }
    
    init(id: Int, total: String, title: String, image: String, content: String, price: String, city: String, date: String, read: Int, fav: String, report: String, facebook: String, twitter: String) {
        self.id = id
        self.total = total
        self.title = title
        self.image = image
        self.content = content
        self.price = price
        self.city = city
        self.date = date
        self.publisher = ""
        self.email = ""
        self.phone = ""
        self.facebook = facebook
        self.twitter = twitter
        self.report = report
        self.fav = fav
        self.read = read
    }
    
    init() {
        self.id = 0
        self.total = ""
        self.title = ""
        self.image = ""
        self.content = ""
        self.price = ""
        self.city = ""
        self.date = ""
        self.publisher = ""
        self.email = ""
        self.phone = ""
        self.facebook = ""
    }
}



// MARK: - Gallery
class Gallery: Codable {
    var id: Int
    var title: String?
    var path: String

    init(id: Int, title: String?, path: String) {
        self.id = id
        self.title = title
        self.path = path
    }
}


// MARK: - Details
class ProductItemDetails: Codable {
    var title, detailsDescription: [String]

    enum CodingKeys: String, CodingKey {
        case title
        case detailsDescription = "description"
    }

    init(title: [String], detailsDescription: [String]) {
        self.title = title
        self.detailsDescription = detailsDescription
    }

    init() {
        self.title = []
        self.detailsDescription = []
    }
}



class NotificationDataItem: Codable {
    var chatId: Int
    var itemId, publisherId: Int
    var title, msg: String
    var type: String
    var time: Double
    
    init(chatId: Int, title: String, msg: String, type: String, time: Double){
        self.chatId = chatId
        self.title = title
        self.msg = msg
        self.type = type
        self.time = time
        self.itemId = 0
        self.publisherId = 0
    }
    
    init(){
        self.chatId = 0
        self.title = ""
        self.msg = ""
        self.type = ""
        self.time = 0
        self.itemId = 0
        self.publisherId = 0
    }
    
    func toString() -> String {
        return ("chatId: \(chatId), \"title\": \(title), \"msg\": \(msg), \"type\": \(type), \"time\": \(time), \"itemId\": \(itemId), \"publisherId\": \(publisherId)")
    }
}


class UserItem {
    var fullname: String
    var facebook, twitter: String
    var email, phone: String
    var image: String
    var pphone = 0
    
    init(fullname: String, facebook: String, twitter: String, email: String, phone: String, image: String) {
        self.fullname = fullname
        self.facebook = facebook
        self.twitter = twitter
        self.email = email
        self.phone = phone
        self.image = image
    }
}
