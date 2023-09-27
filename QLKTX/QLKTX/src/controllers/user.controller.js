const { pool } = require('../configs/connectDB')
const bcrypt = require('bcryptjs')
const { createUserId } = require('../helpers/helpers')
const jwt = require('jsonwebtoken')


module.exports.index = async (req, res) => {
    try {
        const [data] = await pool.execute('SELECT sdt, mailnv FROM nhanvien where manv = ?', [req.user._id])
        console.log(`Load successfull`)

        console.log(data)


        return res.render('user/index', {
            hoten: req.user.hoten,
            role: req.user.role,
            sdt: data[0].sdt,
            email: data[0].mailnv,
        })
    }
    catch (error) {
        console.log(error);
    }

}
module.exports.edit = async (req, res) => {
    try {
        const [data] = await pool.execute('SELECT hoten, sdt, mailnv, diachi, ngaysinh FROM nhanvien where manv = ?', [req.user._id])
        console.log(`Load successfull`)

        console.log(data[0].ngaysinh)

        return res.render('user/edit', {
            manv: req.user._id,
            hoten: req.user.hoten,
            role: req.user.role,
            sdt: data[0].sdt,
            email: data[0].mailnv,
            ngaysinh: data[0].ngaysinh,
            sdt: data[0].sdt,
            diachi: data[0].diachi
        })
    }
    catch (error) {
        console.log(error);
    }

}

module.exports.postEdit = async (req, res) => {
    console.log(req.body);
    try {
        await pool.execute('update nhanvien set hoten = ?, sdt = ?, diachi = ? , mailnv = ?, ngaysinh = ? where manv = ?', [req.body.hoten, req.body.sdt, req.body.diachi, req.body.email, req.body.ngaysinh, req.body.manv])
        const token = jwt.sign({ _id: req.user._id, role: req.user.role, hoten: req.body.hoten, exp: Math.floor(Date.now() / 1000 + (60 * parseInt(process.env.TOKEN_TIME))) }, process.env.TOKEN_SECRET)
        return res.cookie('token', token, { signed: true }).redirect('/user')
    } catch (error) {

    }
}
module.exports.changepassword = async (req, res) => {
    return res.render('user/changepassword', {
        hoten: req.user.hoten,
        role: req.user.role,
        error: '',
        currentpass: '',
        hoten: req.user.hoten
    })
}
module.exports.verify = async (req, res, next) => {
    try {
        const [data] = await pool.execute('SELECT matkhau FROM taikhoan where manv = ?', [req.user._id])
        console.log(`Load successfull`)

        if (!bcrypt.compareSync(req.body.currentpass, data[0].matkhau)) return res.render('user/changepassword', {
            manv: req.user._id,
            hoten: req.user.hoten,
            role: req.user.role,
            error: 'Mật khẩu hiện tại không đúng!',
            currentpass: '',
            hoten: req.cookies.username

        })
        if (req.body.newpass != req.body.verifypass) return res.render('user/changepassword', {
            manv: req.user._id,
            hoten: req.user.hoten,
            role: req.user.role,
            error: 'Vui lòng xác thực lại mật khẩu mới!',
            currentpass: req.body.currentpass,
            hoten: req.user.hoten

        })
        next()
    }
    catch (error) {
        console.log(error);
    }

}

module.exports.postChangepassword = async (req, res) => {
    console.log(req.body);
    const salt = await bcrypt.genSaltSync(10)
    const hashPassword = await bcrypt.hash(req.body.newpass, salt)
    try {
        await pool.execute('update taikhoan set matkhau = ? where manv = ?', [hashPassword, req.user._id])
        return res.redirect('/user')
    } catch (error) {
        console.log(error);
    }
}

