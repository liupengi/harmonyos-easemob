import { MeComponent } from '../view/main/MeComponent'
import { ContactListPage, ConversationListPage } from '@easemob/chatuikit'

@Entry
@ComponentV2
struct MainPage {
  pathStack: NavPathStack = new NavPathStack();
  @Local pageIndex: number = 0;

  build() {
    Navigation(this.pathStack) {
      if (this.pageIndex === 0) {
        ConversationListPage({
          pathStack: this.pathStack
        });
      } else if (this.pageIndex === 1) {
        ContactListPage({
          pathStack: this.pathStack
        })
      } else if (this.pageIndex === 2) {
        MeComponent()
      }
    }
    .height('100%')
    .hideTitleBar(true)
    .toolbarConfiguration([
      {
        value: "消息",
        status: this.pageIndex == 0 ? ToolbarItemStatus.ACTIVE : ToolbarItemStatus.NORMAL,
        icon: $r("app.media.em_main_tab_conversation"),
        activeIcon: $r('app.media.em_main_tab_conversation_selected'),
        action: () => {
          this.pageIndex = 0;
        }
      },
      {
        value: "通讯录",
        status: this.pageIndex == 1 ? ToolbarItemStatus.ACTIVE : ToolbarItemStatus.NORMAL,
        icon: $r("app.media.em_main_tab_friends"),
        activeIcon: $r('app.media.em_main_tab_friends_selected'),
        action: () => {
          this.pageIndex = 1;
        }
      },
      {
        value: "我的",
        status: this.pageIndex == 2 ? ToolbarItemStatus.ACTIVE : ToolbarItemStatus.NORMAL,
        icon: $r("app.media.em_main_tab_me"),
        activeIcon: $r('app.media.em_main_tab_me_selected'),
        action: () => {
          this.pageIndex = 2;
        }
      }
    ])
  }

  // pathStack: NavPathStack = new NavPathStack();
  // @State currentIndex: number = 0
  // @State show: boolean = true
  // private tabsController: TabsController = new TabsController()
  //
  // aboutToAppear(): void {
  //
  //   ChatLog.d("MainPage========aboutToAppear========")
  //
  //   UserInfoModel.initUserInfoDB(getContext(), ChatClient.getInstance().getCurrentUser())
  // }
  //
  // @Builder
  // TabBuilder(title: string, targetIndex: number, normalImg: Resource, selectedImg: Resource) {
  //   Column() {
  //     Image(this.currentIndex == targetIndex ? selectedImg : normalImg)
  //       .width(28)
  //       .height(28)
  //     Text(title)
  //       .fontSize(14)
  //       .margin({ top: 4 })
  //       .fontColor(this.currentIndex == targetIndex ? '#33b1ff' : '#999999')
  //   }
  //   .width('100%')
  //   .height(60)
  //   .justifyContent(FlexAlign.Center)
  //   .onClick(() => {
  //     this.currentIndex = targetIndex
  //     this.tabsController.changeIndex(this.currentIndex)
  //   })
  // }
  //
  // onPageHide(): void {
  //   this.show = false
  //   console.info("MainPage========onPageHide========")
  // }
  //
  // onPageShow(): void {
  //   this.show = true
  //   console.info("MainPage========onPageShow========")
  // }
  //
  // build() {
  //   Column() {
  //     Tabs({ barPosition: BarPosition.End, controller: this.tabsController, index: 0 }) {
  //       TabContent() {
  //         if (this.show) {
  //           ConversationListPage(
  //
  //           )
  //         }
  //
  //       }
  //       .tabBar(this.TabBuilder('消息', 0, $r("app.media.em_main_tab_conversation"), $r("app.media.em_main_tab_conversation_selected")))
  //       .borderWidth({bottom:1})
  //       .borderColor("#e7e9eb")
  //
  //       TabContent() {
  //         ContactListPage()
  //       }
  //       .tabBar(this.TabBuilder('通讯录', 1, $r("app.media.em_main_tab_friends"), $r("app.media.em_main_tab_friends_selected")))
  //       .borderWidth({bottom:1})
  //       .borderColor("#e7e9eb")
  //
  //       TabContent() {
  //         ChatPage()
  //       }
  //       .tabBar(this.TabBuilder('我的', 2, $r("app.media.em_main_tab_me"), $r("app.media.em_main_tab_me_selected")))
  //       .borderWidth({bottom:1})
  //       .borderColor("#e7e9eb")
  //
  //     }
  //     .scrollable(false) //去掉左右滑动的效果
  //     .animationDuration(0) //去掉左右滑动的动画
  //
  //   }
  //   .backgroundColor(Color.White)
  //   .width('100%')
  //   .height('100%')
  //
  // }
}

