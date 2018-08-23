//
//  ShowsCollectionViewController.swift
//
//  Created by lugia on 12/08/18.
//  Copyright © 2018 MicFaifer. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "showCell"

public struct ShowViewData {
    var title: String
    var imageURL: URL?
    var overview: String?
    var posterPath: URL?
    var voteAverage: String?
}

protocol PopShowsView: class {
    func startLoading()
    func finishingLoading()
    func setShows(shows: [ShowViewData])
    func displayError(with msg: String)
}

class ShowsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Attributes
    var popShowsPresenter = PopShowsPresenter(service: Service())
    
    var showsItems: [ShowViewData] = [] {
        didSet { self.collectionView?.reloadData()}
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.9649999738, green: 0.6000000238, blue: 0.4550000131, alpha: 1)
        return refreshControl
    }()
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @objc func handleRefresh (_ refreshControl: UIRefreshControl) {
        self.popShowsPresenter.refresh()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.alwaysBounceVertical = true
        
        self.collectionView?.addSubview(refreshControl)
        
        // activity view settings
        self.collectionView?.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.collectionView?.center ?? self.view.center
        activityView.startAnimating()
        
        //presentation settings
        popShowsPresenter.attachView(view: self)
        popShowsPresenter.loadShows(showsItems: showsItems)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShowViewController,
            let cell = sender as? UICollectionViewCell,
            let row = self.collectionView?.indexPath(for: cell)?.row {
            let showData = showsItems[row]
            vc.showViewData = showData
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showsItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShowCollectionViewCell
        let show = showsItems[indexPath.row]
        cell.titleLabel.text = show.title
        cell.posterImageView.kf.setImage(with: show.imageURL)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == showsItems.count - 1 {
            popShowsPresenter.loadShows(showsItems: showsItems)
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellW = (self.collectionView?.bounds.width)!/3.0 - 20
        let cellH = cellW * 1.45 + 45
        
        return CGSize(width: cellW, height: cellH)
    }
}

// MARK: PopShowsView
extension ShowsCollectionViewController: PopShowsView {
    func startLoading() {
        activityView.startAnimating()
    }
    
    func finishingLoading() {
        activityView.stopAnimating()
    }
    
    func setShows(shows: [ShowViewData]) {
        self.showsItems = shows
        
        refreshControl.endRefreshing()
        activityView.stopAnimating()
    }
    
    func displayError(with msg: String) {
        let alert = UIAlertController(title: "Erro", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
        
        refreshControl.endRefreshing()
        activityView.stopAnimating()
    }
}
