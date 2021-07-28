import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import {axiosHelper} from "../../axiosfunctions";
import * as header from "../../headers";
import {Verifier} from "../payouts/payoutVerifier";
const axios_=new axiosHelper();
const baseURL = "https://sandboxapi.rapyd.net/v1/";

async function verifyUser(body:any) {
  const payout_fields=body["payout_fields"];
  const eWallet=payout_fields["ewallet"];
  const amount=payout_fields["payout_amount"];
  const payout_currency=payout_fields["payout_currency"];
  if (await Verifier(eWallet, amount, payout_currency)) {
    // proceed with creating subscription
    return true;
  } return false;
}

export const createSubscription = functions.https.onCall(async (request)=>{
  // verify user
  const verified= await verifyUser(request["body"]);
  if (verified) {
    // proceed
    const product_ID:string = await _createsubProduct(request["body"]);
    const plan_ID:string = await _createSubPlan(product_ID, request["body"], request["body"]["payout_fields"]);
    const subscriptionbody = {
      "billing": "pay_automatically",
      "payout_fields": request["body"]["payout_fields"],
      "metadata": "wanzam",
      "subscription_items": [
        {"plan": plan_ID, "quantity": 1},
      ],
    };
    const url=baseURL+"payouts/subscriptions/";
    const body=subscriptionbody;
    const headers=header.getHeader(body, url, "post");
    const result=await axios_.postRequest({url: url, body: body, headers: headers});
    if (result["status"]["status"]=="SUCCESS") {
      await saveToDatabase(request["body"], result["data"]);
      return true;
    } return false;
  } else return false;
});

export const getAllSubscriptions=functions.https.onCall(async (request)=>{
  const userId=request["body"]["userID"];
  const subscriptions=await admin.firestore().collection(`Users/${userId}/subscriptions/subscriptionItems`).get();
  return subscriptions;
});


export const updateSubscriptionGroup=functions.https.onCall(async (request)=>{
  const userID=request["body"]["userID"];
  const newGroup=request["body"]["newGroup"];
  const subscriptionID=request["body"]["subscriptionID"];

  await admin.firestore().doc(`Users/${userID}/subscriptions/subscriptionItems/${subscriptionID}`).update({"group": newGroup});
  return true;
});

export const updateSubscriptionDescription=functions.https.onCall(async (request)=>{
  const userID=request["body"]["userID"];
  const newDesc=request["body"]["newDesc"];
  const subscriptionID=request["body"]["subscriptionID"];

  await admin.firestore().doc(`Users/${userID}/subscriptions/subscriptionItems/${subscriptionID}`).update({"description": newDesc});
  return true;
});

async function saveToDatabase(subsctiptionItem:any, result:any) {
  console.log(subsctiptionItem);
  const userID=subsctiptionItem["userID"];
  const subscriptionID=result["id"];
  const created_at=result["created_at"];
  const group=subsctiptionItem["group"];
  const amount=subsctiptionItem["payout_fields"]["payout_amount"];
  const currency=subsctiptionItem["payout_fields"]["payout_currency"];
  const interval=subsctiptionItem["interval"];
  const interval_count=subsctiptionItem["interval_count"];
  const product_name=subsctiptionItem["product_name"];
  const product_description=subsctiptionItem["product_description"];
  const status="Active";
  const exists=await admin.firestore().doc(`Subscriptions/${userID}`) .get();
  if (!exists.exists) {
    await admin.firestore().doc(`Subscriptions/${userID}`)
        .set({"groups": [group], "total": [{[currency]: amount}], "count": 1});
  } else {
    await admin.firestore().doc(`Subscriptions/${userID}`)
        .update({"groups": admin.firestore.FieldValue.arrayUnion(...[group]),
          //
          "count": admin.firestore.FieldValue.increment(1)});
  }
  await admin.firestore().collection(`Subscriptions/${userID}/subscriptionItems`)
      .add({userID: userID, created_at: created_at,
        group: group, amount: amount, currency: currency,
        interval: interval, interval_count: interval_count,
        product_name: product_name, product_description: product_description, subscriptionID: subscriptionID,
        status: status});
  return true;
}

export const createsubscriptionGroup=functions.https.onCall(async (request)=>{
  const userID=request["body"]["userID"];
  const newgroup=request["body"]["newGroup"];
  await admin.firestore().doc(`Users/${userID}/subscriptions`).update({"groups": admin.firestore.FieldValue.arrayUnion(...[newgroup])});
  return true;
});

export const removesubscriptionGroup=functions.https.onCall(async (request)=>{
  const userID=request["body"]["userID"];
  const newgroup=request["body"]["oldGroup"];
  await admin.firestore().doc(`Users/${userID}/subscriptions`).update({"groups": admin.firestore.FieldValue.arrayRemove(...[newgroup])});
  return true;
});


export const cancelSubscription=functions.https.onCall(async (request)=>{
  const userId=request["body"]["userID"];
  const subscriptionID=request["body"]["subscriptionID"];
  const url=baseURL+`payouts/subscriptions/subscriptions/${subscriptionID}`;
  const body={"cancel_at_period_end": true};
  const headers=header.getHeader(body, url, "delete");
  await axios_.deleteResponse({url: url, body: body, headers: headers});
  await admin.firestore().doc(`Users/${userId}/subscriptions/subscriptionItems/${subscriptionID}`).update({"status": "Cancel"});
  return true;
});


async function _createSubPlan(product_ID:string, subscriptionbody:any, payoutbody:any) {
  const body = {
    "amount": payoutbody["payout_amount"],
    "currency": payoutbody["payout_currency"],
    "interval": subscriptionbody["interval"], // day, month, year, week
    "interval_count": subscriptionbody["interval_count"], // i,2,3,4//etc
    "product": product_ID,
  };
  const url=baseURL+"plans/";
  const headers=header.getHeader(body, url, "post");
  const result=await axios_.postRequest({url: url, body: body, headers: headers});
  return result["data"]["id"];
}

async function _createsubProduct(request:any) {
  const body = {
    "name": request["product_name"],
    "type": "services",
    "active": true,
    "statement_descriptor": request["product_description"],
  };
  const url=baseURL+"products/";
  const headers=header.getHeader(body, url, "post");
  const result=await axios_.postRequest({url: url, body: body, headers: headers});
  return result["data"]["id"];
}

