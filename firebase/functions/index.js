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
          var customer = customerSnapshot.data();
          console.log("Exiting customer " + customer.user_id + " at business " + customer.business_id);

          var businessRef = firestore.collection("businesses").doc(customer.business_id);
          
          firestore.runTransaction(transaction => {
            return transaction.get(businessRef).then(businessSnapshot => {
              transaction.update(customerSnapshot.ref, {exit_date: new Date()});

              var business = businessSnapshot.data();

              if (business.active_customer_count > 0) {
                var newActiveCustomerCount = business.active_customer_count - 1
                transaction.update(businessRef, {active_customer_count: newActiveCustomerCount});
                return newActiveCustomerCount
              }

              return 0
            });
          }).then(newActiveCustomerCount => {
            console.log("Customer exited, business active customer count is now " + newActiveCustomerCount);
          }).catch(error => {
            console.log("Customer exit failed: ", error);
          });
        });
      });
  });
