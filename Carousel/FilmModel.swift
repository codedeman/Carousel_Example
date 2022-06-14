//
//  FilmModel.swift
//  Carousel
//
//  Created by Pham Kien on 14.06.22.
//


import Foundation
struct FilmData:Codable {
    var listFilms:[FilmModel]!
}
struct FilmModel:Codable {
    var id:String = ""
    var filmUrl:String = ""
    var name:String = ""
    var price:String = ""
    
//    "id":"12345",
//    "filmUrl":"https://billboardvn.vn/wp-content/uploads/2019/04/Dua-Lipa-elle-cover-2019-billboard-1240.jpg",
//    "name":"Doraemon và những người bạn",
//    "price":"100000"
}
