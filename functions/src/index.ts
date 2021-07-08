import * as functions from "firebase-functions";
import {TriggerHandler} from "./webhooksHandler";
import * as admin from "firebase-admin";
import {axiosHelper} from "./axiosfunctions";
// import * as ngrok from "ngrok";
// import * as  triggerHandler  from "./webhooks";
import axios from "axios";
// export * from "./firebaseTriggers"
import * as local from "localtunnel";
import { getHeader } from "./headers";
export * from "./triggers/eWalletTransfers/eWalletTriggers";
export * from "./triggers/requests/requests";
export * from "./triggers/requests/requestTriggers";
export * from "./triggers/payouts/payouts";
export * from "./triggers/subsscriptions/subscriptions";
export * from './triggers/wallets/wallet';
export * from "./triggers/accounts/accounts";
export * from "./triggers/cards/cards";
export * from "./family/familyTrigger";
export * from "./profile/profile";
export * from "./contacts/contacts";

export * from "./scheduler/limitscheduler";
// admin
admin.initializeApp({credential: admin.credential.cert(require("/Users/abdulhadihashim/Desktop/lilo/lilo/functions/lilo-5663c-firebase-adminsdk-wq4c7-c0709bfab8.json")),
  databaseURL: "https://lilo-5663c-default-rtdb.firebaseio.com"}); 
const trigger=new TriggerHandler();
const as=new axiosHelper();
// const tunnel=
local(5001).then((val)=>console.log(val.url)).catch((err)=>console.log(err));

// ngrok.authtoken("1tsTwZN2HJ30Tryt0pDimtKkakr_3Ri2UuPiCDzvgHbYbyiDo");
// const test=ngrok.connect(5001).then((val)=>console.log(val)).catch((err)=>console.log(err));

export const testGiftCard=functions.https.onCall(async(request)=>{

  const result = await as.getRewardRequest("https://testflight.tremendous.com/api/v2/products")
  console.log(result["campaigns"]);
});

export const getAllGiftCards=functions.https.onCall(async(request)=>{

  const result = await as.getRewardRequest("https://testflight.tremendous.com/api/v2/products")
  console.log(result)
  return result;
});
async function getFundingSource()
{
var url="https://testflight.tremendous.com/api/v2/funding_sources"
const result= await as.getRewardRequest(url)
console.log(result)
}

async function listOrders() {
  var url="https://testflight.tremendous.com/api/v2/orders/LCP5JRGRXAVS"
  const result=await as.getRewardRequest(url);
  console.log(result);
}
async function approveReward(id:string) {
  var url=`https://testflight.tremendous.com/api/v2/rewards/${id}/approve`
  const result=await as.getRewardRequest(url);
  console.log(result);
}
export const buyGiftCard = functions.https.onCall(async(request)=>{
  const price_in_cents=2500
  const brand_code=request["body"]["brand_code"]
  const id="retyui7654"
  const body={
    price_in_cents:price_in_cents,
    brand_code:brand_code,
    id:id
  }
  // await getFundingSource();
  // await listOrders();
  // await approveReward();
//   var id=request["id"];
//   var denomination=request["currency"]
//   var amount=request["amount"]
//         // 'campaign_id': "1GMNOKB3TBFE",
//   var body = {
//     'payment': {
//       'funding_source_id': 'MSRMZRJLFSIO'
//     },
//     'rewards': [
//       {
//         'value': {
//           'denomination': 50,
//           'currency_code': 'USD'
//         },
//         'products': [
//           'OKMHM2X2OHYV'
//         ],
//         'recipient': {
//           'name': 'Denise Miller',
//           'email': 'abdulhadih48@gmail.com'
//         },
//         'delivery': {
//           'method': 'LINK',
//           'meta': {}
//         }
//       }
//     ]
//   };
// let tes="SONJVHGEILHU  E6LJTYQMYUZC";
//   var url="https://testflight.tremendous.com/api/v2/orders/";
  const result=await as.postgiftCard2('https://api-testbed.giftbit.com/papi/v1/embedded', body);
  return result["gift_link"]
//   // let orderID=result["order"]["id"];
//   await approveReward("SONJVHGEILHU");

});
export const loadUser=functions.https.onCall(async(request)=>{
  const userID=request["body"]["userID"];
  const  userDoc= await admin.firestore().doc(`Users/${userID}`).get().then((document)=>{
    console.log(document.data());
    return document.data()}).catch((error)=>
  console.log(error)) ;
  return userDoc;
  
});

