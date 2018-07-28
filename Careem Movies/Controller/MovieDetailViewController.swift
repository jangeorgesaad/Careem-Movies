//
//  MovieDetailViewController.swift
//  Careem Movies
//
//  Created by Jan G. Botros on 7/27/18.
//  Copyright © 2018 Jan G. Botros. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieDetailViewController: UIViewController {

    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Movie Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let posterPath = movie?.poster_path
        if posterPath != nil {
            Alamofire.request("http://image.tmdb.org/t/p/w185/\(posterPath ?? "")", method: .get).responseImage { response in
                guard let image = response.result.value else {
                    
                    return
                }
                self.moviePosterImageView.image = image
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension MovieDetailViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 150
            
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Movie Name"
            cell.detailTextLabel?.text = movie?.title
        }
        if indexPath.row == 1 {
            let textArea = UITextView(frame: CGRect(x: 15, y: 12, width: cell.frame.width - 30, height: 125))
            textArea.isEditable = false
            textArea.text = movie?.overview
            textArea.font = UIFont(name: (textArea.font?.fontName)!, size: 15)
            cell.addSubview(textArea)
        }
        if indexPath.row == 2 {
            cell.textLabel?.text = "Release Date"
            cell.detailTextLabel?.text = movie?.release_date
        }
        if indexPath.row == 3 {
            cell.textLabel?.text = "Language"
            cell.detailTextLabel?.text = movie?.original_language
        }
        if indexPath.row == 4 {
            cell.textLabel?.text = "Adults Only"
            if movie?.adult ?? false {
                cell.detailTextLabel?.text = "Yes"
            } else {
                cell.detailTextLabel?.text = "No"
            }
        }
        if indexPath.row == 5 {
            cell.textLabel?.text = "Popularity"
            cell.detailTextLabel?.text = "\(movie?.popularity ?? 0)"
        }
        if indexPath.row == 6 {
            cell.textLabel?.text = "Vote Average"
            cell.detailTextLabel?.text = "\(movie?.vote_average ?? 0)"
        }
        if indexPath.row == 7 {
            cell.textLabel?.text = "Vote Count"
            cell.detailTextLabel?.text = "\(movie?.vote_count ?? 0)"
        }
        
        return cell
    }

}
