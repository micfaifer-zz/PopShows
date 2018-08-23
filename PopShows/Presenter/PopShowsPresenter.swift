//
//  PopShowsPresenter.swift
//
//  Created by lugia on 12/08/18.
//  Copyright © 2018 MicFaifer. All rights reserved.
//

import Foundation


class PopShowsPresenter {
    private let service: Service
    weak private var popShowsView: PopShowsView?
    
    private var page = 1
    
    init(service: Service) {
        self.service = service
    }
    
    func attachView(view:PopShowsView){
        self.popShowsView = view
    }
    
    func detachView() {
        popShowsView = nil
    }
    
    func loadShows (showsItems: [ShowViewData]){
        self.popShowsView?.startLoading()
        service.fetchShows(page: page) { (result) in
            self.popShowsView?.finishingLoading()
            switch result {
            case .success(let shows):
                let showsViewData = showsItems + shows.map {
                    return ShowViewData(title: $0.originalName ?? "",
                                         imageURL: URL(string: TheMovieDBAPI.imagePath + ($0.posterPath ?? "")),
                                         overview: $0.overview,
                                         posterPath: URL(string: TheMovieDBAPI.imagePath + ($0.backdropPath ?? "")),
                                         voteAverage: "★ " + (String(describing: $0.voteAverage ?? 10)) + "/10")
                    }

                self.page += 1
                DispatchQueue.main.async {
                    self.popShowsView?.setShows(shows: showsViewData)
                }
            case .failure(let error):
                DispatchQueue.main.async  {
                    self.popShowsView?.displayError(with: error.localizedDescription)
                }
            }
        }
    }
    
    func refresh () {
        self.page = 1
        self.loadShows(showsItems: [])
    }
}
