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
        
        self.registerCustomCells(With: self.locationCollectionView)
        self.setupCollectionView(ForView: self.locationCollectionView)
        
        _ = try! self.locationResultsController.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLayout(forScreen screenSize: CGRect) -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = screenSize.width
        layout.sectionInset = UIEdgeInsets(top: 20, left: 8, bottom: 10, right: 8)
        layout.itemSize = CGSize(width: screenWidth, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        return layout
    }
    
    func registerCustomCells(With collectionView: UICollectionView) {
        self.locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "locationCell")
    }
    
    func setupCollectionView(ForView view: UICollectionView) {
        view.delegate = self
        view.dataSource = self
        let screenSize = self.locationCollectionView.bounds
        view.collectionViewLayout = self.setupLayout(forScreen: screenSize)
    }
    
    //MARK: - Data source and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = locationResultsController.fetchedObjects?.count else {return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.locationCollectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as? LocationCollectionViewCell {
            let location = self.locationResultsController.fetchedObjects![indexPath.row] as Location
            cell.locationLabel.text = location.name
            cell.location = location
            return cell
        } else {
            return self.locationCollectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailViewController") as! LocationDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    

}
