//
//  ViewController.swift
//  Carousel
//
//  Created by Linh Ta on 25/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    let homeViewModel:HomeViewModel = HomeViewModel()
    private let slideShow = CarouselView()
    var  listMovie:PublishSubject<[FilmModel]> = PublishSubject()
    var listCinema:Observable<[FilmModel]>!

    private var vContent:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
 
    
    private  var lblTitle:UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private  var lblSubTitle:UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lblTitle,lblSubTitle])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 30
        return stack
    }()
    
    lazy var tableView:UITableView = {
        let talble = UITableView()
        talble.backgroundColor = .red
        talble.translatesAutoresizingMaskIntoConstraints = false
        return talble
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(slideShow)
        slideShow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slideShow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slideShow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slideShow.heightAnchor.constraint(equalToConstant: 555),
            slideShow.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        ])
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: slideShow.bottomAnchor)
        ])
        
        
        slideShow.addSubview(vContent)
        vContent.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        vContent.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            vContent.leadingAnchor.constraint(equalTo: self.slideShow.leadingAnchor,constant: 10),
            vContent.trailingAnchor.constraint(equalTo: self.slideShow.trailingAnchor,constant: -10),
            vContent.heightAnchor.constraint(equalToConstant: 80),
            vContent.bottomAnchor.constraint(equalTo: self.slideShow.bottomAnchor, constant:-10)
        ])
        lblTitle.text = "Hello mấy cưng"
        lblSubTitle.text = "Kevin"
//        lblTitle.textColor = .black
        stackView.addSubview(lblTitle)
        stackView.addArrangedSubview(lblSubTitle)
        vContent.addSubview(stackView)
//        stackView.backgroundColor = .red
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.vContent.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.vContent.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.vContent.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.vContent.bottomAnchor)
        ])
        
        
        let sources = [UIImage(named: "1")!,
                       UIImage(named: "2")!,
                       UIImage(named: "3")!]
        slideShow.inputImages = sources
        slideShow.shouldScrollAutomatically = true
        
        self.tableView.register(CinemaListCell.nib, forCellReuseIdentifier: CinemaListCell.identifier)

        homeViewModel.getListMovie().subscribe {$0.map { filmData in
            self.listMovie.onNext(filmData.listFilms)
            self.listCinema = Observable.of(filmData.listFilms)
//            self.listMovie.asObserver().asObservable().b
        }}.disposed(by: disposeBag)
        
        listMovie.asObservable().bind(to: tableView.rx.items) {(tableView,row,element) in
            let cell:CinemaListCell = tableView.dequeueReusableCell(withIdentifier: CinemaListCell.identifier) as! CinemaListCell
            cell.bindingData(data: element)
            return cell
        }.disposed(by: disposeBag)
 
        
    }
}