export const getgiftCrd2=functions.https.onCall(async()=>{
  return await as.getgiftCrd2()
})

export const getContacts=functions.https.onCall(async(request)=>{
  const userID=request["body"]["userID"];
  const  contacts= await admin.firestore().collection(`Users/${userID}/contacts`).get().then((documents)=>{
    console.log(documents.docs.values)
    let docs:any=[];
    documents.docs.forEach((doc)=>
    {
      docs.push(doc.data())
      console.log(doc.data())
    });
    return docs}).catch((error)=>
  console.log(error)) ;
  return contacts;
});

export const setContacts=functions.https.onCall(async(request)=>{
  const body=request["body"]["body"];
  const userID=request["body"]["userID"];
  await admin.firestore().collection(`Users/${userID}/contacts`).add(body)
  .then((res)=>{
    console.log(res.id)
  }).catch((Error)=>console.log(Error));
});

export const postRequest = functions.https.onCall((request) => {
  const body=JSON.stringify(request["body"]);
  const result=axios.post(request["url"],
      body, {params: request["params"], headers: request["headers"]}).then(
      (res)=>{
      console.log(res.data); return res.data;
      }
  ).catch((error)=>{
    if (axios.isAxiosError(error)) {
      return error.response?.data;
    }
  });
  return result;
});
export const getAllTransactions=functions.https.onCall(async (request)=>{
  const eWalletID=request["body"]["eWalletID"];
  const path=`https://sandboxapi.rapyd.net/v1/user/${eWalletID}/transactions`
  const headers=getHeader(null, path, "get")
  return await as.getRequest(path, headers);
})

export const transactionDetails=functions.https.onCall(async (request)=>{
  const eWalletID=request["eWalletID"];
  const id=request["id"];
  const path=`https://sandboxapi.rapyd.net/v1/user/${eWalletID}/transactions/${id}`
  const headers=getHeader(null, path, "get")
  return await as.getRequest(path, headers);
})

export const pendingTransactions=functions.https.onCall(async (request)=>{
  const userID=request["body"]["userID"];
  //get all pending transfer where the user can cancel or respond to
  console.log(`loading them up boy, the id is ${userID}`);
  let list:Array<any>=[]
  const snapshot=await admin.firestore().collection(`Users/${userID}/PendingTransfers`).get();
  // console.log(snapshot.docs.map(doc=>doc.data()))
  snapshot.docs.forEach((doc)=> {
    // console.log(doc.data())
    list.push(doc.data())});
    return list;
});

export const tranferCreated=functions.https.onRequest((request, response)=>{
  console.log("this has been triggerred");
  trigger.triggered(request["body"]["type"], request["body"]["data"]);
  // console.log(request["body"]["data"]);
  response.sendStatus(200);
  // response.send("hello world sent");
});

export const getRequest=functions.https.onCall((request)=>{
  const result=axios.get(request["url"],
      {headers: request["headers"], params: request["params"]}).then((res)=>{
    console.log(res.data); return res.data;
  }
  ).catch((error)=>{
    if (axios.isAxiosError(error)) {
      console.log(error.response?.data);
    }
  });
  return result;
});

