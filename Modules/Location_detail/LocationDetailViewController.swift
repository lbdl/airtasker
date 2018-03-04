//
//  LocationDetailViewController.swift
//  AirTasker
//
//  Created by Timothy Storey on 03/03/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class ProfileView: UICollectionView {}
class ActivityView: UICollectionView {}

class LocationDetailViewController: UIViewController {
    
    var location: Location!
    var dataManager: DataControllerPrototcol!
    
    @IBOutlet weak var activitiesView: ActivityView!
    @IBOutlet weak var profilesView: ProfileView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.fetchLocationData(for: location.id)
        setupViews()
    }
    
    lazy var localleResultsController: NSFetchedResultsController<Localle> = {
        let localleFetchReq = Localle.sortedFetchRequest
        let predicate = NSPredicate(format: "id == %d", location.id)
        localleFetchReq.predicate = predicate
        let ms = self.dataManager as! DataManager
        let context = ms.persistenceManager.context as! NSManagedObjectContext
        let fetchController = NSFetchedResultsController(
            fetchRequest: localleFetchReq,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchController.delegate = self
        _ = try! fetchController.performFetch()
        return fetchController
    }()
    
    private func setupViews() {
        profilesView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "profileCell")
        profilesView.collectionViewLayout = setupLayout(forScreen: profilesView.bounds)
        profilesView.dataSource = self
        profilesView.delegate = self
    }
    
    private func setupLayout(forScreen screenSize: CGRect) -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = screenSize.width
        layout.sectionInset = UIEdgeInsets(top: 20, left: 8, bottom: 10, right: 8)
        layout.itemSize = CGSize(width: screenWidth, height: 120)
        layout.minimumLineSpacing = 6
        return layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension LocationDetailViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.activitiesView.reloadData()
        self.profilesView.reloadData()
    }
    
}

extension LocationDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let localle = localleResultsController.fetchedObjects?.first else {return 0}
        if collectionView.isKind(of: ProfileView.self) {
            return localle.users.count
        } else {
            return  localle.users.reduce(0, {$0 + ($1.activities?.count)!})
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ProfileCollectionViewCell
        if collectionView.isKind(of: ProfileView.self) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
            if let localle: Localle = (localleResultsController.fetchedObjects?.first)! {
                let users = localle.orderedUsers()
                let user = users[indexPath.row]
                cell.nameLabel.text = user.name
                cell.ratingLabel.text = String(user.rating)
                cell.descriptionLabel.text = user.desc
                dataManager.fetchAvatarData(for: user.id, forImageView: cell.avatarView)
            }
            return cell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
        }
        return cell
    }
    
}
