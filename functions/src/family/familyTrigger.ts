import * as functions from "firebase-functions";
import * as scheduler from "../triggers./../scheduler/limitscheduler";

export const onfamilyadded=
functions.firestore
    .document("/Family/{familyID}/members/{memberID}").onCreate(async (snapshot, context)=>{
      console.log("new entry made, here is the family:");
      //   console.log(snapshot.before)
      console.log(context.params["familyID"]);
      console.log(context.params["memberID"]);
    //   scheduler.sell('* * * * *')
    });
