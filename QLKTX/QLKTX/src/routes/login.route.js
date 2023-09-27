const express = require('express')
const controller = require('../controllers/login.controller')
const router = express.Router()
const { checkLogged } = require('../middlewares/login.middlewares')


// router.get('/', controller.getAll)
// router.post('/', controller.login)
// router.get('/:id', controller.getByID)
// router.put('/:id', controller.update)
// router.delete('/:id', controller.delete)

router.get('/', checkLogged, controller.login)
router.post('/', controller.postLogin)

module.exports = router