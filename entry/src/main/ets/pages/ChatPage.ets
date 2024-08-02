import { EMClient, EMImageMessageBody, EMMessage, EMTextMessageBody } from 'easemob/src/main/cpp/types/libhyphenate'
import { Header } from '../view/Header'
import {ChatClient,ChatMessageListener,SearchDirection,ChatMessage,  ConversationType, ChatLog } from 'easemob'
import { router } from '@kit.ArkUI'
import { AttachmentMessageDialog } from '../view/dialog/AttachmentMessageDialog'
import { MessageTextItem } from '../view/item/messages/MessageTextItem'
import  SendMessages from '../presenter/SendMessage'
import {VoiceDialog} from '../view/dialog/VoiceDialog'
import { init } from '../utils/AudioCapturer'
import { checkAppPermissionOne } from '../utils/permissions/CheckAccess'
import { common } from '@kit.AbilityKit'
import { EventBus } from '../utils/EventBus'
import EaseConstant from '../utils/EaseConstant'
import UserInfo from '../utils/bean/UserInfo'
import { systemDateTime } from '@kit.BasicServicesKit'

@Entry
@Component
struct ChatPage {
  @State params: object = router.getParams()
  @State messages: ChatMessage[] = []
  @State message: string = '';
  @Prop msgListener: ChatMessageListener
  @State isShowSend: boolean = false
  @State imgMessage: ChatMessage |undefined = undefined
  private context = getContext(this) as common.UIAbilityContext; //UIAbilityContext
  aboutToAppear(): void {

    ChatClient.getInstance().chatManager()?.getConversation(this.params['conversationId'], ConversationType.Chat,
      false)?.loadMoreMessagesFromDB("", 20, SearchDirection.UP).then(messages => {
      this.messages = messages
    })

    EventBus.listen<string>(EaseConstant.message_change,(messagesId) => {
      this.messages.push(ChatClient.getInstance().chatManager()?.getMessage(messagesId) as ChatMessage)
    })
    ChatClient.getInstance().chatManager()?.getConversation(this.params['conversationId'])?.markAllMessagesAsRead()
  }

  aboutToDisappear(): void {
    // 解注册消息监听
    ChatClient.getInstance().chatManager()?.removeMessageListener(this.msgListener);
  }

  onPageHide(): void {
    console.info("ChatPage========onPageHide========")
  }

  onPageShow(): void {
    console.info("ChatPage========onPageShow========")
  }
  imgMsg = (chatMessage:ChatMessage)=>{
    this.messages.push(chatMessage)
    //this.customDialogController.close()
  }

  build() {
    Column() {

      Header({ title: this.params['conversationId'] })
        .padding(20)

      List({ space: 8 }) {
        ForEach(
          this.messages,
          (item: ChatMessage) => {
            ListItem() {
              // 消息item
              MessageTextItem({ data: item })
            }

          }
        )
      }
      .width('100%')
      .layoutWeight(1)



      Row() {
        Image($r('app.media.ease_chatting_setmode_voice_btn_pressed'))
          .width(30)
          .height(30)
          .onClick(async ()=>{
            let res: boolean = await  checkAppPermissionOne(this.context)
            if (!res) return

            init()
            let   customDialogController: CustomDialogController = new CustomDialogController({
              alignment: DialogAlignment.Bottom,
              builder: VoiceDialog({ conversationId: this.params['conversationId'], changeMessage: this.imgMsg })

            })
              .open()
          })
        TextInput({ text: this.message })
          .width(300)
          .margin({ left: 5, right: 5 })
          .onChange((value: string) => {
            this.message = value
            if (value.length > 0) {
              this.isShowSend = true
            }
          })
        if (this.isShowSend) {
          Image($r('app.media.ease_chat_input_primary_send_icon'))
            .width(30)
            .height(30)
            .onClick(() => {
              SendMessages.sendTextMessage(this.params['conversationId'], this.message).then((value)=>{
                    this.messages.push(new ChatMessage(value?.getObject() as EMMessage));
                    this.isShowSend = false
                    this.message = '';
              })

            })
        } else {
          Image($r('app.media.ease_icon_add'))
            .width(40)
            .height(40)
            .onClick(() => {

               let   customDialogController: CustomDialogController = new CustomDialogController({
                alignment: DialogAlignment.Bottom,
                builder: AttachmentMessageDialog({ conversationId: this.params['conversationId'], changeMessage: this.imgMsg })

              })
                .open()
            })
        }
      }
    }
  }
}