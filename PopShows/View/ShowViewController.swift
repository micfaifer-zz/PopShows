//
//  ShowViewController.swift
//
//  Created by lugia on 14/08/18.
//  Copyright © 2018 MicFaifer. All rights reserved.
//

import UIKit
import Kingfisher

class ShowViewController: UIViewController {
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!

    var showViewData: ShowViewData?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = showViewData?.title
        backdropImageView.kf.setImage(with: showViewData?.posterPath)
        ratingLabel.text = showViewData?.voteAverage
        synopsisTextView.text = showViewData?.overview
    }
}
