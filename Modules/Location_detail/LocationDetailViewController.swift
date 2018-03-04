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
    
    var locationID: Int64!
    var dataManager: DataControllerPrototcol!
    
    @IBOutlet weak var activitiesView: ActivityView!
    @IBOutlet weak var profilesView: ProfileView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Collection view data and delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}
