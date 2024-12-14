require("dotenv").config()
const express = require("express")
const mongoose = require("mongoose")
const userRoutes = require("./routes/users")
const cors = require("cors")

//express app
const app = express()

//middleware
app.use(express.json())
app.use(cors())
app.use((req, res, next) => {
    console.log(req.path, req.method)
    next()
})

//route
app.use('/api/users',userRoutes)

//connect to db
mongoose.connect(process.env.MONGO_URI)
.then(() => {
    console.log("connected to DB")
    //listen for requests
app.listen(process.env.PORT, () => {
    console.log("listening on port", process.env.PORT)
})
})
.catch((error)=>{
    console.log(error)
})
    

