import UIKit

private let reuseIdentifier = "Cell"

class SponsorsView: UICollectionViewController {
    
    var chosenCompany: Sponsor?
    var sponsors = [Sponsor](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()

            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

     
        Airtable.fetchSponsors(from: Airtable.sponsorsLink + Airtable.key){ data in
            
            self.sponsors = data
        }
         
        
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sponsors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "companyCell", for: indexPath) as! SponsorsMain
        

        cell.nameLbl.text = sponsors[indexPath.row].fields.name
        
        if let amount = sponsors[indexPath.row].fields.amount{
            cell.amountLbl.text = amount.description + " $"
        }
        else{
            cell.amountLbl.text = "No amount for now"
        }
        
        
        if let notes = sponsors[indexPath.row].fields.notes {
            cell.notesLbl.text = notes
        }
        else{
            cell.notesLbl.text = "Notes unavailable."
        }
        
        cell.statusLbl.text = sponsors[indexPath.row].fields.status
        cell.statusLbl.layer.cornerRadius = 11
        cell.statusLbl.layer.masksToBounds = true
  
    
        return cell
    }

    
}
