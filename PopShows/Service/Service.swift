//
//  Service.swift
//
//  Created by lugia on 12/08/18.
//  Copyright © 2018 MicFaifer. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

enum APIError: Error {
    case jsonDecodingFailure
    case responseUnsuccessful
    case resourceUnavailable
    case noConnection
    
    var localizedDescription: String {
        switch self {
        case .responseUnsuccessful: return "Algo deu errado na requisição"
        case .jsonDecodingFailure: return "Falha nos dados"
        case .resourceUnavailable: return "Servidor indisponível"
        case .noConnection: return "Parece que você está sem conexão com a Internet ☹️"
        }
    }
}

struct RootPlaces: Decodable {
    let results: [Show]
}

class Service {
    func fetchShows(page:Int, completionHandler: @escaping (Result<[Show], APIError>) -> ()) {
        Alamofire.request(TheMovieDBAPI.urlBase,
                          parameters: ["page": page,
                                       "language": "pt-Br"]).responseData { (response) in
                                        if (response.result.isSuccess){
                                            do {
                                                guard let data = response.data else {return}
                                                let jsonDecoder = JSONDecoder()
                                                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                                                let showsData = try jsonDecoder.decode(RootPlaces.self, from: data)
                                                completionHandler(Result.success(showsData.results))
                                            } catch {
                                                completionHandler(Result.failure(APIError.jsonDecodingFailure))
                                            }
                                        } else if (response.result.isFailure) {
                                            //Manager your error
                                            switch (response.error!._code){
                                            case NSURLErrorBadServerResponse:
                                                completionHandler(Result.failure(APIError.responseUnsuccessful))
                                            case NSURLErrorNotConnectedToInternet:
                                                completionHandler(Result.failure(APIError.noConnection))
                                            case NSURLErrorResourceUnavailable:
                                                completionHandler(Result.failure(APIError.resourceUnavailable))
                                            default:
                                                completionHandler(Result.failure(APIError.responseUnsuccessful))
                                            }
                                        }
        }
    }
}
