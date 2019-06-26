import UIKit
import FSCalendar
import CalculateCalendarLogic

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UITextViewDelegate{
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var textview: UITextView!
    
    var delegate: UITextViewDelegate!
    
    @IBOutlet weak var button: UIButton!
    
    var currentDate: Date? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.textview.delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textview.frame = CGRect(x: 0.0, y: -20.0, width: 375.0, height: 237.0)
        if let date = self.currentDate{
            UserDefaults.standard.set(textview.text!, forKey:date.description)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.textview.frame = CGRect(x: 0.0, y: -100.0, width: 375.0, height: 237.0)

//        let button = UIButton()//この場所を変える
//        button.setTitle("保存", for: .normal)
//        button.tintColor = UIColor.black
//        button.backgroundColor = UIColor.gray
//        button.frame = CGRect(x: 365.0, y: 435.0, width: 50.0, height: 30.0)
//        self.view.addSubview(button)
//        button.layer.cornerRadius = 10
        button.isHidden = false
        
        if text == "\n" {
            button.isHidden = true
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //    @IBAction func touch(_ sender: Any) {
    
    //    }
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
        
        //UserDefaults.standard.set("this is a test", forKey: date.description + "text")
        
        
        //let str = UserDefaults.standard.string(forKey: date.description + "text")
        
        //self.label.text = str
        
        //let anyDate = UserDefaults.standard.object(forKey: date.description + "date")
        
        //        if let date = anyDate as? Date {
        //            self.label2.text = date.description
        //            //let str = UserDefaults.standard.string(forKey: date.description)
        //        }
        
        self.currentDate = date
        
        let str = UserDefaults.standard.string(forKey: date.description )
        
        self.textview.text = str
        
        //print(self.textview.frame) 座標表示
        
        
        
    }
}
