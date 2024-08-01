import { emitter } from '@kit.BasicServicesKit';
import { ChatMessage } from 'easemob/src/main/ets/message/ChatMessage';
import UserInfo from '../utils/bean/UserInfo'
/// 事件通知工具类
export abstract class EventBus {
  static send(
    eventID: string,
    eventData?: ChatMessage[]|UserInfo|string,
  ) {
    let data: ChatMessage[]|UserInfo|string
    if (eventData !== null && eventData !== undefined) {
      data = eventData
    }

    emitter.emit(
      eventID,
      {
        priority: emitter.EventPriority.HIGH
      },
      {
        data: {
          'data': eventData
        }
      },
    );
  }
  static listen<T>(
    eventID: string,
    callback: (data?: T) => void,
  ) {
    emitter.on(
      eventID,
      (eventData: emitter.EventData) => {
        let data: ChatMessage[]|UserInfo|string = eventData.data!['data']
        if (data == undefined) {
          callback(undefined)
        } else {
          callback(data as T)
        }
      },
    );
  }

  static cancel(eventID: string) {
    emitter.off(eventID);
  }
}