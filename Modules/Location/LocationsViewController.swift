//
//  LocationsViewController.swift
//  AirTasker
//
//  Created by Timothy Storey on 26/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData

class LocationsViewController: UIViewController {
    
    
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
        _ = try! fetchController.performFetch()
        return fetchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager?.fetchLocations()
        registerCustomCells(With: locationCollectionView)
        setupCollectionView(ForView: locationCollectionView)        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLayout(forScreen screenSize: CGRect) -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = screenSize.width
        layout.sectionInset = UIEdgeInsets(top: 20, left: 8, bottom: 10, right: 8)
        layout.itemSize = CGSize(width: screenWidth - 20, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        return layout
    }
    
    func registerCustomCells(With collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "locationCell")
    }
    
    func setupCollectionView(ForView view: UICollectionView) {
        view.delegate = self
        view.dataSource = self
        let screenSize = self.locationCollectionView.bounds
        view.collectionViewLayout = self.setupLayout(forScreen: screenSize)
    }
    

}

extension LocationsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        locationCollectionView.reloadData()
    }
    
}

extension LocationsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: - Data source and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = locationResultsController.fetchedObjects?.count else {return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as? LocationCollectionViewCell {
            let location = locationResultsController.fetchedObjects![indexPath.row]
            cell.locationLabel.text = location.name
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailViewController") as! LocationDetailViewController
        vc.location = locationResultsController.fetchedObjects?[indexPath.row]
        vc.dataManager = dataManager
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
