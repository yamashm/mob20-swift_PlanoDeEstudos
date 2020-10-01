import UIKit
import UserNotifications

class StudyPlanViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfCourse: UITextField!
    @IBOutlet weak var tfSection: UITextField!
    @IBOutlet weak var dpDate: UIDatePicker!
    
    // MARK: - Properties
    let sm = StudyManager.shared
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    @IBAction func schedule(_ sender: UIButton) {
        //Universally unique identifier
        let id = UUID().uuidString
        //Outra forma náo muito profissional de gerar um id seria contar os segundos desde 1970
        //let id = String(Date().timeIntervalSince1970)
        let studyPlan = StudyPlan(course: tfCourse.text!, section: tfSection.text!, date: dpDate.date, done: false, id: id)
        
        let content = UNMutableNotificationContent()
        content.title = "Lembrete"
        content.subtitle = "Matéria: \(studyPlan.course)"
        content.body = "Estudar: \(studyPlan.section)"
        //som da notificação a partir de um arquivo de som
        //content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: ""))
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "Lembrete"
        
        //Para usar o repeats, o timeinterval deve ser maior ou igual a 60 segundos
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request  = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        sm.addPlan(studyPlan)
        navigationController!.popViewController(animated: true)
    }
    
}
