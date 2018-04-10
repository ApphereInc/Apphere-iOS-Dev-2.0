//
//  Hourly Job Cloud function for Firebase
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

const maxMillisecondsBeforeExit = 60 * 60 * 1000

var functions = require('firebase-functions');
var admin = require('firebase-admin');

admin.initializeApp();

exports.hourly_job =
  functions.pubsub.topic('hourly-tick').onPublish((event) => {
    
    var maxEnterDate = new Date();
    maxEnterDate.setTime(maxEnterDate.getTime() - maxMillisecondsBeforeExit)

    var firestore = admin.firestore();

    return firestore.collection('customers')
      .where('exit_date', '==', null)
      .where('enter_date', '<', maxEnterDate)
      .get().then(querySnapshot => {
        querySnapshot.forEach(customerSnapshot => {
          console.log("Exiting customer " + customerSnapshot.get("user_id") + " at business " + customerSnapshot.get("business_id"))
          customerSnapshot.ref.update({exit_date: new Date()})
        });
      });
  });
