const { loginValitdation, registValitdation } = require('../validations/validate')
const { pool } = require('../configs/connectDB')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')



module.exports.login = (req, res) => {
    res.render('login/dangnhap')
}

module.exports.postLogin = async (req, res) => {
    try {
        const [data] = await pool.execute('SELECT manv, matkhau, quyen, trangthai FROM taikhoan where manv = ?', [req.body.username])
        console.log(`Load successfull`);


        console.log(data);
        if (data[0].trangthai == 'Đã khóa') return res.render('login/dangnhap', {
            error: 'Tài khoản đã bị khóa!'
        })
        // if (data.length === 0) return res.json({ message: 'Email does not exist' })
        if (data.length === 0 || !bcrypt.compareSync(req.body.password, data[0].matkhau)) return res.render('login/dangnhap', {
            error: 'Thông tin chưa chính xác hoặc không đầy đủ, xin vui lòng nhập lại!'
        })
        const [data1] = await pool.execute('SELECT hoten FROM nhanvien where manv = ?', [data[0].manv])

        const token = jwt.sign({ _id: data[0].manv, role: data[0].quyen, hoten: data1[0].hoten, exp: Math.floor(Date.now() / 1000 + (60 * parseInt(process.env.TOKEN_TIME))) }, process.env.TOKEN_SECRET)

        return res.cookie('token', token, { signed: true }).redirect('/user')
    }
    catch (error) {
        console.log(error);
        return res.render('error/index', {
            route: 'login',
            status: 'danger',
            message1: 'Thất bại!',
            message2: 'Vui lòng thử lại'
        })
    }

}

module.exports.mailer = (req) => {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.EMAIL,
            pass: process.env.EMAIL_PASSWORD
        }
    });

    var mailOptions = {
        from: 'Shop name',
        to: req.body.email,
        subject: 'Sign Up Successfully',
        text: 'Welcome to our shop!'
    };

    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            console.log(error);
        } else {
            console.log('Email sent: ' + info.response);
        }
    });
}