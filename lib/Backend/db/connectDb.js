const mongoose = require('mongoose');

const mongoURI = "mongodb://localhost:27017/timed";

mongoose.connect(mongoURI)
.then(() => console.log("MongoDB connected"))
.catch((err) => console.log(err))