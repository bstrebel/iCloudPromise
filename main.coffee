require 'coffee-script/register'
iCloud = require('icloud-promise')
_ = require 'lodash'

apple_id = process.env.ICLOUD_USERNAME
password = process.env.ICLOUD_PASSWORD
device = process.env.ICLOUD_DEVICE

client = new iCloud.ICloudClient(apple_id, password)
client.login()
.then( (response) ->
  if client.authenticated
    client.refreshClient()
    .then( (response) ->
      found = _.find(client.devices, name: device)
      if found
        console.log("#{found.name} location:", found.location)
      else
        console.log("Device #{device} not found!")
    )
    .catch((error) ->
      console.log('Update device failed, ', error.message)
    )
)
.catch( (error) ->
  console.log('Login failed, ' + error.message)
)

update = () ->
  client.refreshClient()
  .then(() ->
    found = _.find(client.devices, name: device)
    if found
      console.log(found.location)
      # trigger session error after the first call
      # client.session.cookies = null
    else
      console.log("Device #{device} not found!")
  )
  .catch((error) ->
    console.log('Update device failed, ', error.message)
  )

# request device updates every 5 seconds on established client session
# setTimeout(update, delay * 1000) for delay in [5,10,15,20,25]
