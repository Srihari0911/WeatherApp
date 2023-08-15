import UIKit

class initialTableViewCell: UITableViewCell {
    
    @IBOutlet var txt_title: UILabel!
    @IBOutlet var txt_subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set initial alpha to 0 to prepare for fade-in animation
        txt_title.alpha = 0
        txt_subtitle.alpha = 0
    }
    
    func setData(model: CityDb) {
        // Set data while animating the fade-in effect
        UIView.animate(withDuration: 0.5) {
            self.txt_title.text = model.cityName
            self.txt_subtitle.text = model.countryName
            
            // Fade-in effect
            self.txt_title.alpha = 1
            self.txt_subtitle.alpha = 1
        }
    }
}
