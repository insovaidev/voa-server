// Set Default Timezone
process.env.TZ = 'Asia/Phnom_Penh'

const express = require('express')
const app = express()
const cors = require('cors')
require('dotenv').config()
const cron = require('node-cron');
const axios = require('axios')


// Allow close domain
app.use(cors())

// Accept Form Submition
const bodyParser = require('body-parser')
app.use(bodyParser.json()) // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })) // for parsing application/x-www-form-urlencoded


// Enable public resource
app.use(express.static('public'))
// Public Folder
app.use('/tmp', express.static('tmp'))
app.use('/pdf', express.static('pdf'))
app.use('/uploads', express.static('uploads'))

// Configuration
const config = require('./app/config/config')


cron.schedule('*/5 * * * * *', function(){
    // Sync Users From Central
    axios.post(config.baseUrl+'syncs/users_from_central', {})
    .then(function (response) {
      // console.log('res', response);
    })
    .catch(function (error) {
      console.log(error);
    });


})

// Routes
require('./app/config/routes')(app)

app.listen(config.port, () => {
  console.log(`http://localhost:${config.port}`)
})

app.use(function(req, res, next) {
  console.log(req.get('User-Agent'))
  res.locals.ua = req.get('User-Agent');
  next();
})