export const getWalletID=functions.https.onCall(async (userID:string)=>{
  const ID=await admin.firestore().doc(`Users/${userID}`).get().then((document)=>{
    return document.get("eWalletID");
  }).catch((error)=>{
    if (axios.isAxiosError(error)) {
      console.log(error.response?.data);
    }
  });
  return ID;
});
export const acceptDeclineCancelMoney=functions.https.onCall(async (request)=>{
  const url="https://sandboxapi.rapyd.net/v1/account/transfer/response";
  const body=request["body"];
  const headers=getHeader(body, url, "post");
  return await as.postRequest({url:url, body:body, headers:headers})
})

export const AcceptDeclineMoney = functions.https.onCall((request) => {
  console.log("transferring to another wallet");
  const body=JSON.stringify(request["body"]);
  axios.post(request["url"], body, {headers: request["headers"]}).then(
      (res)=>{
        console.log(res.data); return res.data;
      }
  ).catch((error)=>console.log(error));
});
export const cancelTransfer = functions.https.onCall((request) => {
  console.log("transferring to another wallet");
  const body=JSON.stringify(request["body"]);
  axios.post(request["url"], body, {headers: request["headers"]}).then(
      (res)=>{
        console.log(res.data); return res.data;
      }
  ).catch((error)=>console.log(error));
});

export const viewTransactionHistory = functions.https.onCall((request) => {
  console.log("loading histroy of transactions");
  axios.get(request["url"], {headers: request["headers"]}).then(
      (res)=>{
        console.log(res.data); return res.data;
      }
  ).catch((error)=>console.log(error));
});

export const savetoFirebase=functions.https.onCall(async (data)=>{
  const userID=data["userID"];
  const info=data["data"];
  const value= await admin.firestore().doc(`Wallets/${userID}/`).create(info).then((val)=>val).catch((err)=>err);
  return value;
});

export const saveTokentoFirebase=functions.https.onCall(async (request)=>{
  const userID=request["userID"];
  // console.log(userID);
  const token=request["token"];
  console.log(`this is the token to be saved:: ${token} for the user ${userID}`);
  const value= await admin.firestore().doc(`Users/${userID}`).update({"tokens": admin.firestore.FieldValue.arrayUnion(...[token])}).then((val)=>val).catch((err)=>console.log(err));
  return value;
  //
});




export const putRequest= functions.https.onCall((request) => {
  const body=JSON.stringify(request["body"]);
  const result=axios.put(request["url"],
      body, {params: request["params"], headers: request["headers"]}).then(
      (res)=>{
        console.log(res); return res.data;
      }
  ).catch((error)=>{
    if (axios.isAxiosError(error)) {
      console.log(error.response?.data);
    }
  });
  return result;
});

export const saveTransactiontoFirebase=functions.https.onCall(async (data)=>{
  const transactionID=data["transactionId"];
  // const senderID=data["senderId"];
  // const receiverID=data["receiverId"];
  // const status=data["status"];
  const value=await admin.firestore().doc(`Transactions/${transactionID}/`).
      create(data).then((val)=>val)
      .catch((err)=>err);
  return value;
});
export const serviceProvider=functions.https.onCall(async (data)=>{
  // const countryParameter=data["params"];
  console.log("loading providers");
  axios.get(data["url"], {headers: data["headers"]}).then(
      (res)=>res.data
  ).catch((error)=>console.log(error));
});
export const payoutFields=functions.https.onCall(async (data)=>{
  const Parameters=data["params"];
  console.log("loading providers");
  let dat;
  axios.get(data["url"], {params: Parameters, headers: data["headers"]}).then(
      (res)=>console.log(res.data["data"])
  ).catch((error)=>console.log(error)); return dat;
});

export const createPayout=functions.https.onCall(async (data)=>{
  const body=data["body"];
  console.log("loading providers");
  let da;
  axios.post(data["url"], body, {headers: data["headers"]}).then(
      (res)=>{
        da=res.data;
        console.log(da); return da;
      }
  ).catch((error)=>console.log(error));
  return da;
});