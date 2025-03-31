import { Contact, Conversation, Group } from '@easemob/chatuikit';

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

  getGroupId() {
    if (this.item) {
      return this.item.groupId()
    }
    return '';
  }

  getGroupName() {
    if (this.item) {
      return this.item.groupName()
    }
    return '';
  }
  build() {
    Row() {
      Image($r("app.media.ease_default_group_avatar"))
        .width(50)
        .height(50)
      Column({ space: 4 }) {
        Text(this.getGroupName())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text(this.getGroupId())
          .fontSize(15)


      }
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 10 })
    }
    .fillScreen()
  }
}