const { pool } = require('../configs/connectDB')
const { getDate, createHopDongId, getDateSQL } = require('../helpers/helpers')
const { createPDF } = require('../helpers/createHD')
const open = require('open')



module.exports.listsv = async (req, res) => {
    try {
        const [data] = await pool.execute(`select sinhvien.masv as masv, sinhvien.hoten as hoten, sinhvien.gioitinh as gioitinh, sinhvien.lop as lop, k.sophong as sophong, k.ngayketthuchd as ngaykt
        from sinhvien
        left join (select *
            from hopdong where trangthaihuy = 'Còn hiệu lưc') as k on sinhvien.masv = k.masv`)
        console.log(`Load successfull`)
        let sttHD = []

        for (let i = 0; i < data.length; i++) {

            if (!data[i].ngaykt) {
                sttHD.push(['Chưa có hợp đồng', 'orange'])
                continue
            }
            const today = new Date(getDate())
            const temp = new Date(data[i].ngaykt)
            if (today < temp) {
                sttHD.push(['Đã có hợp đồng', 'green'])
                continue
            }
        }



        return res.render('ktx/sinhvien', {
            hoten: req.user.hoten,
            role: req.user.role,
            dssv: data,
            sttHD: sttHD
        })
    }
    catch (error) {
        console.log(error);
    }

}

