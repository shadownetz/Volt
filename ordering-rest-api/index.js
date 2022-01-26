require("dotenv").config();
const bodyParser = require("body-parser");
const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const app = express();
const PORT = 3000;

// Routes
const authMiddleware = require("./middleware/auth");
const laundryRoute = require("./routes/laundry/laundry");
const logisticsRoute = require("./routes/logistics/logistics");

app.use(helmet());
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

app.use(authMiddleware.API_ACCESS);
app.use('/laundry', laundryRoute);
app.use('/logistics', logisticsRoute);


app.use(function(req, res) {
    return res.status(404).send("Not found");
});

app.listen(PORT);
console.log("VLT Ordering REST API Started on port "+PORT);