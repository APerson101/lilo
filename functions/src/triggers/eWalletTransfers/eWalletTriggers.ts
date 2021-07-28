import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

/**
 * THIS WOUld trigger when ever a new transfer is entered
 */
export const onWalletTransferSaved=
functions.firestore
    .document("Users/{userID}/PendingTransfers/{transferId}").onCreate(async (snapshot, context)=>{
      console.log("new entry made, triggering respective notifications");
      // inform user that new pending transaction awaits them...if they have signed in
      // await sendNotification(snapshot.data());
    });

async function sendNotification(detials:any) {
  // send notification to users, sender receives a "sent successfully"
  // benefitiary receives a notification if in background and update if in foreground
  const benefitiaryToken= await getuserTokens(detials["destination_ewallet_id"]);
  const senderToken= await getuserTokens(detials["source_ewallet_id"]);


  // console.log(`sending notifications to receiver at: ${benefitiaryToken} and sender at ${senderToken}`);

  console.log(benefitiaryToken);
  console.log(senderToken);

  // notification to reciever
  await admin.messaging().sendMulticast({tokens: benefitiaryToken, notification: {
    title: "Transfer", body: "respond to new transfer"}},);

  // notification to sender
  await admin.messaging().sendMulticast({tokens: senderToken, notification: {
    title: "Transfer", body: "transfer sent, awaiting response"}});
}
async function getuserTokens(eWalletID:string): Promise<any> {
  try {
    let _data="";
    const snapshot= await admin.firestore().collection("Users").where("eWalletID", "==", eWalletID).get();

    snapshot.forEach((doc)=>{
      // console.log("this is the userID associated witht the wal let:"+doc.get("tokens"));
      _data=doc.get("tokens");
    });
    // console.log(`the token: ${_data}`);
    return _data;
  } catch (error) {
    console.log(error);
    return "";
  }
}

export const onWalletDelted=functions.firestore.document("Users/{userID}/PendingTransfers/{transferId}")
    .onDelete(async (snapshot, context)=>{
      console.log("ok, sending update to user about new thing that just happened");
    });
