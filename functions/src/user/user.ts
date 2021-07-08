import * as functions from "firebase-functions";
import * as admin from "firebase-admin";


export const getuserDetails=(functions.https.onCall(async(request)=>{
    const userID=request["userID"]
   const data=  await admin.firestore().doc(`Users/${userID}`).get().then((data)=>{
    return data.data;
   }).catch((err)=>console.log(err))
   return data;  
}));