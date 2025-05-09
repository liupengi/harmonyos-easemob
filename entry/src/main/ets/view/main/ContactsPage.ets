import {
  ChatKitContact,
  ChatPageParams,
  ComposeTitleBar,
  ContactListView,
  ConversationType,
  KitCallback
} from '@easemob/chatuikit';

@ComponentV2
export struct ContactsPage {
  @Param pathStack?: NavPathStack = undefined;
  @Local navPathStack?: NavPathStack = this.pathStack;

  @Event onItemClick: KitCallback<ChatKitContact> = (item: ChatKitContact) => {
    this.navPathStack?.pushPath({ name: "ChatPage", param: {
      conversationId: item.id,
      conversationType: ConversationType.Chat
    } as ChatPageParams });
  };

  @Event onSearchClick: KitCallback = () => {
    this.navPathStack?.pushPath({ name: "SearchContactPage" });
  }

  build() {
    NavDestination() {
      Column() {
        ComposeTitleBar({
          titlePosition: HorizontalAlign.Center,
          primaryTitle: '联系人列表',
          onBackPress: () => {
            this.navPathStack?.pop();
          }
        });
        ContactListView({
          onItemClick: this.onItemClick,
          onSearchClick: this.onSearchClick
        })
          .layoutWeight(1);
      }
    }
    .hideTitleBar(true)
    .onReady((context) => {
      if (!this.navPathStack)
      this.navPathStack = context.pathStack;
    });
  }
}

@Builder
export function ContactsPageBuilder() {
  ContactsPage()
}
