import { ContactComponent } from '../view/main/ContactComponent'
import { MeComponent } from '../view/main/MeComponent'
import { ConversationsComponent } from '../view/main/ConversationsComponent'
import UserInfoModel from '../utils/db/UserInfoModel'
import { ChatClient, ChatLog } from 'easemob'

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0
  @State show: boolean = true
  private tabsController: TabsController = new TabsController()

  aboutToAppear(): void {

    ChatLog.d("MainPage========aboutToAppear========")
    UserInfoModel.initUserInfoDB(getContext(), ChatClient.getInstance().getCurrentUser())
  }

  @Builder
  TabBuilder(title: string, targetIndex: number, normalImg: Resource, selectedImg: Resource) {
    Column() {
      Image(this.currentIndex == targetIndex ? selectedImg : normalImg)
        .width(28)
        .height(28)
      Text(title)
        .fontSize(14)
        .margin({ top: 4 })
        .fontColor(this.currentIndex == targetIndex ? '#33b1ff' : '#999999')
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(this.currentIndex)
    })
  }

  onPageHide(): void {
    this.show = false
    console.info("MainPage========onPageHide========")
  }

  onPageShow(): void {
    this.show = true
    console.info("MainPage========onPageShow========")
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.tabsController, index: 0 }) {
        TabContent() {
          if (this.show) {
            ConversationsComponent()
          }

        }
        .tabBar(this.TabBuilder('消息', 0, $r("app.media.em_main_tab_conversation"),
          $r("app.media.em_main_tab_conversation_selected")))
        .borderWidth({bottom:1})
        .borderColor("#e7e9eb")

        TabContent() {
          ContactComponent()
        }
        .tabBar(this.TabBuilder('通讯录', 1, $r("app.media.em_main_tab_friends"),
          $r("app.media.em_main_tab_friends_selected")))
        .borderWidth({bottom:1})
        .borderColor("#e7e9eb")

        TabContent() {
          MeComponent()
        }.tabBar(this.TabBuilder('我的', 2, $r("app.media.em_main_tab_me"), $r("app.media.em_main_tab_me_selected")))
        .borderWidth({bottom:1})
        .borderColor("#e7e9eb")

      }
      .scrollable(false) //去掉左右滑动的效果
      .animationDuration(0) //去掉左右滑动的动画

    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')

  }
}

