import { ChatMessage, TextMessageBody, ChatClient, ImageMessageBody, ChatCallback, ChatLog } from 'easemob';
import { fileUri } from '@kit.CoreFileKit';

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

      if (this.data.getBody()?.type()===0){
        let txtBody = this.data.getBody() as TextMessageBody;
        if (txtBody) {
          return txtBody.getContent();
        }
      }else if (this.data.getBody()?.type()===2){
        let callback: ChatCallback = {
          onSuccess: (): void => {
            // 附件下载成功
          },
          onError: (code: number, error: string): void => {
            // 附件下载失败
          },
          onProgress: (progress: number): void => {
            // 附件下载进度
            ChatLog.d("下载进度======"+progress)
          }
        }
        //this.data.setMessageStatusCallback(callback);
        // 下载附件
        ChatClient.getInstance().chatManager()?.downloadAttachment(this.data);
        return "视频消息测试"
      }



    }
    return '';
  }
  build() {
    if (this.data?.getFrom() === ChatClient.getInstance().getCurrentUser()) {
      Row() {
        if (this.data?.getType() === 0) {
          Text(this.getText())
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .backgroundColor('#EFEFEF')
            .padding(10)
        } else if (this.data?.getType() === 1) {
          if ((this.data?.getBody() as ImageMessageBody).getLocalPath() === undefined) {
            Image($r('app.media.ease_chat_image_normal'))
              .width(100)
              .height(80)
          } else {
            Image((this.data?.getBody() as ImageMessageBody).getLocalPath())
              .width(100)
              .height(80)
          }
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
        if (this.data?.getType() === 0) {
          Text(this.getText())
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .backgroundColor('#EFEFEF')
            .padding(10)
            .margin({ left: 10 })
        } else if (this.data?.getType() === 1) {
          if ((this.data?.getBody() as ImageMessageBody).getThumbnailLocalPath() === undefined) {
            Image($r('app.media.ease_chat_image_normal'))
              .width(100)
              .height(80)
          } else {
            Image(fileUri.getUriFromPath((this.data?.getBody() as ImageMessageBody).getThumbnailLocalPath()))
              .width(100)
              .height(80)
          }
        }else if (this.data?.getType() === 2){
          Text(this.getText())
        }
      }
      .fillScreen()
    }
  }
}