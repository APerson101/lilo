import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {v4 as uuid4} from "uuid";
import {axiosHelper} from "../../axiosfunctions";
import {Verifier} from "../payouts/payoutVerifier";
const axios_=new axiosHelper();

// incoming request
export const FamilyRequest=functions.https.onCall(async (request)=>{
  const requesterWalletId=request["body"]["requesterWalletId"];
  const familyID=request["body"]["familyID"];
  const requestAmount=request["body"]["amount"];
  const requestCurrency=request["body"]["currency"];
  let headWalletID;
  const requestId=uuid4();

  // get family controller
  console.log(`request id should be: ${requestId}`);
  const familyController=await admin.firestore()
      .collection(`Family/${familyID}/members`)
      .where("user_type", "==", "family_controller").get();
  console.log(familyID);
  familyController.forEach((val)=>{
    console.log(val.data());
    headWalletID=val.data();
  });
  console.log(`family head id: ${headWalletID}`);
  // VERIFY IF REQUEST IS EVEN POSSIBLE, IF NOT, RETURN WITH ERROR MESSAGE AS TO WHY
  // If request passes verification, then save to database
  const approved=await Verifier(requesterWalletId, requestAmount, requestCurrency);

  if (!approved) {
    return false;
  }
  // save request
  request["body"]["status"]="PEN";
  request["body"]["id"]=requestId;
  const savedRequest= await admin.firestore().doc(`Family/${familyID}/family_requests/${requestId}`).set(request["body"])
      .then((val)=>{
        // returns the request with status=pen to notify them that the request was successfully created
        console.log("here is the saved request with status and id");
        console.log(val);
        return val;
      })
      .catch((err)=>console.error(err));

  return true;
  // form message,
  const message={
    //
    title: "New Request",
    requestInfo: savedRequest,
  };
    // send controller notification of new request
  sendNotification(message, headWalletID);
});

/**
 * THIS  IS TRIGGERED WHEN THE HEAD HITS ACCEPT/CANCEL OR WHEN THE REQUESTER CANCELS IT
 */
export const updateRequest=functions.https.onCall(async (request)=>{
  const body=request["body"];
  const status=body["status"];
  const familyId=body["familyID"];
  const requestID=body["id"];


  const updatedStatus= await admin.firestore().doc(`Requests/${familyId}/family_requests/${requestID}`).update({"status": status})
      .then((val)=>{
      // returns the request with status=newStatus to notify them that the request was successfully created
        console.log("updated status: ");
        console.log(val);
        return val;
      })
      .catch((err)=>console.error(err));
});


async function sendNotification(message:any, receiverEwalletID:any) {
  // send notification to users, sender receives a "sent successfully"
  // benefitiary receives a notification if in background and update if in foreground
  const notificationReceiverToken= await getuserTokens(receiverEwalletID);
  if (notificationReceiverToken!=null) {
    console.log("we thank God, the data isnt null, oya na to dey send");
    await admin.messaging().sendToDevice(notificationReceiverToken, {data: {
      "data": JSON.stringify(message)}}, {contentAvailable: true,
      priority: "high"});
  }
}
async function getuserTokens(eWalletID:string): Promise<string> {
  try {
    const snapshot= await admin.firestore().collection("Users").where("eWalletID", "==", eWalletID).get();
    let _data="";
    snapshot.forEach((doc)=>{
      console.log("this is the userID associated witht the wal let:"+doc.get("tokens"));
      _data= doc.get("tokens");
    });
    console.log(`the token: ${_data}`);
    return _data;
  } catch (error) {
    console.log(error);
    return "";
  }
}


export const getFamilyRequests=functions.https.onCall(async (request)=>{
  const userType=request["body"]["user_type"];
  const userID=request["body"]["userID"];
  const familyID=request["body"]["familyID"];
  // return pending request for this user, otherwise return all pending requests from all members to controller
  let pendingRequests;
  if (userType=="family_member") {
    pendingRequests= await admin.firestore().collection(`Family/${familyID}/family_requests`).
        where("requesterUserId", "==", userID)
        .where("status", "==", "PEN").get().then((docs)=>docs.docs.map((item)=>item.data()));
    console.log("this is the pending requests that this family member made:", pendingRequests);
    return pendingRequests;
  }
  if (userType=="family_controller") {
    pendingRequests=await admin.firestore().collection(`Family/${familyID}/family_requests`)
        .where("status", "==", "PEN")
        .get();
    console.log("this is all the requests made by this family: ", pendingRequests);
    return pendingRequests;
  }
  return null;
});

// listen to request database and send notifications
