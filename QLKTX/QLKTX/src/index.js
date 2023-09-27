const express = require('express')
const configViewEngine = require('./configs/viewEngine')
const bodyParser = require('body-parser')
const db = require('./configs/connectDB')
const cookieParser = require('cookie-parser')


require('dotenv').config()
//app & port
const app = express()
const port = process.env.PORT || 5000
app.use(cookieParser(process.env.SESSION_SECRET))

//config body-parser
app.use(bodyParser.json()) // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })) // for parsing application/x-www-form-urlencoded
//config views
configViewEngine(app)
app.use(express.static('public'))

// const authRouter = require('./routes/auth.route')
const loginRouter = require('./routes/login.route')
const userRouter = require('./routes/user.route')
const ktxRouter = require('./routes/ktx.route')

//routes
app.get('/', (req, res) => {
    res.redirect('/login')
})
app.get('/logout', (req, res) => {
    return res.clearCookie('token').redirect('/login')
})
app.use('/login', loginRouter)
app.use('/user', userRouter)
app.use('/ktx', ktxRouter)

app.listen(port, () => {
    console.log(`Listening to port ${port}`);
})