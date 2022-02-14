import UIKit
import MapKit
import CoreLocation
import SwiftUI

class EventDetail: UIViewController {

    @IBOutlet weak var backgroundImg: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var topicLbl: UILabel!
    @IBOutlet weak var speakersLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var endLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var locationMapView: MKMapView!
    
    @IBOutlet weak var dateView: UIView!
    
    var schedule: Schedule!
    
    var lat: Double!
    var lon: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        Airtable.getLocation(from: Airtable.locationLink + "/" + schedule.fields.location![0] + Airtable.key){data in
            
            DispatchQueue.main.async{
                self.locationLbl.text = data.fields.name
                let annotation = MKPointAnnotation()
                
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(data.fields.adress ?? "4 rue de Rome") {
                    placemarks, error in
                    let placemark = placemarks?.first
                    self.lat = placemark?.location?.coordinate.latitude ?? 12
                    self.lon = placemark?.location?.coordinate.longitude ?? 22
                    let centerCoordinate = CLLocationCoordinate2D(latitude: self.lat, longitude:self.lon)
                    annotation.coordinate = centerCoordinate
                    annotation.title = data.fields.name
                }
                

            }
            
            let url = URL(string: data.fields.image![0].url ?? "https://dl.airtable.com/HQImgZcSSkSwnuv7ir8R_rose-pavilion%202.jpeg")

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.backgroundImg.image = UIImage(data: data!)
                }
            }
        }
        
        
        if let topic = schedule.fields.topic{
            Airtable.getTopic(from: Airtable.topicsLink + "/" + topic[0] + Airtable.key){
                 data in
                
                DispatchQueue.main.async {
                    self.topicLbl.text = data
                }
                
            }
        }
        else{
            self.topicLbl.text = ""
        }
        
        self.speakersLbl.text = ""
        
        if let speakers = schedule.fields.speakers{
            
            for speaker in speakers {
                Airtable.getSpeaker(from: Airtable.speakersLink + "/" + speaker + Airtable.key) {data in
                    DispatchQueue.main.async {
                        self.speakersLbl.text! += data + ", "
                        
                    }
                }
            }

            
        }
        else{
            self.speakersLbl.text = "No Speakers available"
        }
        
        

        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: schedule.fields.start ?? "2017-01-09T11:00:00.000Z")!
        let calanderDate = Calendar.current.dateComponents([.minute,.hour,.day, .year, .month], from: date)
        let dateEnd = dateFormatter.date(from: schedule.fields.end ?? "2017-01-09T11:00:00.000Z")!
        let calanderDateEnd = Calendar.current.dateComponents([.minute,.hour,.day, .year, .month], from: dateEnd)
        dateLbl.text = calanderDate.day!.description + "/" + calanderDate.month!.description + "/" + calanderDate.year!.description
        
       
        
        startLbl.text = calanderDate.hour!.description + "h" + calanderDate.minute!.description
        endLbl.text = calanderDateEnd.hour!.description + "h" + calanderDateEnd.hour!.description
        if(calanderDate.minute == 0){
            startLbl.text! += "0"
        }
        if(calanderDateEnd.minute == 0){
           endLbl.text! += "0"
        }
        
        
        

        dateView.layer.cornerRadius = 12
        dateLbl.layer.cornerRadius = 12
        dateLbl.layer.masksToBounds = true
        dateLbl.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
   
        locationLbl.layer.cornerRadius = 15
        locationLbl.layer.masksToBounds = true
        
        titleLbl.text = schedule.fields.activity
        typeLbl.text = schedule.fields.type
        

    }
    
    @IBAction func goThereTapped(_ sender: Any) {
        
        
        let coordinate = CLLocationCoordinate2DMake(lat,lon)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = locationLbl.text
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }


}
