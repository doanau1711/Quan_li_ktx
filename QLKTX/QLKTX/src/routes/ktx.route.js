const express = require('express')
const controller = require('../controllers/ktx.controller')
const router = express.Router()
const { auth } = require('../middlewares/login.middlewares')


// router.get('/', controller.getAll)
// router.post('/', controller.login)
// router.get('/:id', controller.getByID)
// router.put('/:id', controller.update)
// router.delete('/:id', controller.delete)

//Sinhvien
router.get('/', auth, controller.listsv)

router.get('/sinhvien/:id', auth, controller.detailSV)
router.post('/sinhvien/:id', auth, controller.editSV)

router.get('/sinhvien/laphd/:id', auth, controller.laphd)
router.post('/sinhvien/laphd/:id', auth, controller.postlaphd)
router.get('/sinhvien/huyhd/:id', auth, controller.huyhd)


router.get('/sinhvien/lapbienban/:id', auth, controller.lapbienban)
router.post('/sinhvien/lapbienban/:id', auth, controller.postlapbienban)



router.get('/themsv', auth, controller.addsv)
router.post('/themsv', auth, controller.postaddsv)

//hopdong
router.get('/hopdong', auth, controller.hopdong)


//phong
router.get('/phong', auth, controller.phong)
router.post('/phong', auth, controller.themphong)

router.get('/phong/sinhvien/:id', auth, controller.thanhvienphong)

router.get('/loaiphong', auth, controller.loaiphong)
router.post('/loaiphong', auth, controller.themloaiphong)

router.get('/loaiphong/edit/:id', auth, controller.sualoai)
router.post('/loaiphong/edit/:id', auth, controller.postsualoai)
router.get('/loaiphong/delete/:id', auth, controller.xoaloai)

router.get('/hoadondien', auth, controller.laphddien)
router.post('/hoadondien', auth, controller.postlaphddien)

router.get('/hoadondien/thanhtoan/:id', auth, controller.thanhtoandien)

router.get('/bienban', auth, controller.danhsachbienban)

router.get('/giadien', auth, controller.dien)
router.post('/giadien', auth, controller.capnhatgiadien)


// router.post('/', controller.postLogin)

module.exports = router