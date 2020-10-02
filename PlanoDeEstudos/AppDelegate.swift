import UIKit
import UserNotifications

struct ActionIdentifier
{
    static let confirm = "Confirm"
    static let cancel = "Cancel"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        center.delegate = self
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus{
            //case .authorized:
                
            case .notDetermined:
                //requisição de permissão
                self.center.requestAuthorization(options: [.alert, .sound, .badge, .carPlay]) { (authorized, error) in
                    if error ==  nil{
                        print(authorized)
                    }
                }
            default:
                break
            }
        }
        //Regsitra o device na apple para receber notificacoes remotas
        application.registerForRemoteNotifications()
        
        
        
        let confirmAction = UNNotificationAction(identifier: ActionIdentifier.confirm, title: "já estudei", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: ActionIdentifier.cancel, title: "Cancelar", options: [])
        //Identifier deve ser o mesmo que foi definido StudyPlanViewController
        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction, cancelAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "Larga a mao de ser xereta", options: [.customDismissAction])
        center.setNotificationCategories([category])
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Pega byte a byte os dados do token
        let token = deviceToken.reduce("") {
            $0 + String(format: "%02x", $1)
        }
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate{
    // Para mostrar a notificação com o app aberto
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound,])
    }
    
    //Acionado quando o usuario clica na notificacao
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let id = response.notification.request.identifier
        let title = response.notification.request.content.title
        print("ID:", id, "Title:", title)
        
        switch response.actionIdentifier {
        case ActionIdentifier.confirm:
            //usuario tocou no botao confirma
            
            NotificationCenter.default.post(name: NSNotification.Name("Confirmed"), object: nil, userInfo: ["id": id])
            break;
        case ActionIdentifier.cancel:
            //usuario tocou no botao cancelar
            break;
        case UNNotificationDefaultActionIdentifier:
            //usuario tocou na notificacao em si
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Orange")
            
            window?.rootViewController?.show(vc, sender: nil)
            break;
        case UNNotificationDismissActionIdentifier:
            //usuario fechou (dismiss) a notificacao
            break;
        default:
            //
            break;
        }
        
        completionHandler()
        
    }
}
