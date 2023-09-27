const express = require('express')
const controller = require('../controllers/user.controller')
const router = express.Router()
const { auth } = require('../middlewares/login.middlewares')

// router.get('/', controller.getAll)
// router.post('/', controller.login)
// router.get('/:id', controller.getByID)
// router.put('/:id', controller.update)
// router.delete('/:id', controller.delete)

router.get('/', auth, controller.index)
router.post('/', auth, controller.index)

router.get('/edit', auth, controller.edit)
router.post('/edit', auth, controller.postEdit)

router.get('/changepassword', auth, controller.changepassword)
router.post('/changepassword', auth, controller.verify, controller.postChangepassword)

router.get('/manage', auth, controller.manage)

router.get('/add', auth, controller.addview)
router.post('/add', auth, controller.addUser)

router.get('/manage/edit/:id', auth, controller.adminEdit)
router.post('/manage/edit/:id', auth, controller.postAdminEdit)

router.get('/manage/reset/:id', auth, controller.resetPass)

router.get('/manage/lock/:id', auth, controller.lock)
router.get('/manage/unlock/:id', auth, controller.unlock)

router.get('/doanhthu', auth, controller.getDoanhThu)




// router.post('/', controller.postLogin)

module.exports = router