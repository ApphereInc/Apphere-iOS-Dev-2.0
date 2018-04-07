//
//  Hourly Job Cloud function for Firebase
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

var functions = require('firebase-functions');

exports.hourly_job =
  functions.pubsub.topic('hourly-tick').onPublish((event) => {
    console.log("TODO: exit active customers that have been in a business over 15 minutes")
  });
