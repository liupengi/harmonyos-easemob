import { ChatCallback, ChatClient, ChatError, ChatLog, ChatMessage,
  ConversationType,
  FetchMessageOption,
  ImageMessageBody} from '@easemob/chatsdk'
import dataPreference from '@ohos.data.preferences'
import { router } from '@kit.ArkUI'
import { EMError } from '@easemob/chatsdk/src/main/cpp/types/libhyphenate/EMError'

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

  aboutToAppear(): void {
    ChatClient.getInstance().userInfoManager()?.fetchUserInfoById(ChatClient.getInstance().getCurrentUser()).then((value)=>{
      value.forEach((value)=>{
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
              url:"pages/Index",
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
                url:"pages/Index",
              })
            }
          })
        })
      Button('下载缩略图')

        .onClick(()=>{
          ChatClient.getInstance().chatManager()?.downloadThumbnail(ChatClient.getInstance().chatManager()?.getMessage("1366095022797096368"))


          // let fetch :FetchMessageOption = new FetchMessageOption()
          // fetch.setIsSave(true)
          // ChatClient.getInstance().chatManager()?.fetchHistoryMessages("lihao123", ConversationType.Chat, 1, "",fetch).then((result) => {
          //   let cursor = result.getNextCursor();
          //   let list = result.getResult();
          //   list.forEach((list) => {
          //     if (list.getType() === 1) {
          //       ChatLog.d("fetchHistoryMessages------->消息类型为图片类型")
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
      Button('下载原图')

        .onClick(async ()=>{
          ChatClient.getInstance().chatManager()?.downloadAttachment(ChatClient.getInstance().chatManager()?.getMessage("1366095022797096368"))



          // ChatClient.getInstance().logout(true).then(()=>{
          //
          // }).catch((error:EMError)=>{
          //   error.errorCode
          // })
          //
          //
          //
          // let message  = ChatMessage.createImageSendMessage("接收方id", "图片本地路径");
          //
          // let conversation = ChatClient.getInstance().chatManager()?.getConversation("会话id");
          // if (!conversation) {
          //   return;
          // }
          // conversation.insertMessage(message);
          //
          //

        })
    }
    .alignItems(HorizontalAlign.Center)


  }
}
