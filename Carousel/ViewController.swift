//
//  ViewController.swift
//  Carousel
//
//  Created by Linh Ta on 25/04/2022.
//

import UIKit

class ViewController: UIViewController {
    private let slideShow = CarouselView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(slideShow)
        slideShow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slideShow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slideShow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slideShow.heightAnchor.constraint(equalToConstant: 200),
            slideShow.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let sources = [UIImage(named: "1")!,
                       UIImage(named: "2")!,
                       UIImage(named: "3")!]
        slideShow.inputImages = sources
        slideShow.shouldScrollAutomatically = true
    }
}

