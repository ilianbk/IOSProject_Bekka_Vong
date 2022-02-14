import UIKit

class TaskBarView: UITabBarController {
    
    var tabBarIteam = UITabBarItem()
    
    var homeIcon = UIImageView(image: UIImage(systemName:  "square.and.pencil"))
    var companyIcon = UIImageView(image: UIImage(systemName:  "pencil.slash"))
    var speakersIcon = UIImageView(image: UIImage(systemName:  "person.3"))
    var barView = UIView()
    
    enum IsSelected {
        case home
        case company
        case speaker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.frame.origin.y = self.tabBar.frame.origin.y - 15
        
        let homeView = UIView(frame: CGRect.init(x: self.tabBar.frame.minX, y: self.tabBar.frame.minY, width: tabBar.frame.width / 3, height: tabBar.frame.height + 15))
       homeView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(homeSelected)))
        homeView.backgroundColor = UIColor.black
        
        barView = UIView(frame: CGRect.init(x: 0, y: self.tabBar.frame.maxY - 5, width: tabBar.frame.width / 3, height: 5))
        
        barView.backgroundColor = UIColor.black
        homeIcon.frame =  CGRect(x: homeView.frame.width/3 , y: homeView.frame.height/8, width: homeView.frame.width/2.5, height: homeView.frame.width/3 )
        

        
        homeView.addSubview(homeIcon)
       
        let companiesView = UIView(frame: CGRect.init(x: self.tabBar.frame.minX + tabBar.frame.width / 3 , y: self.tabBar.frame.minY, width: tabBar.frame.width / 3, height: tabBar.frame.height + 15))
        
       companiesView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(companiesSelected)))
        companiesView.backgroundColor = UIColor.black
        
        companyIcon.frame = CGRect(x: companiesView.frame.width/3 , y: companiesView.frame.height/8, width: companiesView.frame.width/2.5, height: companiesView.frame.width/3)
        
        companyIcon.contentMode = .scaleToFill
        companiesView.addSubview(companyIcon)
        
        let speakersView = UIView(frame: CGRect.init(x: self.tabBar.frame.minX + (tabBar.frame.width / 3) * 2 , y: self.tabBar.frame.minY, width: tabBar.frame.width / 3, height: tabBar.frame.height  + 15))
       speakersView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(speakersSelected)))
        speakersView.backgroundColor = UIColor.black
        
        speakersIcon.frame = CGRect(x: speakersView.frame.width/3 , y: speakersView.frame.height/8, width: speakersView.frame.width/2.5, height: speakersView.frame.width/3)
   
        
        
        speakersView.addSubview(speakersIcon)
        
        
        
        
        
        homeIcon.tintColor = UIColor(named: "white")
        companyIcon.tintColor = UIColor(named: "white")
        speakersIcon.tintColor = UIColor(named: "white")
        
        barView.backgroundColor = UIColor(named: "black")
        
        
        
        self.view.insertSubview(homeView, belowSubview: self.view)
        self.view.insertSubview(speakersView, belowSubview: self.view)
        self.view.insertSubview(companiesView, belowSubview: self.view)
        self.view.insertSubview(barView, belowSubview: self.view)
        
    }
    
    
   @objc func homeSelected(){

       self.selectedIndex = 0
   }
    @objc func companiesSelected(){
 
        self.selectedIndex = 1
    }
 
    @objc func speakersSelected(){
 
        self.selectedIndex = 2
    }
    

}

