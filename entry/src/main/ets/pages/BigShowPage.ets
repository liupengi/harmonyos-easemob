import { router } from '@kit.ArkUI'
import { fileUri } from '@kit.CoreFileKit';
import { ChatClient, ChatLog, ImageMessageBody } from '@easemob/chatuikit';

@Entry
@Component
struct BigShowPage {
  @State params: object = router.getParams()
  aboutToAppear(): void {
    ChatLog.d("==="+(ChatClient.getInstance().chatManager()?.getMessage(this.params['msgId'])?.getBody() as ImageMessageBody).getThumbnailLocalPath())
  }
  build() {
    Row(){
      if (this.params['isSend']){
        Image((ChatClient.getInstance().chatManager()?.getMessage(this.params['msgId'])?.getBody() as ImageMessageBody).getThumbnailLocalPath())

      }else {
        Image(fileUri.getUriFromPath((ChatClient.getInstance().chatManager()?.getMessage(this.params['msgId'])?.getBody() as ImageMessageBody).getThumbnailLocalPath()))

      }

    }
    .width('100%')
    .height('100%')
  }
}