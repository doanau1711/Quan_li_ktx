

module.exports.createUserId = (maxOld) => {
    const id = parseInt(maxOld.slice(2)) + 1
    if (id < 10) return 'NV0' + id
    return 'NV' + id
}
module.exports.getDate = () => {
    var today = new Date();
    var year = today.getFullYear()
    if (today.getMonth() + 1 < 10) var month = '0' + (today.getMonth() + 1)
    else var month = today.getMonth() + 1

    if (today.getDate() < 10) var date = '0' + (today.getDate())
    else var date = today.getDate()


    return year + '-' + month + '-' + date
}
module.exports.createHopDongId = () => {
    var today = new Date();

    return `HD${today.getFullYear()}${today.getMonth()}${today.getDate()}${today.getHours()}${today.getMinutes()}${today.getSeconds()}${today.getMilliseconds()}`

}
module.exports.getDateSQL = () => {
    var today = new Date();
    var date = (today.getMonth() + 1) + '-' + today.getDate() + '-' + today.getFullYear();
    return date
}