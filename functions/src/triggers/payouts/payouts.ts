// import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as header from "../../headers";
import { axiosHelper } from "../../axiosfunctions";
import * as verifier from "./payoutVerifier";
const ah=new axiosHelper()
const getMethod="get";
const postMethod="post";
const baseURL = "https://sandboxapi.rapyd.net/v1/";
const PayoutPath="payouts";
const payoutListPath="payouts/supported_types";

export const cancelPayout=functions.https.onCall(async(request)=>{
  const payoutID=request["body"]["id"]
  console.log(`canceling payout with id: ${payoutID}`)
  //cancel it now
  const path=baseURL+PayoutPath+'/'+payoutID;
  const headers=header.getHeader(null,path,"delete")
  var req={
    url:path,headers:headers
  }
  const response=await ah.deleteResponse(req);
  console.log(response);
  if(response.status.status=="SUCCESS")
  return true;
  return false;
  console.log(`successfully canceled`);
});


export const PayoutRequest = functions.https.onCall(async(request) => {
    //verify that payout is even possible in the first place.
    //account balance and stuffs like that, also family may have placed restrictions on the eWallet
  let status:boolean=true;
    const requestBody=request["body"]
    console.log(`Payout of type: ${requestBody["payout_method_type"]} has been requested for`);

   if(await verifier.Verifier(requestBody["ewallet"], requestBody["payout_amount"], requestBody["sender_currency"]))
   {
      request["body"]["confirm_automatically"]=true

     //proceed with payout
      const url=baseURL+PayoutPath;
      const headers=header.getHeader(requestBody, url, postMethod);

      var req={
       url:url,
       body:requestBody,
       headers:headers,
      }
      const response= await ah.postRequest(req);
      if(response["data"]["status"]=="Created"){    
      //successfully created, save to database
        request["status"]="Created"
        request["timestamps"]={
        created: response["data"]["created_at"]      
       }
        request["id"]=response["data"]["id"]
     //save to database
        // const ewallet=requestBody["ewallet"]

        // const ref=admin.firestore().doc(`Payouts/${ewallet}`);
        // ref.get().then(async(doc)=>{
        // if(doc.exists)
        // await ref.collection('payouts').add(request).then(
        //   (response)=>{status= true}).catch(
        //     (error)=>{{console.log(error);status= false;}})
        // else {ref.set({});
        // await ref.collection('payouts').add(request).then(
        //   (response)=>{status= true}).catch(
        //     (error)=>{{console.log(error);status= false;}})}

        //     });
        //       const userID=requestBody["userID"]
        //     let trial:Map<String, any>=new Map();
            
        //     admin.firestore().collection(`Users/${userID}/contacts`).add(requestBody)
        // }
        // else {
        // console.log("failed to send payout for the above reason")
        // status= false}
    }

    else {status= false;}
    return status;
  }
  return status;
}
  
 );

  //this would get the list of available options with the data entered
  export const PayoutOptions=functions.https.onCall(async(request)=>{
      let fullPath:string="";
      let url:URL;
      if(request["type"]=="get_payout_options")
      fullPath=baseURL+payoutListPath
      if(request["type"]=="get_requirements"){
  const payoutRequirements=`payouts/${request["payout_method_type"]}/details`;
      fullPath=baseURL+payoutRequirements}
      url=new URL(fullPath)
      const params=Object.entries(request["params"]);
      
      params.forEach((key, value)=>{
        url.searchParams.append(key[0], <string>key[1]);
      })
    const headers=header.getHeader(null,url.toString(),getMethod);
    const payoutOptions= await ah.getRequest(url.toString(), headers);
    // console.log(payoutOptions);
    return payoutOptions;
  }
  
  );

  //this is supposed to only send the pending payouts:payouts where status==created that the user can cancel
  export const getPendingPayouts=(functions.https.onCall(async(request)=>{
    const eWalletID=request["eWalletID"]
    const list:any=[];
   const data=  await admin.firestore().collection(`Payouts/${eWalletID}/payouts`).where('status','==','Created').get();
   data.forEach((val)=>{
    list.push(val.data());
  });
  return list;  
}));


export const walletTransferRequest=functions.https.onCall(async(request)=>{
  const body=request["body"];
  console.log(body["source_ewallet"]);

//verify 
if(await verifier.Verifier(body["source_ewallet"], body["amount"], body["currency"]))
{
  //verified, proceed with transfer
const url=baseURL+'account/transfer'

/***
 * this is a simple trial to see if the merchant defined works as expected
 */

body["metadata"]={"stew":"everywhere"};
const headers=header.getHeader(body,url,postMethod);
const req={url:url, body:body, headers:headers}
const result=await ah.postRequest(req)
return result;
}


});