module.exports.manage = async (req, res) => {

    try {

        const [data] = await pool.execute(`select nhanvien.manv as manv, taikhoan.quyen as tenrole, nhanvien.hoten as hoten, taikhoan.trangthai as trangthai
                                            from nhanvien inner join taikhoan on nhanvien.manv = taikhoan.manv`)

        console.log(data.length);

        return res.render('user/usermanagement', {
            hoten: req.user.hoten,
            role: req.user.role,
            dsnv: data
        })
    } catch (error) {
        console.log(error);
    }
}
module.exports.addview = async (req, res) => {

    return res.render('user/adduser', {
        hoten: req.user.hoten,
        role: req.user.role,
    })
}
module.exports.addUser = async (req, res) => {
    try {
        const [data] = await pool.execute(`select max(manv) as maxid from nhanvien`)
        console.log(data);
        await pool.execute(`insert into nhanvien(manv, hoten, ngaysinh, diachi, sdt, mailnv) values (?, ?, ?, ?, ?, ?)`, [createUserId(data[0].maxid), req.body.hoten, req.body.ngaysinh, req.body.diachi, req.body.sdt, req.body.email])
        await pool.execute(`insert into taikhoan(manv, matkhau, quyen, trangthai) values (?, ?, ?, ?)`, [createUserId(data[0].maxid), process.env.DEFAULT_PASSWORD, req.body.role, 'Hoạt động'])
        console.log('Create user successfull')
        return res.redirect('/user')
    }
    catch (error) {
        console.log(error);
    }
}
module.exports.adminEdit = async (req, res) => {
    try {
        const [data] = await pool.execute('SELECT hoten, sdt, mailnv, diachi, ngaysinh FROM nhanvien where manv = ?', [req.params.id])
        const [data1] = await pool.execute('SELECT quyen FROM taikhoan where manv = ?', [req.params.id])
        console.log(`Load successfull`)

        console.log(data[0].ngaysinh)

        return res.render('user/adminedit', {
            manv: req.params.id,
            hoten: req.user.hoten,
            hoten1: data[0].hoten,
            role: req.user.role,
            sdt: data[0].sdt,
            email: data[0].mailnv,
            ngaysinh: data[0].ngaysinh,
            sdt: data[0].sdt,
            diachi: data[0].diachi,
            quyentk: data1[0].quyen
        })
    }
    catch (error) {
        console.log(error);
    }
}

module.exports.postAdminEdit = async (req, res) => {
    console.log(req.body);
    try {
        await pool.execute('update nhanvien set hoten = ?, sdt = ?, diachi = ? , mailnv = ?, ngaysinh = ? where manv = ?', [req.body.hoten, req.body.sdt, req.body.diachi, req.body.email, req.body.ngaysinh, req.body.manv])
        await pool.execute('update taikhoan set quyen = ? where manv = ?', [req.body.quyentk, req.body.manv])

        return res.redirect('/user/manage')
    } catch (error) {
        console.log(error);
    }
}

module.exports.resetPass = async (req, res) => {
    try {
        await pool.execute('update taikhoan set matkhau = ? where manv = ?', [process.env.DEFAULT_PASSWORD, req.params.id])
        console.log('Create user successfull')
        return res.redirect('/user/manage')
    }
    catch (error) {
        console.log(error);
    }
}
module.exports.lock = async (req, res) => {
    try {
        await pool.execute('update taikhoan set trangthai = ? where manv = ?', ['Đã khóa', req.params.id])
        console.log('Create user successfull')
        return res.redirect('/user/manage')
    }
    catch (error) {
        console.log(error);
    }
}
module.exports.unlock = async (req, res) => {
    try {
        await pool.execute('update taikhoan set trangthai = ? where manv = ?', ['Hoạt động', req.params.id])
        console.log('Create user successfull')
        return res.redirect('/user/manage')
    }
    catch (error) {
        console.log(error);
    }
}

module.exports.getDoanhThu = async (req, res) => {
    try {
        if (req.query.thang) {
            const temp = req.query.thang
            const temp1 = temp.split('-')
            const [data] = await pool.execute('call DoanhThuTheoThang(?, ?) ', [temp1[1], temp1[0]])
            const [data1] = await pool.execute('call TongThang(?, ?) ', [temp1[1], temp1[0]])


            console.log(data);
            return res.render('user/doanhthu', {
                hoten: req.user.hoten,
                role: req.user.role,
                dshd: data[0],
                title: `tháng ${temp1[1]} năm ${temp1[0]}`,
                tong: data1[0][0].GIA

            })

        }
        else if (req.query.nam) {
            const [data] = await pool.execute('call DoanhThuTheoNam(?) ', [req.query.nam])
            const [data1] = await pool.execute('call TongNam(?) ', [req.query.nam])


            console.log(data);
            return res.render('user/doanhthu', {
                hoten: req.user.hoten,
                role: req.user.role,
                dshd: data[0],
                title: `năm ${req.query.nam}`,
                tong: data1[0][0].GIA
            })

        }
        return res.render('user/doanhthu', {
            hoten: req.user.hoten,
            role: req.user.role,
        })
    }
    catch (error) {
        console.log(error);
    }
}



