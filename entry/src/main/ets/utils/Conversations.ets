import {Conversation,ChatClient, ChatLog}from '@easemob/chatsdk'
class ConversationAll{
  getConversations():Promise<Conversation[]>{
    return new Promise((resolve,reject)=>{
      let conversation =  ChatClient.getInstance().chatManager()?.getAllConversationsBySort() as Conversation[];
      if (conversation.length>0) {
        conversation.forEach((value,index,array) => {
          ChatLog.d("未读数"+conversation[index].getUnreadMsgCount())
        });
        conversation.forEach((value, index, array) => {
          console.log("getConversations",value.conversationId())
          value.conversationId()
        })
        resolve(conversation)
      }else {
        reject("本地数据为空")
      }
    })
  }
}
const conversationAll = new ConversationAll()
export  default conversationAll as ConversationAll