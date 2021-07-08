import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const  sell=
    functions.pubsub.schedule('* * * * *')
  .onRun((context) => {
      admin.firestore().collection('/Family/{familyID}/members/{memberID}').where('user_type','==','family_member').get()
      .then((snapshots)=>
      {
          console.log('here are the relevant people": ',snapshots.docs)
      });
  return null;
});