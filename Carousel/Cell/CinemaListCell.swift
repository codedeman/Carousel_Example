//
//  CinemaListCell.swift
//  AppLab
//
//  Created by Pham Kien on 11.06.22.
//

import UIKit
import SDWebImage
class CinemaListCell: UITableViewCell {
    
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var ivFilm: UIImageView!
    static let nib = UINib.init(nibName:"\(CinemaListCell.self)" , bundle: nil)
    static let identifier:String = "\(CinemaListCell.self)"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.vMain.layer.cornerRadius = 10
        self.vMain.clipsToBounds = true
    }
    func bindingData(data:FilmModel) {
        lblTitle.text = data.name
        self.ivFilm.sd_setImage(with: URL(string: data.filmUrl)) { image, error, cache, url in
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
