import { ChatMessage, TextMessageBody, ChatClient, ImageMessageBody, ChatCallback, ChatLog } from 'easemob';
import { fileUri } from '@kit.CoreFileKit';
import TimeConversion from '../../../utils/TimeConversion';
import { router } from '@kit.ArkUI';

//全局公共样式
@Styles
function fillScreen() {
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(20)
  .padding(10)
}

@Styles
function VideoStyles() {
  .width(180)
  .height(180)
  .margin({ left: 10 })
}

@Component
export struct MessageImageItem {
  @State data: ChatMessage | undefined = undefined;

  aboutToReuse(params: Record<string, Object>): void {
    this.data = params.data as ChatMessage;
  }

  getText() {
    if (this.data) {
      let txtBody = this.data.getBody() as ImageMessageBody;
      if (txtBody) {
        return txtBody.getLocalPath();
      }
    }
    return '';
  }
  getTime(): string | undefined{
    if (this.data){
      return TimeConversion.getTime(this.data.getServerTimestamp())
    }
    return ''
  }
  build() {
    if (this.data?.getFrom() === ChatClient.getInstance().getCurrentUser()) {
      Row() {
        Column(){
          if ((this.data?.getBody() as ImageMessageBody).getLocalPath() === undefined) {
            Image($r('app.media.ease_chat_image_normal'))
              .VideoStyles()
          } else {
            Image((this.data?.getBody() as ImageMessageBody).getLocalPath())
              .VideoStyles()
              .onClick(()=>{
                this.ImageClick(true)
              })
          }
          Text(this.getTime())
            .fontSize(12)
            .fontColor(Color.Gray)
        }
        .alignItems(HorizontalAlign.End)


        Image($r("app.media.ease_default_avatar_1"))
          .width(35)
          .height(35)
          .margin({ left: 10 })
      }
      .justifyContent(FlexAlign.End)
      .fillScreen()

    } else {
      Row() {
        Image($r("app.media.ease_default_avatar_1"))
          .width(35)
          .height(35)
        Column(){
          if ((this.data?.getBody() as ImageMessageBody).getThumbnailLocalPath() === undefined) {
            Image($r('app.media.ease_chat_image_normal'))
              .VideoStyles()
          } else {

            Image(fileUri.getUriFromPath((this.data?.getBody() as ImageMessageBody).getThumbnailLocalPath()))
              .VideoStyles()
              .onClick(()=>{
                this.ImageClick(false)
              })

          }

          Text(this.getTime())
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({ left: 10 })
        }
        .alignItems(HorizontalAlign.Start)




      }
      .fillScreen()
    }
  }
   ImageClick(isSend:boolean) {
     router.pushUrl({
       url: "pages/BigShowPage",
       params: { msgId: (this.data?.getMsgId()),isSend:isSend}
     })
  }

}