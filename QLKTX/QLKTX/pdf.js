var pdf = require("pdf-creator-node");
var fs = require("fs");

// Read HTML Template
var html = fs.readFileSync("index.html", "utf8");



var users = {
    name: 'Nguyễn Văn A'
}
pdf
    .create({
        html: html,
        data: {
            users: users,
        },
        path: "./output.pdf",
        type: "",
    }, {
        format: "A4",
        orientation: "portrait",
        border: "10mm",
    })
    .then((res) => {
        console.log(res);
    })
    .catch((error) => {
        console.error(error);
    });