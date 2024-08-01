import { Header } from '../Header'
import { ChatClient, ChatError, ChatLog, Contact, Conversation } from 'easemob'
import { promptAction, router } from '@kit.ArkUI'
import { ContactItem } from '../item/contact/ContactItem'

//全局公共样式
@Styles
function fillScreen() {
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(20)
  .height(120)
  .padding(10)
}

@Component
export struct ContactComponent {
  @Prop contacts: Contact[]
  @Prop isFetchContactsFromServer: boolean = false

  aboutToAppear(): void {

    ChatClient.getInstance().contactManager()?.getContactsFromLocal().then(result => {
      if (result.length > 0) {
        this.contacts = result;
      } else {
        ChatClient.getInstance().contactManager()?.fetchAllContactsFromServer().then(contacts => {
          this.contacts = contacts;
          // success logic
        }).catch((e: ChatError) => {
          ChatLog.d("服务端获取好友失败：" + e.errorCode + "====" + e.description.toString())
        });
      }
      // success logic
    }).catch((e: ChatError) => {
      ChatLog.d("本地获取好友失败：" + e.errorCode + "====" + e.description.toString())
    });


  }

  build() {
    Column({ space: 8 }) {
      Header({ title: "通讯录", isReturn: false, isAdd: true })
        .padding(20)

      Row(){
        Text("新请求")

        Image($r('app.media.ease_presence_arrow_left'))
          .width(20)
          .height(25)
          .padding(3)
      }
      .width('100%')
      .height(40)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left:10,right:10})

      Row(){
        Text("群组")
        Image($r('app.media.ease_presence_arrow_left'))
          .width(20)
          .height(25)
          .padding(3)
      }
      .width('100%')
      .height(40)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left:10,right:10})

      List({ space: 8 }) {
        ForEach(
          this.contacts,
          (item: Contact) => {
            ListItem() {
              //this.ItemCard(item)
              ContactItem({item:item})
            }
            .onClick(() => {
              router.pushUrl({
                url: "pages/ChatPage",
                params: { conversationId: item.userId() }
              })
              promptAction.showToast({

                message: "点击了" + item.userId() + "会话"
              })
            })

          }
        )
      }
      .width('100%')
      .layoutWeight(1)
      .divider({
        strokeWidth:1,
        startMargin:55

      })

    }

  }

  //全局自定义构建函数
  @Builder
  ItemCard(item: Contact) {
    Row() {
      Image($r("app.media.ease_default_avatar_1"))
        .width(50)
        .height(50)
      Column({ space: 4 }) {
        Text(item.remark() === "" ? item.userId() : item.remark())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

      }
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 10 })
    }
    .fillScreen()
  }
}
