import { Contact, Conversation } from '@easemob/chatsdk';

//全局公共样式
@Styles
function fillScreen() {
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(20)
  .padding(10)
}

@Component
export struct ContactItem {
  @State item: Contact | undefined = undefined;

  getUserId() {
    if (this.item) {
      return this.item.remark() === "" ? this.item.userId() : this.item.remark()
    }
    return '';
  }


  build() {
    Row() {
      Image($r("app.media.ease_default_avatar_1"))
        .width(50)
        .height(50)
      Column({ space: 4 }) {
        Text(this.getUserId())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

      }
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 10 })
    }
    .fillScreen()
  }
}