import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as header from "../headers";
import {axiosHelper} from "../axiosfunctions";
const ah=new axiosHelper();


export const updateField=functions.https.onCall(async (request)=>{
  const userID=request.body.userID;
  const update=request.body.update;
  const value=await admin.firestore().doc(`Users/${userID}`).update(update).then((result)=>{
    return true;
  }).catch((error)=>{
    return false;
  });

  return value;
});


// CONVERT TO TRANSACTION
export const deleteAccount=functions.https.onCall(async (request)=>{
  const userID=request.body.userID;
  const walletID=request.body.walletID;
  // delete wallet first
  const url=`https://sandboxapi.rapyd.net/v1/user/${walletID}`;
  const headers=header.getHeader(null, url, "delete");
  const req={
    url: url, headers: headers,
  };
  const response=await ah.deleteResponse(req);
  console.log(response);
  if (response["status"]["status"]=="SUCCESS") {
    console.log("wallet successfully deleted");
    // wallet deleted successfully;
    const value=await admin.firestore().doc(`Users/${userID}`).delete().then((result)=>{
      return true;
    }).catch((error)=>{
      return false;
    });
    if (value) {
      // user account deleted from firestore,

      const deleteStatus= await admin.auth().deleteUser(userID).then(()=>{
        return true;
      }).catch((error)=>{
        return false;
      });

      if (deleteStatus) {
        // authentication success, remove from transactions
        await admin.firestore().doc(`Transactions/${walletID}`).delete().
            then(()=>{
              return true;
            }).catch(()=>{
              return false;
            });
      }
    }
  }
});
