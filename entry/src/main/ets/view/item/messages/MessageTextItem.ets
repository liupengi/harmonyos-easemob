import { ChatMessage, TextMessageBody, ChatClient, ImageMessageBody, ChatCallback, ChatLog } from '@easemob/chatsdk';
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

@Component
export struct MessageTextItem {
  @State data: ChatMessage | undefined = undefined;
  aboutToReuse(params: Record<string, Object>): void {
    this.data = params.data as ChatMessage;
  }

  getText() {
    if (this.data) {
      let txtBody = this.data.getBody() as TextMessageBody;
      if (txtBody) {
        return txtBody.getContent();
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
          Text(this.getText())
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .backgroundColor('#e6f5ff')
            .padding(10)
          Text(this.getTime())
            .fontSize(12)
            .fontColor(Color.Gray)
        }

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
          Text(this.getText())
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .backgroundColor('#e6f5ff')
            .padding(10)
            .margin({ left: 10 })
          Text(this.getTime())
            .fontSize(12)
            .fontColor(Color.Gray)

        }


      }
      .fillScreen()
    }
  }
}