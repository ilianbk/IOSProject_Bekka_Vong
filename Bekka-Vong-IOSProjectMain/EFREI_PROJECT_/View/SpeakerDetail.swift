import UIKit

class SpeakerDetail: UIViewController {

    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var companyRoleLbl: UILabel!
    
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var mailView: UIView!
    
    @IBOutlet weak var mailLbl: UILabel!
    
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var speaker: Speaker?
    
    var chosenActivity: Schedule?
    var activities = [Schedule](){
        didSet{
            DispatchQueue.main.async {
                self.eventsTableView.reloadData()
            }
        
        }
    }
    
    
    @IBAction func callButtonTapped(_ sender: Any) {
        

        
        guard let number = URL(string: "tel://" + (speaker?.fields.phone?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))!) else {
            return
        }
        UIApplication.shared.open(number)
    }
    
    
    @IBAction func emailButtonTapped(_ sender: Any) {

        let email = speaker?.fields.email!
        if let url = URL(string: "mailto:\(email!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "ant.vng@gmail.com")") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
        else{
            print(".")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        typeLbl.text = speaker?.fields.type
        
        if typeLbl.text == "Speaker" {
            typeLbl.backgroundColor = UIColor.init(named: "lightGray")
        }
        
        name.text = speaker?.fields.name
        companyRoleLbl.text =  (speaker?.fields.role ?? "CEO") + " of "
        
        if let company = speaker?.fields.company?[0]{
            
            Airtable.getSponsor(from: Airtable.sponsorsLink + "/" + company + Airtable.key){ data in
                DispatchQueue.main.async {
                    self.companyRoleLbl.text! += data.fields.name!
                }
            }
        }
        
        phoneLbl.text = speaker?.fields.phone
        mailLbl.text = speaker?.fields.email
        
        setUpViews(for: mailView)
        setUpViews(for: phoneView)
        setUpLabels(for: typeLbl)
        setUpLabels(for: companyRoleLbl)
        
        initializeEvents()
        
        
        
        
    }
    
    func setUpViews(for view: UIView){
        view.layer.cornerRadius = 15
        
    }
    
    func setUpLabels(for label: UILabel){
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 0.5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? EventDetail
        vc?.schedule = chosenActivity
    }


}


extension SpeakerDetail: UITableViewDelegate, UITableViewDataSource{
    

    
    func initializeEvents(){
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        if let valueExist = speaker{
            
            var events = [Schedule]() {didSet{
                DispatchQueue.main.async {
                    self.activities = events
                }
            
            }
            }
            
            if let speakingEvents = valueExist.fields.speakingEvents{
                for s in speakingEvents{
                    
                    Airtable.getActivity(from: Airtable.scheduleLink + "/" + s + Airtable.key){ data in
                        
                        events.append(data)
                        
                    }
                    
                }
                
            }
            

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityMain
        
        cell.dateView.layer.cornerRadius = 10
        cell.dateLbl.layer.cornerRadius = 10
        cell.dateLbl.layer.masksToBounds = true
        cell.dateLbl.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.nameLbl.text = self.activities[indexPath.section].fields.activity
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: activities[indexPath.section].fields.start ?? "2017-01-09T11:00:00.000Z")!
        let calanderDate = Calendar.current.dateComponents([.minute,.hour,.day, .year, .month], from: date)
        let dateEnd = dateFormatter.date(from: activities[indexPath.section].fields.end ?? "2017-01-09T11:00:00.000Z")!
        let calanderDateEnd = Calendar.current.dateComponents([.minute,.hour,.day, .year, .month], from: dateEnd)
        cell.dateLbl.text = calanderDate.day!.description + "/" + calanderDate.month!.description + "/" + calanderDate.year!.description
        
        
        
       
        
        cell.startLbl.text = calanderDate.hour!.description + "h" + calanderDate.minute!.description
        
        if(calanderDate.minute == 0){
            cell.startLbl.text! += "0"
        }
        if(calanderDateEnd.minute == 0){
            cell.endLbl.text! += "0"
        }
        
        cell.endLbl.text = calanderDateEnd.hour!.description + "h" + calanderDateEnd.hour!.description
        
    
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenActivity = activities[indexPath.section]
        
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    

    
    
}
