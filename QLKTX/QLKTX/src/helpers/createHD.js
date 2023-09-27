var pdf = require("pdf-creator-node");
var fs = require("fs");

// Read HTML Template
var html = fs.readFileSync("./src/helpers/index.html", "utf8");

module.exports.createPDF = (today, user, sinhvien, hopdong) => {
    pdf
        .create({
            html: html,
            data: {
                today: today,
                user: user,
                hopdong: hopdong,
                sinhvien: sinhvien
            },
            path: `C:\\Users\\DELL\\OneDrive\\Desktop\\hợp đồng\\${sinhvien.masv}-${hopdong.ngaylap}.pdf`,
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

}