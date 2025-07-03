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
import { EMError } from '@easemob/chatsdk/src/main/cpp/types/libhyphenate/EMError'
import UserInfoModel from '../../utils/db/UserInfoModel'
import Push from './Push'

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

          // // 获取一个或多个用户的所有属性，一次调用用户 ID 数量不超过 100。
          // let contact = ChatClient.getInstance().contactManager()?.getContactsFromLocal().then(result=>{
          //   result.forEach((value)=>{
          //     this.userIds.push(value.userId());
          //   })
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


          let fetch :FetchMessageOption = new FetchMessageOption()
          fetch.setIsSave(true)

          ChatClient.getInstance().chatManager()?.fetchHistoryMessages("lp2", ConversationType.Chat, 1, "1111111",fetch).then((result) => {
            let cursor = result.getNextCursor();
            let list = result.getResult();
            list.forEach((list) => {
              if (list.getType() === 1) {

                let imageMessages :ImageMessageBody = (list.getBody() as ImageMessageBody)
                let status =  imageMessages.getThumbnailDownloadStatus()
                ChatLog.d("fetchHistoryMessages------->附件下载状态："+status)
                  let callback: ChatCallback = {
                    onSuccess: (): void => {
                      ChatLog.d("fetchHistoryMessages------->下载成功")
                    },
                    onError: (code: number, error: string): void => {
                      ChatLog.d("fetchHistoryMessages------->下载失败"+code+"----"+error)
                    },
                    onProgress: (progress: number): void => {
                      ChatLog.d("fetchHistoryMessages------->下载进度"+progress)
                    }
                  }
                  list.setMessageStatusCallback(callback);
                ChatLog.d("fetchHistoryMessages22------->附件下载状态："+status)
              }

            })
          })



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
          // 创建一条文本消息，`content` 为消息文字内容。
          // `conversationId` 为消息接收方，单聊时为对端用户 ID、群聊时为群组 ID，聊天室时为聊天室 ID。
          let message = ChatMessage.createTextSendMessage("p1", "我是测试的消息");
          if (!message) {
            return;
          }
          // 会话类型：单聊为 ChatType.Chat，群聊为 ChatType.GroupChat, ChatType.ChatRoom，默认为单聊。
          message.setChatType(ChatType.Chat);

          // ChatLog.e("=============>"+pushTemplate);
          // let map = new Map<string,MessageExtType>();
          // map.set("em_push_ext",pushTemplate)
          // message.setExt(map)

          let titleArgs = "自定义的消息内容";
          let templateName = "自定义的title";
          let pushTemplate = `{"title":"${templateName}", "content":"${titleArgs}"}`;
          message.setJsonAttribute("em_push_ext",pushTemplate );

          // let push = new Push("自定义的title","自定义的消息内容")
          // message.setJsonAttribute("em_push_ext",JSON.stringify(push) );
          let callback: ChatCallback = {
            onSuccess: (): void => {
              // 发送消息成功
            },
            onError: (code: number, error: string): void => {
              ChatLog.d(`发送消息失败----${code}---${error.toString()}`)
            },
            onProgress: (progress: number): void => {
              // 附件消息附件的上传进度
            }
          }
          message.setMessageStatusCallback(callback);


          ChatClient.getInstance().chatManager()?.sendMessage(message);






          // // 创建一条文本消息，`content` 为消息文字内容。
          // // `conversationId` 为消息接收方，单聊时为对端用户 ID、群聊时为群组 ID，聊天室时为聊天室 ID。
          // let message = ChatMessage.createTextSendMessage("p1", "我是测试的消息");
          // if (!message) {
          //   return;
          // }
          // // 会话类型：单聊为 ChatType.Chat，群聊为 ChatType.GroupChat, ChatType.ChatRoom，默认为单聊。
          // message.setChatType(ChatType.Chat);
          // let titleArgs = "自定义的消息内容";
          // let templateName = "自定义的title";
          // let pushTemplate = `{"title":${templateName}, "content": ${titleArgs}}`;
          // ChatLog.e("=============>"+pushTemplate);
          // message?.setJsonAttribute("em_push_ext", pushTemplate);
          // let callback: ChatCallback = {
          //   onSuccess: (): void => {
          //     // 发送消息成功
          //   },
          //   onError: (code: number, error: string): void => {
          //     ChatLog.d(`发送消息失败----${code}---${error.toString()}`)
          //   },
          //   onProgress: (progress: number): void => {
          //     // 附件消息附件的上传进度
          //   }
          // }
          // message.setMessageStatusCallback(callback);
          //
          //
          // ChatClient.getInstance().chatManager()?.sendMessage(message);




















          // let group :Group|undefined = ChatClient.getInstance().groupManager()?.getGroup("241407257280524");
          // ChatLog.d(group?.groupName())
          // ChatLog.d(group?.groupId())
          //ChatClient.getInstance().chatManager()?.downloadAttachment(ChatClient.getInstance().chatManager()?.getMessage("1366095022797096368"))



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
