import { Contact, Conversation, Group } from 'easemob';
import { EMTextMessageBody } from 'easemob/src/main/cpp/types/libhyphenate';

//全局公共样式
@Styles
function fillScreen() {
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(20)
  .padding(10)
}

@Component
export struct GroupListItem {
  @State item: Group | undefined = undefined;

  getUserId() {
    if (this.item) {
      return this.item.groupId()
    }
    return '';
  }


  build() {
    Row() {
      Image($r("app.media.ease_default_group_avatar"))
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