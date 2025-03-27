import { Header } from '../Header'
import { ChatClient, ChatMessageListener, Conversation, ChatMessage, ChatLog, ChatError,
  UserInfoManager } from '@easemob/chatsdk'
import { promptAction, router } from '@kit.ArkUI'
import Conversations from '../../utils/Conversations'
import { ConversationsItem } from '../item/conversations/ConversationsItem'
import { EventBus } from '../../utils/EventBus'
import EaseConstant from '../../utils/EaseConstant'
import { ConversationsEventDialog } from '../dialog/ConversationsEventDialog'
import UserInfoModel from '../../utils/db/UserInfoModel'

@Entry
@Component
export struct ConversationsComponent {
  @State isRefreshing: boolean = false;
  @State list: Array<string> = [];
  @State conversation: Conversation[] = [];
  @Prop msgListener: ChatMessageListener
  @State isLongClick :boolean = false
  @State conversationId :string = ''
  @State isLoad : boolean = true

  dialogController: CustomDialogController = new CustomDialogController({
    alignment: DialogAlignment.Bottom,
    builder: ConversationsEventDialog({conversationId:this.conversationId}),
  })

  aboutToAppear(): void {
    Conversations.getConversations().then(resolve => {
      ChatLog.d("getConversations" + resolve.toString())
      this.conversation = resolve
    })

    EventBus.listen<string>(EaseConstant.connected_change, (data) => {
      if (this.isLoad){
        Conversations.getConversations().then(resolve => {
          ChatLog.d("getConversations" + resolve.toString())
          this.conversation = resolve
        })
      }

    })
    EventBus.listen<ChatMessage[]>(EaseConstant.message_change, (data) => {
      Conversations.getConversations().then(resolve => {
        ChatLog.d("getConversations" + resolve.toString())
        this.conversation = resolve
      })
    })


  }


  onPageShow(): void {
    console.info("ConversationsComponent========onPageShow========")
  }

  aboutToDisappear(): void {

  }

  build() {
    Column({ space: 8 }) {
      Header({ title: "会话", isReturn: false, isAdd: true })
        .padding(20)

      List({ space: 8 }) {
        ForEach(
          this.conversation,
          (items: Conversation) => {
            ListItem() {
              ConversationsItem({ item: items})
            }
            .onClick(() => {
              router.pushUrl({
                url: "pages/ChatPage",
                params: { conversationId: items.conversationId() }
              })
            })

            .gesture(
              // 绑定可以重复触发的LongPressGesture
              LongPressGesture({ repeat: true })
                .onAction((event: GestureEvent|undefined) => {
                  if (!this.isLongClick) {
                    this.conversationId = items.conversationId()
                    this.dialogController.open()
                    this.isLongClick = true
                  }

                })
                .onActionEnd(() => {
                  this.isLongClick = false
                })

            )

          }
        )
      }
      .width('100%')
      .layoutWeight(1)
      .divider({
        strokeWidth:1,
        startMargin:55
      })

    }

  }

}



