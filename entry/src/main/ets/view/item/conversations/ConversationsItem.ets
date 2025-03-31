import { it } from '@ohos/hypium';
import { ChatClient, ChatLog, Conversation } from '@easemob/chatuikit';
import TimeConversion  from '../../../utils/TimeConversion';

//全局公共样式
@Styles
function fillScreen() {
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(20)
  .padding(10)
}

@Component
export struct ConversationsItem {
  @State item: Conversation | undefined = undefined;
  @State time :number|undefined  = undefined

  getConversationsId() {
    if (this.item) {
      return this.item.conversationId()
    }
    return '';
  }
  getConversationsUnread() {
    if (this.item) {
      if (this.item.getUnreadMsgCount() > 0) {
        return this.item.getUnreadMsgCount()
      }
    }
    return '';
  }
  getConversationsType() {
    if (this.item) {
      ChatLog.d("会话类型："+ChatClient.getInstance().chatManager()?.getConversation(this.item.conversationId())?.getType()+"====会话id："+ChatClient.getInstance().chatManager()?.getConversation(this.item.conversationId())?.conversationId())
      return ChatClient.getInstance().chatManager()?.getConversation(this.item.conversationId())?.getType()
    }
    return '';
  }


  getTime(): string | undefined{
    if (this.item){
      return TimeConversion.getTime(this.item?.getLatestMessage()?.getServerTimestamp())
  }
    return ''
}



   build() {
    Row() {
      if (this.getConversationsType()===0){
        Image($r("app.media.ease_default_avatar_1"))
          .width(50)
          .height(50)
      }else if (this.getConversationsType()===1){
        Image($r("app.media.ease_default_group_avatar"))
          .width(50)
          .height(50)
      }

      Column({ space: 4 }) {
        Row() {
          Text(this.getConversationsId())
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Blank()
          if (this.getConversationsUnread()>0){
            Button() {
              Text(this.getConversationsUnread() + "")
                .fontColor(Color.White)
                .align(Alignment.Center)

            }
            .width(18)
            .height(18)
            .type(ButtonType.Circle)
            .backgroundColor(Color.Red)
            .fontColor(Color.White)
            .margin({ right: 55 })
          }

        }
        .width('100%')

        Row() {
          if (this.item?.getLatestMessage()?.getType() === 0) {

            // todo  Text((this.item?.getLatestMessage()?.getBody()?.getBody() as EMTextMessageBody).text())
            // Text((this.item?.getLatestMessage()?.getBody()?.getBody() as EMTextMessageBody).text())
            //   .fontSize(20)
            //   .fontWeight(FontWeight.Bold)
          } else if (this.item?.getLatestMessage()?.getType() === 1) {
            Text('[图片消息]')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
          }

          Blank()

          Text(this.getTime())
            .fontSize(10)
            .align(Alignment.End)
            .margin({ right: 50 })

        }
        .width('100%')

      }

      .alignItems(HorizontalAlign.Start)
      .padding({ left: 10 })
    }
    .fillScreen()
  }
}