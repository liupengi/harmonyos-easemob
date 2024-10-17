import { ChatMessage, TextMessageBody, ChatClient, ImageMessageBody, ChatCallback, ChatLog,
  VideoMessageBody } from '@easemob/chatsdk';
import { fileUri } from '@kit.CoreFileKit';
import TimeConversion from '../../../utils/TimeConversion';

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
  .margin({left:10})
}

@Component
export struct MessageVideoItem {
  @State data: ChatMessage | undefined = undefined;
  aboutToReuse(params: Record<string, Object>): void {
    this.data = params.data as ChatMessage;
  }

  getThumbnailLocalPath() {
    if (this.data) {
      let txtBody = this.data.getBody() as VideoMessageBody;
      if (txtBody) {
        ChatLog.d("======"+txtBody.getThumbnailLocalPath())
        return txtBody.getThumbnailLocalPath()
      }
    }
    return undefined;
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
          Stack({alignContent:Alignment.Center}){
            if (this.getThumbnailLocalPath() === undefined) {
              Image($r('app.media.ease_chat_image_normal'))
                .VideoStyles()
            } else {
              Image(fileUri.getUriFromPath((this.data?.getBody() as VideoMessageBody).getThumbnailLocalPath()))
                .VideoStyles()
              Image($r('app.media.ease_video_play_btn_small_nor'))
                .width(50)
                .height(50)
                .zIndex(1)

            }

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
          Stack({alignContent:Alignment.Center}){
            if (this.getThumbnailLocalPath() === undefined) {
              Image($r('app.media.ease_chat_image_normal'))
                .VideoStyles()
            } else {
              Image(fileUri.getUriFromPath((this.data?.getBody() as VideoMessageBody).getThumbnailLocalPath()))
                .VideoStyles()
              Image($r('app.media.ease_video_play_btn_small_nor'))
                .width(50)
                .height(50)
                .zIndex(1)

            }

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
}