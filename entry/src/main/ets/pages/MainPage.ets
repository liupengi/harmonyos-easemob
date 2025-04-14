import { MeComponent } from '../view/main/MeComponent'
import { ChatClient, ChatError, ContactListPage, ConversationListPage, UserInfoType,ChatUIKitClient, ChatUserProfile,ChatGroupProfile,
  ChatLog} from '@easemob/chatuikit'
import { ConversationsPage } from '../view/main/ConversationsPage';
import { ContactsPage } from '../view/main/ContactsPage';
import UserInfoModel from '../utils/UserInfoModel';
import { taskpool } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import UserInfo from '../utils/UserInfo';

@Entry
@ComponentV2
struct MainPage {

  pathStack: NavPathStack = new NavPathStack();
  @Local pageIndex: number = 0;

  onPageShow(): void {
    ChatLog.d(`================>onPageShow`)
  }

  async aboutToAppear(): Promise<void> {



    //
    // ChatUIKitClient.setProfileProvider({
    //   fetchProfile: (userId?: string | string[],
    //     groupId?: string | undefined): Promise<ChatUserProfile | ChatUserProfile[] | ChatGroupProfile> => {
    //     return new Promise((resolve)=> {
    //       if (typeof userId === 'undefined') {
    //         if (groupId) {
    //           // 处理获取群组信息的逻辑
    //           let info = new ChatGroupProfile();
    //           resolve(info);
    //         }
    //       } else if (typeof userId === 'string') {
    //         // 处理获取单个联系人信息的逻辑
    //         let user = new ChatUserProfile();
    //         resolve(user);
    //       } else {
    //         ChatLog.d(`================>setProfileProvider`)
    //         // 处理获取多个联系人信息的逻辑
    //         let result: ChatUserProfile[] = [];
    //         for (let index = 0; index < userId.length; index++) {
    //           const userid = userId[index];
    //           ChatLog.d(`================>setProfileProvider------>${userid}`)
    //         // let userInfo :UserInfo = UserInfoModel.getUserInfo(userid)
    //           let user = new ChatUserProfile();
    //           user.id = userid;
    //           user.name = "测试昵称展示"
    //           user.avatar ="https://accktvpic.oss-cn-beijing.aliyuncs.com/pic/sample_avatar/sample_avatar_4.png"
    //          // ChatLog.d(`================>${userInfo.nickname}===========${userInfo.avatarurl}`)
    //           result.push(user)
    //         }
    //         resolve(result);
    //       }
    //     })
    //   }
    // })

    ChatUIKitClient.setProfileProvider({
      fetchProfile: (userId?: string | string[],
        groupId?: string | undefined): Promise<ChatUserProfile | ChatUserProfile[] | ChatGroupProfile> => {
        return new Promise((resolve)=> {


          if (typeof userId === 'undefined') {
            if (groupId) {
              // 处理获取群组信息的逻辑

              let info = new ChatGroupProfile();

              resolve(info);
            }
          } else if (typeof userId === 'string') {
            ChatLog.d("setProfileProvider--------->====")
            UserInfoModel.getUserInfo(userId).then((value)=>{
              let user = new ChatUserProfile();
              user.id = value?.userid;
              user.name = value?.avatarurl
              user.avatar = value?.nickname
              resolve(user);
            })








          } else {
            // 处理获取多个联系人信息的逻辑
            let result: ChatUserProfile[] = [];
            for (let index = 0; index < userId.length; index++) {
              const userid = userId[index];
              UserInfoModel.getUserInfo(userid).then((value)=>{
                let user = new ChatUserProfile();
                user.id = value?.userid;
                user.name = value?.nickname
                user.avatar = value?.avatarurl
                result.push(user)
                ChatLog.d("setProfileProvider--------->getUserInfo"+value?.nickname+"----"+value?.avatarurl+"-----"+value?.userid)
              })
            }

            resolve(result);
          }
        })
      }
    })


    // let userIds = new Array<string>();
    //
    // let result = ChatClient.getInstance().chatManager()?.getAllConversationsBySort();
    //
    // result?.forEach((value)=>{
    //   userIds.push(value.conversationId());
    // })
    //
    // let userTypes = new Array<UserInfoType>();
    // userTypes.push(UserInfoType.NICKNAME);
    // userTypes.push(UserInfoType.AVATAR_URL);
    // ChatClient.getInstance().userInfoManager()?.fetchUserInfoById(userIds, userTypes).then(result => {
    //   result.forEach((value)=>{
    //     if (value.userId) {
    //       UserInfoModel.addUserInfo(value.userId,value.nickname+"",value.avatarUrl+"")
    //     }
    //
    //   })
    //
    // }).catch((e: ChatError) => {
    //   // failure logic
    // });

    // taskpool.execute(concurrentTest, this.getUIContext).then(() => {
    //   // 调度结果处理
    //   console.info("taskpool: execute success")
    // })



  }
  build() {
    Navigation(this.pathStack) {
      if (this.pageIndex === 0) {
        ConversationsPage({
          pathStack:this.pathStack
        });
      } else if (this.pageIndex === 1) {
        ContactsPage({
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

