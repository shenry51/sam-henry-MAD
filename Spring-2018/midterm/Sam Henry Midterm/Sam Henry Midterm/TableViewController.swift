//
//  TableViewController.swift
//  Sam Henry Midterm
//
//  Created by Sam Henry on 3/15/18.
//  Copyright © 2018 Sam Henry. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var resturants = [Resturants]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadjson()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadjson(){
        let urlPath = "https://creative.colorado.edu/~apierce/samples/data/restaurants.json"
        guard let url = URL(string: urlPath)
            else {
                print("url error")
                return
        }
        
        let session = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            guard statusCode == 200
                else {
                    print("file download error")
                    return
            }
            
            print("download complete")
            DispatchQueue.main.async {self.parsejson(data!)}
        })
        
        session.resume()
    }
    
    func parsejson(_ data: Data){
        print(data)
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [AnyObject]
            //print(json)
            
            for item in json{
//                print(item["name"]!!)
//                print(item["url"]!!)
                
                guard let newName = item["name"] as? String,
                    let newlink = item["url"] as? String
                    else {
                        print("failed")
                        continue
                }
                let newRestaurant = Resturants(name: newName, url: newlink)
                self.resturants.append(newRestaurant)
            }
            print("restaurants: \(resturants)")
        }
        catch let jsonErr{
            print(jsonErr.localizedDescription)
            return
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resturants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let rest = resturants[indexPath.row]
        cell.cellLabel.text = rest.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle = .delete{
//            resturants.remove(at: indexPath.row)
//            
//            let chosenResturant = 
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let rest = resturants[indexPath.row]
                let url =  rest.url
//                print("url: \(url)")
                let controller = segue.destination as! DetailViewController
                controller.detailItem = url
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
 
    @IBAction func unwwindSegue(_ segue: UIStoryboardSegue){
        if segue.identifier == "doneSegue"{
            let source = segue.source as! AddResturantViewController
            if source.addName.text?.isEmpty == false{
                let newRestaurant = Resturants(name: source.name, url: source.link)
                resturants.append(newRestaurant)
                print(resturants)
            }
        }
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
