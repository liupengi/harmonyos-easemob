import { Header } from '../Header'
import { ChatClient, ChatMessageListener, Conversation, ChatMessage, ChatLog } from 'easemob'
import { promptAction, router } from '@kit.ArkUI'
import Conversations from '../../utils/Conversations'
import { ConversationsItem } from '../item/conversations/ConversationsItem'
import { EventBus } from '../../utils/EventBus'
import EaseConstant from '../../utils/EaseConstant'

@Entry
@Component
export struct ConversationsComponent {
  @State isRefreshing: boolean = false;
  @State list: Array<string> = [];
  @State conversation: Conversation[] = [];
  @Prop msgListener: ChatMessageListener

  aboutToAppear(): void {
    Conversations.getConversations().then(resolve => {
      ChatLog.d("getConversations" + resolve.toString())
      this.conversation = resolve
    })
    EventBus.listen<string>(EaseConstant.connected_change, (data) => {
      Conversations.getConversations().then(resolve => {
        ChatLog.d("getConversations" + resolve.toString())
        this.conversation = resolve
      })
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
              promptAction.showToast({

                message: "点击了" + items.conversationId() + "会话"
              })
            })
            .swipeAction({ end: this.DeleteButton(items.conversationId()) })

          }
        )
      }
      .width('100%')
      .layoutWeight(1)
      .onTouch((event?: TouchEvent) => {

      })
      .onReachEnd(() => {
        console.log("到达了底部")
        // this.conversation.forEach((value, index, array) => {
        //   console.log("getConversations=============",value.conversationId())
        //   value.conversationId()
        // })
      })
      .divider({
        strokeWidth:1,
        startMargin:55
      })

    }

  }

  @Builder
  DeleteButton(index: string) {
    Button() {
      Text('删除')
        .fontColor(Color.White)
    }
    .width(40)
    .height(40)
    .type(ButtonType.Normal)
    .backgroundColor(Color.Red)
    .margin(5)
    .onClick(() => {
      ChatClient.getInstance().chatManager()?.deleteConversation(index, true);
    })
  }
}


