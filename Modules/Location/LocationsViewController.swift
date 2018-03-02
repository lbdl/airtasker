//
//  LocationsViewController.swift
//  AirTasker
//
//  Created by Timothy Storey on 26/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData


/// Ideally the data source and delegate methods should be factored into another class but for brevity here I have added them to the VC
/// there's not much going on so its not really an issue I would say although as complexity increases the VC's should really become abstract and
/// only deal with displaying views, data and processing should not be encapsulated here.
class LocationsViewController: UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    var dataManager: DataControllerPrototcol?
    
    lazy var locationResultsController: NSFetchedResultsController<Location> = {
        let locationFetchReq = Location.sortedFetchRequest
        let ms = self.dataManager as! DataManager
        let context = ms.persistenceManager.context as! NSManagedObjectContext
        let fetchController = NSFetchedResultsController(
            fetchRequest: locationFetchReq,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchController.delegate = self
        return fetchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager?.fetchLocations()
        self.locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "locationCell")
        self.locationCollectionView.delegate = self
        self.locationCollectionView.dataSource = self
        _ = try! self.locationResultsController.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - Data source and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = locationResultsController.fetchedObjects?.count else {return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.locationCollectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) 
        
        return cell
    }

}
