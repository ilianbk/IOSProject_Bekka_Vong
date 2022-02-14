import UIKit

class SpeakersView: UITableViewController {
    
    
    var chosenSpeaker: Speaker?
    var speakers = [Speaker](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        
        Airtable.fetchSpeakers(from: Airtable.speakersLink + Airtable.key){ data in
            self.speakers = data
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return speakers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "speakerCell", for: indexPath) as! SpeakerMain
        
        cell.nameLbl.text = speakers[indexPath.section].fields.name! + " | " + speakers[indexPath.section].fields.type!
        
        cell.companyRoleLbl.text = speakers[indexPath.section].fields.role
        cell.companyRoleLbl.text? += " of "
        
        if let company = speakers[indexPath.section].fields.company?[0]{
            
            Airtable.getSponsor(from: Airtable.sponsorsLink + "/" + company + Airtable.key){ data in
                DispatchQueue.main.async {
                    cell.companyRoleLbl.text! += data.fields.name!
                }
            }
        }

    

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        
        headerView.backgroundColor = UIColor.white
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSpeaker = speakers[indexPath.section]
        performSegue(withIdentifier: "goToSpeaker", sender: self)
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? SpeakerDetail
        vc?.speaker = chosenSpeaker
    }

}
