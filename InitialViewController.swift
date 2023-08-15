import UIKit
import CoreData
import CoreLocation

class InitialViewController: UITableViewController {
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?

    @IBOutlet var btn_add: UIBarButtonItem!
    
    @IBOutlet var searchBar: UISearchBar!
        
    var myFetchResultsController = CoreDataManager.shared.myFetchResultsController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchAllCity()
        tableView.delegate = self
        tableView.dataSource = self
        self.searchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        fetchAllCity()
    }
    
   override func numberOfSections(in tableView: UITableView) -> Int {
       // #warning Incomplete implementation, return the number of sections
       return myFetchResultsController.sections?.count ?? 0

   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of rows
        return myFetchResultsController.sections?[section].numberOfObjects ?? 0
   }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clickecd on : \(indexPath.row)")
        let weatherViewController = storyboard?.instantiateViewController(identifier: "WeatherViewController") as? WeatherViewController
        weatherViewController?.city =
            myFetchResultsController.object(at: indexPath).cityName
       self.navigationController?.pushViewController(weatherViewController!, animated: true)
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("loaded :\(indexPath)")
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! initialTableViewCell
    cell.setData(model: myFetchResultsController.object(at: indexPath))
    return cell
   }
   

   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
        print("\(myFetchResultsController.object(at: indexPath))")
          CoreDataManager.shared.deleteCity(city: myFetchResultsController.object(at: indexPath))
            fetchAllCity()
           
       }
   }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 1
      }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        fetchAllCity()
        
    }
    
    func fetchAllCity() {
        guard let fetchedObjects = myFetchResultsController.fetchedObjects else {
            return
        }
        
        let sortedCities = fetchedObjects.sorted { city1, city2 in
            guard let userLocation = userLocation else {
                return false
            }
            
            let city1Location = CLLocation(latitude: city1.latitude, longitude: city1.longitude)
            let city2Location = CLLocation(latitude: city2.latitude, longitude: city2.longitude)
            
            return userLocation.distance(from: city1Location) < userLocation.distance(from: city2Location)
        }

        // Update the fetchedObjects directly
        myFetchResultsController = NSFetchedResultsController(
            fetchRequest: myFetchResultsController.fetchRequest,
            managedObjectContext: myFetchResultsController.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        // Assign the sorted objects directly to the fetchedObjects
        //myFetchResultsController.fetchedObjects = sortedCities

        tableView.reloadData()
    }



}

extension InitialViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
}



extension InitialViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == ""){
            try? myFetchResultsController.performFetch()
            tableView.reloadData()
        }
        else {
            //myFetchResultsController.fetchRequest = CoreDataManager.shared.search(text: searchText)
         tableView.reloadData()
        }
    }
    
}
