
class TimeConversion{

    getTime(time: number|undefined){
        if (time) {
            let localDateNow = new Date()
            localDateNow.setHours(0)
            localDateNow.setMinutes(0)
            localDateNow.setSeconds(0)
            localDateNow.setMilliseconds(0)
            let dayDate = localDateNow.getTime();


            let getFullYear = new Date(time).getFullYear()//年
            let getMonth = new Date(time).getMonth() + 1 < 10 ? '0' + (new Date(time).getMonth() + 1) : new Date(time).getMonth() + 1 // 月
            let getDate = new Date(time).getDate() < 10 ? '0' + (new Date(time).getDate()) : new Date(time).getDate() // 日
            let getHours = new Date(time).getHours() < 10 ? '0' + (new Date(time).getHours()) : new Date(time).getHours() // 时
            let getMinute = new Date(time).getMinutes() < 10 ? '0' + (new Date(time).getMinutes()) : new Date(time).getMinutes() // 分
            if (time>dayDate) {
                return getHours+":"+getMinute
            }else if (time<dayDate){
                return getMonth+"-"+getDate
            }
        }
        return ''
    }


}
const time = new TimeConversion()
export  default time as TimeConversion