import { ChatCallback, ChatClient, ChatError, ChatLog, ChatMessage,
  ChatType,
  Conversation,
  ConversationType,
  FetchMessageOption,
  Group,
  ImageMessageBody,
  MessageExtType,
  SearchDirection,
  TextMessageBody,
  UserInfo} from '@easemob/chatsdk'
import dataPreference from '@ohos.data.preferences'
import { router } from '@kit.ArkUI'
import fs from '@ohos.file.fs'

import common from '@ohos.app.ability.common';

let fileList: fs.File[] = [];
//全局公共样式
@Styles function fillScreen(){
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(20)
  .height(120)
  .padding(10)
}
@Component
export struct MeComponent {
  @State avatarUrl:string |undefined =''

  @State nickname:string |undefined =''
  @State  userIds : Array<string> = [];
  aboutToAppear(): void {
    ChatClient.getInstance().userInfoManager()?.fetchUserInfoById(ChatClient.getInstance().getCurrentUser()).then((value)=>{
      value.forEach((value)=>{
        ChatLog.d(`获取头像昵称：${value.nickname}--------------${value.avatarUrl}`)
       this.avatarUrl = value.avatarUrl
       this.nickname = value.nickname
      })
    })

  }



  build() {
    Column(){

        if (this.avatarUrl === undefined || this.avatarUrl === ''){
          Image($r("app.media.ease_default_avatar_1"))
            .width(100)
            .height(100)
        }else {
          Image(this.avatarUrl)
            .width(100)
            .height(100)
        }
        Text(this.nickname)
          .margin({top:20})

      Text("ID:"+ChatClient.getInstance().getCurrentUser())
        .margin({top:20})

      Button('退出登录')
        .margin({top:300})
        .onClick(()=>{
          ChatClient.getInstance().chatManager()?.getConversation("")?.searchMessagesFromDB()


          ChatClient.getInstance().logout(true).then(()=>{
            dataPreference.getPreferences(getContext(),'easemob')
              .then( preferences=>{
                {
                  preferences.put("isAutoLogin", false).then(()=>{
                    preferences.flush()
                  })

                }

              }).catch( () =>{

            })
            router.replaceUrl({
              url: "pages/Index",
              params: {}
            })


          }).catch((e:ChatError)=>{
            if (e.errorCode === 201) {
              dataPreference.getPreferences(getContext(),'easemob')
                .then( preferences=>{
                  {
                    preferences.put("isAutoLogin", false).then(()=>{
                      preferences.flush()
                    })

                  }

                }).catch( () =>{

              })
              router.replaceUrl({
                url: "pages/Index",
                params: {}
              })
            }
          })
        })
      Button('webview 测试')

        .onClick(()=>{

          router.replaceUrl({
            url: "pages/TestPage",
            params: {}
          })



          // // 获取一个或多个用户的所有属性，一次调用用户 ID 数量不超过 100。
          // let contact = ChatClient.getInstance().contactManager()?.getContactsFromLocal().then(result=>{
          //   result.forEach((value)=>{
          //     this.userIds.push(value.userId());
          //   })
          //
          //
          //
          // });
          //
          //
          //
          // ChatClient.getInstance().userInfoManager()?.fetchUserInfoById(this.userIds).then(result => {
          //   result.forEach((value) =>{
          //
          //     ChatLog.d(`获取头像昵称：${value.nickname}--------------${value.avatarUrl}`)
          //
          //     if (value.userId !== undefined && value.nickname !== undefined && value.avatarUrl !== undefined) {
          //       UserInfoModel.addUserInfo(value.userId,value.nickname,value.avatarUrl)
          //     }
          //
          //
          //
          //
          //   })
          //   // success logic
          // }).catch((e: ChatError) => {
          //   // failure logic
          // });





          // ChatClient.getInstance().chatManager()?.downloadThumbnail(ChatClient.getInstance().chatManager()?.getMessage("1366095022797096368"))


          // let fetch :FetchMessageOption = new FetchMessageOption()
          // fetch.setIsSave(true)
          //
          // ChatClient.getInstance().chatManager()?.fetchHistoryMessages("lp2", ConversationType.Chat, 1, "1111111",fetch).then((result) => {
          //   let cursor = result.getNextCursor();
          //   let list = result.getResult();
          //   list.forEach((list) => {
          //     if (list.getType() === 1) {
          //
          //       let imageMessages :ImageMessageBody = (list.getBody() as ImageMessageBody)
          //       let status =  imageMessages.getThumbnailDownloadStatus()
          //       ChatLog.d("fetchHistoryMessages------->附件下载状态："+status)
          //         let callback: ChatCallback = {
          //           onSuccess: (): void => {
          //             ChatLog.d("fetchHistoryMessages------->下载成功")
          //           },
          //           onError: (code: number, error: string): void => {
          //             ChatLog.d("fetchHistoryMessages------->下载失败"+code+"----"+error)
          //           },
          //           onProgress: (progress: number): void => {
          //             ChatLog.d("fetchHistoryMessages------->下载进度"+progress)
          //           }
          //         }
          //         list.setMessageStatusCallback(callback);
          //       ChatLog.d("fetchHistoryMessages22------->附件下载状态："+status)
          //     }
          //
          //   })
          // })



        })
      Button("从服务端获取")
        .onClick(()=>{
          let fetch :FetchMessageOption = new FetchMessageOption()
          fetch.setIsSave(true)
          fetch.setDirection(SearchDirection.DOWN)

          ChatClient.getInstance().chatManager()?.fetchHistoryMessages("lp1", ConversationType.Chat, 20, "",fetch).then((result) => {
            let cursor = result.getNextCursor();
            let list = result.getResult();
            list.forEach((list) => {
              if (list.getType() === 0) {

                let textMessages: TextMessageBody = (list.getBody() as TextMessageBody)
                ChatLog.d(`textMessages------${textMessages.getContent()}`)
              }



            })
          })

        })
      Button("从本地获取")
        .onClick(()=>{
          ChatClient.getInstance().chatManager()?.getConversation("lp1")?.loadMoreMessagesFromDB("", 50, SearchDirection.DOWN).then(messages => {
            messages.forEach((message)=>{
              if (message.getType() === 0) {

                let textMessages: TextMessageBody = (message.getBody() as TextMessageBody)
                ChatLog.d(`textMessages------${textMessages.getContent()}`)
              }


            })
          })


        })
      Button('下载原图')

        .onClick(async ()=>{
          ChatClient.getInstance().groupManager()?.fetchJoinedGroupsFromServer(0,20).then((value)=>{
            ChatLog.d(`${value.toString()}`)
          }).catch((s:ChatError)=>{
            ChatLog.d(`${s.errorCode}======${s.description}`)
          })





        })

    }
    .alignItems(HorizontalAlign.Center)


  }


}

