import { ChatClient, ChatLog, ChatMessage, ChatMessageListener, ConnectionListener, LoginExtInfo } from 'easemob'
import UserInfo from '../utils/bean/UserInfo'
import EaseConstant from '../utils/EaseConstant'
import { EventBus } from '../utils/EventBus'
import dataPreference from '@ohos.data.preferences'
import { router } from '@kit.ArkUI'

class ChatPresenter {
  private msgListener: ChatMessageListener | undefined
  private connectionListener: ConnectionListener | undefined

  ChatPresenter() {
    //添加消息监听
    this.onMessageListener()
    //链接状态监听
    this.onConnectionListener()




  }

  //消息事件监听
  onMessageListener() {
    this.msgListener = {
      onMessageReceived: (messages: ChatMessage[]): void => {
        EventBus.send(EaseConstant.connected_change)

        messages.forEach((messages) => {
          EventBus.send(EaseConstant.message_change,messages.getMsgId())

        })
      },

    }
    ChatClient.getInstance().chatManager()?.addMessageListener(this.msgListener);
  }

  //状态连接监听器
  onConnectionListener() {
    this.connectionListener = {
      onConnected: (): void => {
        // 长连接建立
        EventBus.send(EaseConstant.connected_change)
      },
      onDisconnected: (errorCode: number): void => {
        // 长连接断开
        if (errorCode === 206) {
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
          })
        }

      },
      onLogout: (errorCode: number, info: LoginExtInfo): void => {
        // 触发退出，需要主动调用 ChatClient#logout 方法
      },
      onTokenExpired: (): void => {
        // 使用 token 登录时，token 过期触发。
      },
      onTokenWillExpire: (): void => {
        // 使用 token 登录时，token 将要过期时触发。
      }

    }
    // 注册连接状态监听
    ChatClient.getInstance().addConnectionListener(this.connectionListener);
  }

}

let chatPresenter = new ChatPresenter()

export default chatPresenter as ChatPresenter