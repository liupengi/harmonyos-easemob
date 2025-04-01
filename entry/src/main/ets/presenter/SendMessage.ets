import { ChatClient, ChatMessage, ChatCallback, ChatLog, ConversationType, ChatType, MessageExtType } from '@easemob/chatuikit'
import { Context } from '@ohos.arkui.UIContext';
import FsUtil from '../utils/GetThumbnail';

class SendMessages{
  /*
   * 发送文本消息
   * */
  sendTextMessage(conversationId:string,content:string,conversationType:number): Promise<ChatMessage>{
    return new Promise((resolve,reject)=>{


        let sendMessage :ChatMessage|undefined = ChatMessage.createTextSendMessage(conversationId, content);
        if (!sendMessage) {
          return
        }
        if (conversationType){
          sendMessage.setChatType(1)
        }else {
          sendMessage.setChatType(ChatClient.getInstance().chatManager()?.getConversation(conversationId)?.getLatestMessage()?.getChatType())
        }

        this.sendMessage(sendMessage).then((value)=>{
          resolve(value)
        })

    })

  }
  /*
  * 发送图片消息
  * */
  sendImageMessage(conversationId:string,filePath:string): Promise<ChatMessage>{
    return new Promise((resolve,reject)=>{
      let message  = ChatMessage.createImageSendMessage(conversationId, filePath);
      if (!message) {
        return;
      }
      message.setChatType(ChatClient.getInstance().chatManager()?.getConversation(conversationId)?.getLatestMessage()?.getChatType());
      this.sendMessage(message).then((value)=>{
        resolve(value)
      })
    })
  }


  /*
  * 发送视频消息
  * */
  sendVideoMessage(conversationId:string,filePath:string,context:Context): Promise<ChatMessage>{
    return new Promise(async (resolve,reject)=>{

      try {
        FsUtil.getThumbnail(context,filePath).then((value)=>{
          let message = ChatMessage.createVideoSendMessage(conversationId, filePath, 0, value);
          if (!message) {
            return;
          }
          // 会话类型，包含 `Chat`、`GroupChat` 和 `ChatRoom`，表示单聊、群聊或聊天室，默认为单聊。
          message.setChatType(ChatClient.getInstance().chatManager()?.getConversation(conversationId)?.getLatestMessage()?.getChatType());

          this.sendMessage(message).then((value)=>{
            resolve(value)
          })
        })

      }catch (e){
        console.info(e, `release success.`)
      }
      })

  }

  /*
   * 发送语音消息
   * */
  sendVoiceMessage(conversationId:string,filePath:string,duration:number): Promise<ChatMessage>{
    return new Promise(async (resolve,reject)=>{

          let message = ChatMessage.createVoiceSendMessage(conversationId, filePath, duration);
          if (!message) {
            return;
          }
          // 会话类型，包含 `Chat`、`GroupChat` 和 `ChatRoom`，表示单聊、群聊或聊天室，默认为单聊。
          message.setChatType(ChatClient.getInstance().chatManager()?.getConversation(conversationId)?.getLatestMessage()?.getChatType());

          this.sendMessage(message).then((value)=>{
            resolve(value)
          })

    })

  }


  sendMessage(sendMessage:ChatMessage) :Promise<ChatMessage>{
    return new Promise((resolve,reject)=>{
      let callback: ChatCallback = {
        onSuccess: (): void => {

          resolve(sendMessage)
          let ext =  sendMessage.ext();
          ext.forEach((value)=>{
            ChatLog.d("getStatus=======onSuccess=========:" + value)
          })




          ChatLog.d("getStatus=======onSuccess=========:" + sendMessage?.getStatus())

        },
        onError: (code: number, error: string): void => {
          ChatLog.d("getStatus========onError========:" + sendMessage?.getStatus() + "==code：" + code +
            "==error:" + error)

        },
        onProgress: (progress: number): void => {
          ChatLog.d("getStatus=======onProgress=========:" + sendMessage?.getStatus() + "发送中：" + progress)
          // 附件消息附件的上传进度
        }
      }
      let attributes = new Map<string, MessageExtType>();
      attributes.set("atMemberList", "[]");
      attributes.set("em_push_category", "WORK");
      attributes.set("innerId", "2b23222a-5865-4654-9f54-d3362fbcd6ed");
      attributes.set("em_apns_ext","{\"em_huawei_push_badge_class\":\"com.hecom.hqpaas.rn.PaasReactIndexActivity\",\"em_push_mutable_content\":true}")
      sendMessage.setExt(attributes);


      sendMessage.setMessageStatusCallback(callback);
      ChatClient.getInstance().chatManager()?.sendMessage(sendMessage);
    })


  }



}
const sendMessages = new SendMessages()
export  default sendMessages as SendMessages





