import { ChatKitConversation, ChatPageParams, ConversationListView, KitCallback } from '@easemob/chatuikit'
@ComponentV2
export struct ConversationsPage {
  @Param pathStack?: NavPathStack = undefined;
  @Local navPathStack?: NavPathStack = this.pathStack;
  @Event onItemClick: KitCallback<ChatKitConversation> = (item: ChatKitConversation) => {
    this.navPathStack?.pushPath({ name: "ChatPage", param: {
      conversationId: item.conversationId,
      conversationType: item.type
    } as ChatPageParams });
  };
  @Event onBackPress?: () => void = () => {
    this.pathStack?.pop();
  };
  @Builder
  myEmptyDataBuilder() {
    Column() {
      Text('没有数据');
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%');
  }

  build() {
    NavDestination() {
      Column() {
        ConversationListView({
          emptyDataBuilder: this.myEmptyDataBuilder,
          onItemClick: this.onItemClick
        });

      }
    }
    .onReady((context) =>{
      if (!this.navPathStack) {
        this.navPathStack = context.pathStack
      }
    })
  }
}
