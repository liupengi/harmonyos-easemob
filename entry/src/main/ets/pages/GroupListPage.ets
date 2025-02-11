import { ChatClient, ChatError, Contact, Group } from '@easemob/chatsdk'
import { Header } from '../view/Header'
import { router, promptAction } from '@kit.ArkUI'
import { GroupListItem } from '../view/item/group/GroupListItem'
import { GroupListDataSource } from '../data/GroupListDataSource'

@Entry
@Component
struct GroupListPage {
  private data: GroupListDataSource = new GroupListDataSource();
  @State pageNo:number = 0
  isLoading : boolean = false
  @State isMore : boolean = true
  aboutToAppear(): void {
    this.fetchJoinedGroupsFromServer()

  }
  build() {
    Column() {
      Header({ title:"群组列表" })
        .padding(20)
      List({ space: 8 }) {
        LazyForEach(this.data,(item:Group)=>{
          ListItem() {
            GroupListItem({item:item})
          }
          .onClick(() => {
            router.pushUrl({
              url: "pages/ChatPage",
              params: { conversationId: item.groupId(),conversationType: 1 }
            })
          })
        })

      }
      .width('100%')
      .layoutWeight(1)
      .divider({
        strokeWidth:1,
        startMargin:55

      })
      .onReachEnd(()=>{
        console.log('触底了')
        if (!this.isLoading && this.isMore) {
          this.isLoading = true
          //翻页
          this.pageNo++
          this.fetchJoinedGroupsFromServer()

        }

      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
  fetchJoinedGroupsFromServer(){
    ChatClient.getInstance().groupManager()?.fetchJoinedGroupsFromServer(this.pageNo,10).then((groups)=>{
      groups.forEach((value)=>{
        this.data.pushData(value)
      })
      this.isLoading = false
      if (!groups || groups.length === 0) {
        this.isMore = false
      }
    }).catch((error:ChatError)=>{

    })
  }
}