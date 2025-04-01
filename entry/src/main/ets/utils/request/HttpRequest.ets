import http from '@ohos.net.http';
import UserInfo from '../bean/UserInfo';

//该类为测试类，没有用
class HttpRequest{
  baseUrl :string = 'https://a1.easemob.com/1137220225110285/demo/'
  getConversationsList():Promise<UserInfo[]>{
    return new Promise((resolve,reject)=>{
      let request = http.createHttp()
      request.request(
        `${this.baseUrl}metadata/user/p0`,
        {
          method:http.RequestMethod.GET,
          header:{
            'Content-Type': 'application/json',
            'Authorization':'Bearer YWMtKrWdaBjKEe-6SpXuJg_KMwAAAAAAAAAAAAAAAAAAAAFe2JYa1n8R45heowo6U5LUAQMAAAGPpAwQFgBPGgD6IhAJSJJLlpyV8GALfYcyQNNEAKVfCCp-eNyRK9y2LQ'
          }
        }
      )
        .then(resp=>{
          if (resp.responseCode === 200) {
            resolve(JSON.parse(resp.result.toString()))
          }
          
        }).catch((error:Result)=> {
      })

    })
  }
}
const httpRequest = new HttpRequest()
export  default httpRequest as HttpRequest