module.exports.detailSV = async (req, res) => {
    try {
        const [data] = await pool.execute(`select masv, lop, hoten, ngaysinh, gioitinh, cmnd, sdt, sdtnguoithan, mailsv from sinhvien where masv = '${req.params.id}'`)
        console.log(`Load successfull`)
        const [data1] = await pool.execute('call HopDongCuaSV(?)', [req.params.id])
        const [data2] = await pool.execute('select manv, lydo, ngayghinhan from sotheodoi where masv = ?', [req.params.id])


        return res.render('ktx/chitietsinhvien', {
            hoten: req.user.hoten,
            role: req.user.role,
            sv: data[0],
            dshd: data1[0],
            dsbb: data2
        })
    }
    catch (error) {
        console.log(error);
        return res.render('error/index', {
            route: 'ktx',
            status: 'warning',
            message1: 'Xảy ra lỗi!',
            message2: 'Vui lòng thử lại'
        })
    }

}
module.exports.editSV = async (req, res) => {
    try {
        await pool.execute('update sinhvien set hoten = ?, sdt = ?, mailsv = ?, cmnd = ?, sdtnguoithan = ?, ngaysinh = ? where masv = ?', [req.body.hoten, req.body.sdt, req.body.email, req.body.cmnd, req.body.sdtnguoithan, req.body.ngaysinh, req.body.masv])

        return res.render('error/index', {
            route: `ktx/sinhvien/${req.body.masv}`,
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    }
    catch (error) {
        console.log(error);
        return res.render('error/index', {
            route: `ktx/sinhvien/${req.body.masv}`,
            status: 'danger',
            message1: 'Thất bại!',
            message2: 'Vui lòng thử lại!'
        })
    }

}

module.exports.hopdong = async (req, res) => {
    try {
        const [data] = await pool.execute(`SELECT k.mahopdong, k.ngaylap, k.ngaybatdauhd, k.ngayketthuchd, k.sophong, k.trangthaihuy, k.hotennv, sinhvien.hoten as hotensv, sinhvien.masv
        FROM
        (SELECT hopdong.mahopdong, hopdong.ngaylap, hopdong.ngaybatdauhd, hopdong.ngayketthuchd, hopdong.sophong, hopdong.trangthaihuy, hopdong.masv ,nhanvien.hoten as hotennv
         FROM hopdong INNER JOIN nhanvien on hopdong.manv = nhanvien.manv) as k INNER JOIN sinhvien on k.masv = sinhvien.masv`)
        console.log(data)

        return res.render('ktx/qlhopdong', {
            hoten: req.user.hoten,
            role: req.user.role,
            dshd: data
        })
    }
    catch (error) {
        console.log(error);
    }
}


module.exports.addsv = async (req, res) => {

    return res.render('ktx/themsv', {
        hoten: req.user.hoten,
        role: req.user.role,
    })
}

module.exports.postaddsv = async (req, res) => {

    try {

        await pool.execute(`insert into sinhvien(masv, lop, hoten, cmnd, gioitinh, ngaysinh, sdt, sdtnguoithan, mailsv) values (?, ?, ?, ?, ?, ?, ?, ?, ?)`, [req.body.masv, req.body.lop, req.body.hoten, req.body.cmnd, req.body.gioitinh, req.body.ngaysinh, req.body.sdt, req.body.sdtnguoithan, req.body.email])
        return res.render('error/index', {
            route: 'ktx',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    }
    catch (error) {
        if (error.sqlState == '23000') {
            return res.render('error/index', {
                route: 'themsv',
                status: 'danger',
                message1: 'Thất bại!',
                message2: 'Mã sinh viên đã tồn tại'
            })
        }
    }
}

module.exports.laphd = async (req, res) => {
    try {
        const [gioitinh] = await pool.execute(`select gioitinh from sinhvien where masv = '${req.params.id}'`)
        const [data] = await pool.execute(`select sophong, maloaiphong from phong where soluongconlai > 0`)
        const [data1] = await pool.execute(`select maloaiphong, tenloaiphong, gia from loaiphong where gioitinh = '${gioitinh[0].gioitinh}'`)




        return res.render('ktx/laphd', {
            hoten: req.user.hoten,
            role: req.user.role,
            manv: req.user._id,
            masv: req.params.id,
            ngaylap: getDate(),
            mahd: createHopDongId(),
            loaiphong: data1,
            phong: data
        })
    } catch (error) {

    }

}

module.exports.postlaphd = async (req, res) => {
    try {

        await pool.execute(`insert into hopdong(mahopdong, ngaylap, ngaybatdauhd, ngayketthuchd, trangthaihuy, sophong, masv, manv) values (?, ?, ?, ?, ?, ?, ?, ?)`, [req.body.mahd, req.body.ngaylap, req.body.ngaybatdau, req.body.ngayketthuc, 'Còn hiệu lực', req.body.phong, req.body.masv, req.body.manv])
        const [data] = await pool.execute('select masv, hoten, gioitinh, lop, sdt, mailsv as email from sinhvien where masv = ?', [req.body.masv])
        req.body.gia = parseInt(req.body.thanhtien) / parseInt(req.body.thoihan)
        let today = {
            ngay: req.body.ngaylap.split('-')[2],
            thang: req.body.ngaylap.split('-')[1],
            nam: req.body.ngaylap.split('-')[0]
        }
        createPDF(today, req.user, data[0], req.body)

        return res.render('error/index', {
            route: 'ktx',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })

    } catch (error) {
        console.log(error);
        return res.render('error/index', {
            route: 'ktx',
            status: 'danger',
            message1: 'Thất bại!',
            message2: 'Vui lòng thử lại sau'
        })
    }

}

module.exports.huyhd = async (req, res) => {
    try {
        await pool.execute('update hopdong set trangthaihuy = ? where mahopdong = ?', ['Đã hủy', req.params.id])
        return res.render('error/index', {
            route: 'ktx',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    } catch (error) {
        return res.render('error/index', {
            route: 'ktx',
            status: 'danger',
            message1: 'Thất bại!',
            message2: 'Vui lòng thử lại sau'
        })
    }
}

module.exports.lapbienban = async (req, res) => {
    try {

        return res.render('ktx/lapbienban', {
            hoten: req.user.hoten,
            role: req.user.role,
            manv: req.user._id,
            masv: req.params.id,
            ngaylap: getDate(),
        })
    } catch (error) {

    }

}

module.exports.postlapbienban = async (req, res) => {
    try {

        await pool.execute(`insert into sotheodoi(manv, masv, ngayghinhan, lydo) values (?, ?, ?, ?)`, [req.user._id, req.body.masv, req.body.ngaylap, req.body.lydo])
        return res.render('error/index', {
            route: 'ktx',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })

    } catch (error) {
        return res.render('error/index', {
            route: `sinhvien/lapbienban/${req.body.masv}`,
            status: 'danger',
            message1: 'Thất bại!',
            message2: 'Vui lòng thử lại'
        })
    }

}

module.exports.laphddien = async (req, res) => {
    try {
        const [data] = await pool.execute(`select sophong, maloaiphong from phong`)
        const [data1] = await pool.execute(`select gia from giadien`)
        const [data2] = await pool.execute(`select * from hoadondien`)

        console.log(data2);



        return res.render('ktx/hoadondien', {
            hoten: req.user.hoten,
            role: req.user.role,
            manv: req.user._id,
            masv: req.params.id,
            ngaylap: getDate(),
            mahd: createHopDongId(),
            phong: data,
            giadien: data1[0].gia,
            dshd: data2
        })
    } catch (error) {

    }

}

module.exports.postlaphddien = async (req, res) => {
    try {
        await pool.execute(`insert into hoadondien(mahd, manv, sophong, giadien, ngaylap, chisodiendau, chisodiencuoi, trangthai) values (?, ?, ?, ?, ?, ?, ?, ?)`, [req.body.mahd, req.body.manv, req.body.phong, req.body.giadien, req.body.ngaylap, req.body.chisodiendau, req.body.chisodiencuoi, req.body.trangthai])
        return res.render('error/index', {
            route: 'ktx/hoadondien',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    } catch (error) {
        return res.render('error/index', {
            route: 'ktx/hoadondien',
            status: 'danger',
            message1: 'Thất bại!',
            message2: 'Vui lòng thử lại'
        })
    }

}

module.exports.thanhtoandien = async (req, res) => {
    try {
        await pool.execute(`update hoadondien set trangthai = 'Đã thanh toán' where mahd = '${req.params.id}'`)
        return res.render('error/index', {
            route: 'ktx/hoadondien',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    } catch (error) {
        console.log(error);
        return res.render('error/index', {
            route: 'ktx/hoadondien',
            status: 'danger',
            message1: 'Thất bại!',
            message2: ''
        })
    }

}

//phong

module.exports.thanhvienphong = async (req, res) => {
    try {
        const [data] = await pool.execute('call SVcuaPhong(?)', [req.params.id])
        console.log(data)


        return res.render('ktx/sinhvien', {
            hoten: req.user.hoten,
            role: req.user.role,
            dssv: data[0],
            phong: req.params.id
        })
    }
    catch (error) {
        console.log(error);
    }
}

module.exports.phong = async (req, res) => {
    try {
        const [data] = await pool.execute(`SELECT phong.sophong, phong.soluongsvtoida, phong.soluongconlai, loaiphong.tenloaiphong FROM phong inner join loaiphong on phong.maloaiphong = loaiphong.maloaiphong`)
        const [data1] = await pool.execute(`select maloaiphong, tenloaiphong from loaiphong`)
        console.log(data)

        return res.render('ktx/phong', {
            hoten: req.user.hoten,
            role: req.user.role,
            dsp: data,
            dsl: data1,
        })
    }
    catch (error) {
        console.log(error);
    }
}

module.exports.themphong = async (req, res) => {
    try {
        await pool.execute(`insert into phong(sophong, soluongsvtoida, soluongconlai, maloaiphong) values (?, ?, ?, ?)`, [req.body.sophong, req.body.soluong, req.body.soluong, req.body.loaiphong])
        return res.render('error/index', {
            route: 'ktx/phong',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    }
    catch (error) {
        console.log(error);
        if (error.sqlState == '23000') {
            return res.render('error/index', {
                route: 'ktx/phong',
                status: 'danger',
                message1: 'Thất bại!',
                message2: 'Mã phòng đã tồn tại'
            })
        }
    }

}


module.exports.loaiphong = async (req, res) => {
    try {
        const [data] = await pool.execute(`select loaiphong.maloaiphong, loaiphong.tenloaiphong, loaiphong.gia, loaiphong.gioitinh, k.hienco
        from
        (select maloaiphong ,count(*) as hienco
        from phong
        group by maloaiphong) as k right join loaiphong on k.maloaiphong = loaiphong.maloaiphong`)
        console.log(data)

        return res.render('ktx/loaiphong', {
            hoten: req.user.hoten,
            role: req.user.role,
            dslp: data,

        })
    }
    catch (error) {
        console.log(error);
    }
}

module.exports.themloaiphong = async (req, res) => {
    try {
        if (req.body.gioitinh == 'All') {
            await pool.execute(`insert into loaiphong(maloaiphong, tenloaiphong, gioitinh, gia) values (?, ?, ?, ?), (?, ?, ?, ?)`, [req.body.maloaiphong + '-N', req.body.tenloaiphong, 'Nam', req.body.gia, req.body.maloaiphong, req.body.tenloaiphong, 'Nữ', req.body.gia])
        } else {
            await pool.execute(`insert into loaiphong(maloaiphong, tenloaiphong, gioitinh, gia) values (?, ?, ?, ?)`, [req.body.maloaiphong, req.body.tenloaiphong, req.body.gioitinh, req.body.gia])
        }
        return res.render('error/index', {
            route: 'ktx/loaiphong',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    }
    catch (error) {
        console.log(error);
        if (error.sqlState == '23000') {
            return res.render('error/index', {
                route: 'ktx/loaiphong',
                status: 'danger',
                message1: 'Thất bại!',
                message2: 'Mã này đã tồn tại'
            })
        }
    }

}

module.exports.sualoai = async (req, res) => {
    try {
        const [data] = await pool.execute(`select maloaiphong, tenloaiphong, gia from loaiphong where maloaiphong = '${req.params.id}'`)
        console.log(data)

        return res.render('ktx/chitietloaiphong', {
            hoten: req.user.hoten,
            role: req.user.role,
            ctl: data[0]
        })
    }
    catch (error) {
        console.log(error);
    }
}

module.exports.postsualoai = async (req, res) => {
    try {
        await pool.execute(`update loaiphong set tenloaiphong = ?, gia = ? where maloaiphong = ?`, [req.body.tenloai, req.body.gia, req.body.maloai])
        return res.render('error/index', {
            route: 'ktx/loaiphong',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    }
    catch (error) {
        console.log(error);
        return res.render('error/index', {
            route: 'ktx/loaiphong',
            status: 'danger',
            message1: 'Thất bại!',
            message2: 'Vui lòng thử lại sau'
        })
    }

}

module.exports.xoaloai = async (req, res) => {
    try {
        const [data] = await pool.execute(`delete FROM loaiphong where maloaiphong = '${req.params.id}'`)
        console.log(data)

        return res.render('error/index', {
            route: 'ktx/loaiphong',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    }
    catch (error) {
        return res.render('error/index', {
            route: 'ktx/loaiphong',
            status: 'danger',
            message1: 'Thất bại!',
            message2: ''
        })
    }
}

module.exports.danhsachbienban = async (req, res) => {
    try {
        const [data] = await pool.execute(`select masv, lydo, ngayghinhan from sotheodoi`)
        console.log(data)

        return res.render('ktx/danhsachbienban', {
            hoten: req.user.hoten,
            role: req.user.role,
            dsbb: data

        })
    } catch (error) {

    }
}

module.exports.dien = async (req, res) => {
    return res.render('ktx/giadien', {

        hoten: req.user.hoten,
        role: req.user.role,

    })
}

module.exports.capnhatgiadien = async (req, res) => {
    try {
        await pool.execute('update giadien set gia = ?', [req.body.giadien])

        return res.render('error/index', {
            route: 'ktx',
            status: 'success',
            message1: 'Thành công!',
            message2: ''
        })
    } catch (error) {
        return res.render('error/index', {
            route: 'ktx/giadien',
            status: 'danger',
            message1: 'Thất bại!',
            message2: 'Vui lòng thử lại sau'
        })
    }
}