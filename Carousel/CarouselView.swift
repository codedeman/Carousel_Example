//
//  CarouselView.swift
//  Carousel
//
//  Created by Linh Ta on 25/04/2022.
//

import UIKit

class CarouselView: UIView {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.autoresizingMask = autoresizingMask

        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            scrollView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }

        return scrollView
    }()

    private let scrollContentView = UIView()

    private weak var scrollTimer: Timer?

    //Bật tắt chế độ loop của scroll view
    var circular = true {
        didSet {
            guard circular != oldValue else { return }

            //Mỗi khi circular thay đổi, config lại layout của scroll view
            inputImages = { inputImages }()
        }
    }

    var shouldScrollAutomatically = false {
        didSet {
            if shouldScrollAutomatically {
                enableAutomaticScroll()
            } else {
                disableAutomaticScroll()
            }
        }
    }

    var waitDuration: TimeInterval = 3 {
        didSet {
            guard shouldScrollAutomatically else { return }
            enableAutomaticScroll()
        }
    }

    private var canLoop: Bool {
        return circular && (inputImages.count > 1)
    }

    //Input gốc được gán bởi người dùng
    var inputImages = [UIImage]() {
        didSet {
            guard canLoop,
                  let lastImage = inputImages.last,
                  let firstImage = inputImages.first
            else {
                scrollViewImages = inputImages
                return
            }

            scrollViewImages = [lastImage] + inputImages + [firstImage]
        }
    }

    //Mảng chứa input gốc và 2 input fake được thêm vào nếu canLoop == true
    private var scrollViewImages = [UIImage]() {
        didSet {
            //Config lại layout của scroll view
            reloadScrollView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        //Chỉnh lại page của scrollView để tránh trường hợp bị khựng giữa 2 item
        let page = page(for: scrollView.contentOffset.x, width: scrollView.bounds.width)
        _set(page: page, animated: false)
    }

    //Set page dựa theo inputImages
    //User sẽ tương tác qua function này để tránh nhầm lẫn
    func set(page newPage: Int, animated: Bool) {
        shouldScrollAutomatically = false
        _set(page: newPage + 1, animated: animated)
        shouldScrollAutomatically = true
    }

    //Set page dựa theo scrollViewImages
    private func _set(page newPage: Int, animated: Bool) {
        //Xử lí invalid newPage input
        //Nếu newPage < 0 sẽ lấy 0
        //Nếu newPage >= scrollViewImages.count sẽ lấy scrollViewImages.count - 1
        let newPage = min(max(0, newPage), scrollViewImages.count - 1)
        let rect = CGRect(x: scrollView.bounds.width * CGFloat(newPage),
                          y: 0,
                          width: scrollView.bounds.width,
                          height: scrollView.bounds.height)
        scrollView.scrollRectToVisible(rect, animated: animated)
    }

    private func enableAutomaticScroll() {
        guard shouldScrollAutomatically else { return }
        guard inputImages.count > 1 else { return }
        scrollTimer?.invalidate()
        scrollTimer = Timer.scheduledTimer(withTimeInterval: waitDuration, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.scrollNext()
        }
    }

    private func disableAutomaticScroll() {
        scrollTimer?.invalidate()
        scrollTimer = nil
    }

    //Trả ra page dựa theo contentOffset.x và width của item
    //Để lấy page hiện tại truyền vào scrollView.contentOffset.x và scrollView.bounds.width
    private func page(for offset: CGFloat, width: CGFloat) -> Int {
        return width > 0 ? Int(offset + width / 2) / Int(width) : 0
    }

    private func scrollNext() {
        guard inputImages.count > 1 else { return }
        let currentPage = page(for: scrollView.contentOffset.x, width: scrollView.bounds.width)
        let nextPage = currentPage + 1 == scrollViewImages.count ? 0 : currentPage + 1
        _set(page: nextPage, animated: true)
    }

    private func reloadScrollView() {
        //Xoá item cũ
        for view in scrollContentView.subviews {
            view.removeFromSuperview()
        }

        //Add item mới
        //item.width == scrollView.bounds.width
        addScrollItems(for: scrollViewImages)
        layoutIfNeeded()

        //Nếu circular == true và 2 item fake được thêm vào
        //ta phải offset scroll view để giấu item fake ở đầu
        if canLoop {
            let focusRect = CGRect(x: scrollView.bounds.width,
                                   y: 0,
                                   width: scrollView.bounds.width,
                                   height: scrollView.bounds.height)

            scrollView.scrollRectToVisible(focusRect, animated: false)
        }
    }

    private func addScrollItems(for images: [UIImage]) {
        var leadingAnchor = scrollContentView.leadingAnchor
        for (index, image) in scrollViewImages.enumerated() {
            let item = item(for: image)
            scrollContentView.addSubview(item)

            item.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: leadingAnchor),
                item.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
                item.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor),
                item.widthAnchor.constraint(equalTo: widthAnchor)
            ])

            leadingAnchor = item.trailingAnchor

            if index == scrollViewImages.count - 1 {
                item.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
            }
        }
    }

    private func item(for image: UIImage) -> UIImageView {
        let item = UIImageView(image: image)
        item.contentMode = .scaleAspectFill
        item.clipsToBounds = true
        return item
    }

    private func initialize() {
        autoresizesSubviews = true
        clipsToBounds = true
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        scrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }
}

extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard canLoop else { return }

        if scrollView.contentOffset.x >= scrollView.bounds.width * CGFloat(inputImages.count + 1) {
            //Set offset về item thật ở đầu khi scroll hoàn chỉnh item fake ở đuôi
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.width, y: 0)
        } else if scrollView.contentOffset.x <= 0 {
            //Set offset về item thật ở đuôi khi scroll hoàn chỉnh item fake ở đầu
            let maxNormalContentOffset = scrollView.bounds.width * CGFloat(inputImages.count)
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + maxNormalContentOffset, y: 0)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        disableAutomaticScroll()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        enableAutomaticScroll()
    }
}

