import UIKit
import FSCalendar
import CalculateCalendarLogic
import Photos

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UITextViewDelegate{
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var storagebutton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: UITextViewDelegate!
    var photoAssets = [PHAsset]()

    var currentDate: Date? = nil
    var responder = false

    
    @IBAction func StorageButton(_ sender: Any) {
        if let date = self.currentDate{
            UserDefaults.standard.set(textview.text!, forKey:date.description)
        }
        
        storagebutton.isHidden = true
        self.responder = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.textview.delegate = self
        
//        let fetchOptions = PHFetchOptions()
////        fetchOptions.predicate = NSPredicate(format: "title = %@", "Camera Roll")
//        let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: fetchOptions)
//        if collection.firstObject != nil {
//            // 取得成功(->collection.firstObject)
//            print("success")
//            if let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil) {
//                assets.enumerateObjects({ (asset, index, stop) in
//                    print(asset)
//
//                    let manager = PHImageManager.default()
//                    manager.requestImage(for: asset, targetSize: self.imageView.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
//                            self.imageView.image = image
//                    })
//                })
//            }
//
//        } else {
//            // 取得失敗
//            print("fail")
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textview.frame = CGRect(x: 0.0, y: -20.0, width: 375.0, height: 237.0)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.textview.frame = CGRect(x: 0.0, y: -100.0, width: 275.0, height: 237.0)

        storagebutton.isHidden = false
        self.view.bringSubview(toFront: storagebutton)
        
        if self.responder == true
        {
            textView.resignFirstResponder()
            self.responder = false
        }
//        if text == "\n" {
//            button.isHidden = true
//            textView.resignFirstResponder()
//            return false
//        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.currentDate = date
        
        let str = UserDefaults.standard.string(forKey: date.description )
        
        self.textview.text = str
        
        //print(self.textview.frame) 座標表示
        
    }
}
