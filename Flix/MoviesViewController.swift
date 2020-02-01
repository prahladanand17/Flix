//
//  MoviesViewController.swift
//  Flix
//
//  Created by Prahlad Anand on 1/25/20.
//  Copyright © 2020 Prahlad Anand. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    

    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data
            
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
            self.tableView.reloadData()

           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let description = movie["overview"] as! String
        let title = movie["title"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let movieURL = movie["poster_path"] as! String
        let poster = URL(string: baseURL + movieURL)
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description
        
        cell.posterView.af_setImage(withURL: poster!)
        return cell
        
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //Find Selected Movie
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let movie = movies[indexPath.row]
        
       
        //Pass Selected Movie to Details Controller
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
               
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


}
