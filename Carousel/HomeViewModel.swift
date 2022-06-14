//
//  HomeViewModel.swift
//  Carousel
//
//  Created by Pham Kien on 14.06.22.
//

import Foundation
import RxSwift

protocol HomeViewModelRequestProtocol {
    func getListMovie()->Observable<FilmData>

}

class HomeViewModel:BaseRequest,HomeViewModelRequestProtocol {
    func getListMovie() -> Observable<FilmData> {
        return super.createRequest(url:"https://codedeman.github.io/ssd_api/fakeCinema.json")
    }
    
    
    
}
