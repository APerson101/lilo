import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {axiosHelper} from "../../axiosfunctions";

const axioshelper=new axiosHelper();

/**
 * THIS IS TRIGGERED WHEN A NEW FAMILY REQUEST IS ENTERED INTO THE DATABASE
 */
export const newRequestCreated=
functions.firestore.document("Requests/{familyID}/family_requests/{request_id}").onCreate( async (data, context)=>{
  /**
     * I AM VERY STUPID
     * lol, take it easy on your self.
     */
  console.log("new request has been entered, sending notification to receiver");
  // const data=_data.;
  // const requesterWalletId=data.get("requesteWalletID");
  const familyID=data.get("familyID");
  const requestAmount=data.get("amount");
  // const timestamp=data.get("timestamp");
  const requesterName=data.get("name");
  const requestType=data.get("type");
  const currency=data.get("currency");

  let receiverWalletID="";
  const familyController=await admin.firestore().collection("Families").where("family_id", "==", familyID).get();
  familyController.forEach((val)=>{
    receiverWalletID=val.get("head");
  });
  //THIS NEEDS name of person, amount, need, currency
  // sendNotification(message, receiverWalletID);
  let body=`${requesterName} is asking for ${currency} ${requestAmount} for: ${requestType}`;
  const headToken=await getuserTokens(receiverWalletID);
  await admin.messaging().sendMulticast({tokens:headToken, notification:{
    title: "request", body:body}},);
});

/**
 * THIS IS TRIGGERED WHEN THE HEAD RESPONDS OR THE REQUESTER CANCELS
 */
export const requestResponse=functions.https.onCall(async (request)=>{
  //Verify it the request is even possible, 
  //otherwise tell user can't approve and leave it on pending
  //if verification test is passed, then send stuff
  //upon success of sending stuff, change status in database, 
  //then send message to trigger UI change or something
  //
  //this verifier should send a response in the form {"status: success/failed", message: ""/ "reason for failure"}
  //then we would say if(verifier["status"]=="success"){proceed with request initiateTransfer()}else return {"failed":"reason"}
  
  const requestbody=request.body;
  const verified=verifier(request);
  console.log(`verification status is: ${verified}`);
  const newstatus=requestbody["status"];
  const familyID=requestbody["family_ID"];
  const request_ID=requestbody["request_ID"];
  console.log(`the new status requested is: ${newstatus}`);
  const requst_={
    url: requestbody["url"], header: request["header"], body: request["body"], params: request["params"],
  };
  
    // fulfull request, only after request verified and boss said yes
    if(newstatus=="approved" && verified)
    await initiateTransfer(familyID, request_ID, requst_);
    // change status to approved upon complete
    admin.firestore().doc(`Requests/${familyID}/family_requests/${request_ID}`).update({"status": newstatus});

});
async function verifier (request:any)
{
  var accountType, limits;
  const snpshots=await admin.firestore().collection(`Users`).where("eWalletId","==", request["requestereWalletID"]).get()
  snpshots.forEach((doc)=>{accountType=doc.get("AccountType"), limits=doc.get("restrictions")});
  if(accountType!="family"){
   console.log("everywhere stew, not even a family account");
    
  return true;
  }
  else 
  {
    //check for limits
    if(limits!=null)
    {
      
      if(Number(request["amount"])>limits["request_limit"][request["currency"]]){
   console.log("you have exceeeded the amount you can request for");
        
      return false;}
      if(request["type"]=="money"){
        //if user is requesting for money, then see if the request trnsfer type is approved
        var approved_methods:String[]=limits["approved_methods"];
      if(approved_methods.indexOf(request["request_type"])==-1)
        //user has attempted to request for money through a means which wasnt approved for them to use
   { console.log("method requested for was not approved");
   
      return false;}
      //get user account balance and see if this would exceed the limit there
      var currency=request["currency"]
      if(Number(request["account_balance"][currency])+Number(request["amount"])>limits['account_limit'])
   { console.log("account has max balance limits, send rejection message");
      return false;}
      //all conditions have been met, you can proceed with the transaction
    console.log("all conditions have been fullfilled, proceed with transaction");
      return true;
      
      }
    }
    console.log("this family account has no limits, proceed with transaction");
    return true;

  }
}
async function initiateTransfer(familyID:string, request_ID:string, request_:any) {
  // get request
  const payout_object= 
  await admin.firestore().doc(`Requests/${familyID}/family_requests/${request_ID}/request_object/payout_object`).get();
  
  //get bosses_UserID
  const boss=request_["bosseWalletID"];
  //get sender_object
  const boss_account=await admin.firestore().collection("Users").where("eWalletID","==",boss).get();
  let  sender_object;
  boss_account.forEach((doc)=>{sender_object=doc.get("sender_object")});

  //we have sender_object, payout_object, now to actually send it. 
  //confirm UI flow before continuing

  const response=await axioshelper.getRequest(request_);
  console.log("response from request approval transfer");
  console.log(response);
}



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
async function getuserTokens(eWalletID:string): Promise<any> {
  try {let _data=""
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
