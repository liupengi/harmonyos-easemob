import notificationManager from '@ohos.notificationManager'
import { ChatLog } from '@easemob/chatsdk'
import { BusinessError } from '@kit.BasicServicesKit'

class Notification{
  //构建发送通知

  SendNotification(title:string,text:string){
    let request :notificationManager.NotificationRequest = {
      id: 1,
      content: {
        notificationContentType:notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal:{
          title:title,
          text:text
        }
      }
    }
    this.publish(request)
  }
  private publish(request:notificationManager.NotificationRequest){
    notificationManager.publish(request, (err: BusinessError) => {
      if (err) {
        ChatLog.d("通知发送失败"+  `Failed to publish notification. Code is ${err.code}, message is ${err.message}`)
        return;
      }
      ChatLog.d("通知发送成功")
    });

  }
}
let notification = new Notification()
export default notification as Notification