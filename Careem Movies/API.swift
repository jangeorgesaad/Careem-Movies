//
//  API.swift
//  Careem Movies
//
//  Created by Jan G. Botros on 7/27/18.
//  Copyright © 2018 Jan G. Botros. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class API {
    func fetchMovies(MovieName: String, PageNumber: Int, completion: @escaping ([Movie]?, _ totalPages: Int?) -> Void){
        let movieNameForURL = MovieName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var movies = [Movie]()
        let url = URL(string: "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(movieNameForURL ?? "")&page=\(PageNumber)")
        Alamofire.request(url!,
                          method: .get,
                          parameters: nil)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching movies \(String(describing: response.result.error))")
                    
                    completion(nil, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let results = value["results"] as? [[String: Any]] else {
                        print("Malformed data received from fetchMovies service")
                        
                        completion(nil, nil)
                        return
                }
                let totalPages = value["total_pages"] as? Int

                for result in results {
                    let movie = Movie(dictionary: result)
                    if let movie = movie {
                        movies.append(movie)
                    }
                }
                completion(movies, totalPages)
        }
    }
    
}
