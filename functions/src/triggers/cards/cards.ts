import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as header from "../../headers";
import {v4 as uuid4} from "uuid";
import {axiosHelper} from "../../axiosfunctions";
const axios_=new axiosHelper();
const baseURL = "https://sandboxapi.rapyd.net/v1/";


export const createCard = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/cards"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});


export const activateCard = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/cards/activate"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;
});

export const loadCards = functions.https.onCall(async(request)=>{
    const fullpath=baseURL+"issuing/cards"
    const queryParams=request["params"]
    let url:URL
    url=new URL(fullpath)
      const params=Object.entries(queryParams);
      
      params.forEach((key, value)=>{
        url.searchParams.append(key[0], <string>key[1]);
      })
    const headers=header.getHeader(null, url.toString(),"get")
    const result=await axios_.getRequest(url.toString(),headers)
    return result;

    
});
export const updateCard = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/cards/status"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});
export const setPinCode = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/cards/pin"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});
export const cardrefund = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/cards/refund"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});

export const remoteCardAuthorizationSimulation = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/cards/authorization"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});
export const cardTransactions = functions.https.onCall(async(request)=>{
    const card_id=request["body"]["card_id"]
    const url=baseURL+`issuing/cards/${card_id}/transactions`
    const headers=header.getHeader(null, url,"get")
    const result=await axios_.getRequest(url, headers)
    return result;

    
});export const issueBankAccountToWallet = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/bankaccounts"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});export const simulateBankTransferToWallet = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/bankaccounts/bankaccounttransfertobankaccount"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});
export const retrievetransactionsInvolvingBank = functions.https.onCall(async(request)=>{
    const bank_account=request["body"]["bank_account"]
    const url=baseURL+`issuing/bankaccounts/${bank_account}`
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});export const simulateCardBlock = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/cards/simulate_block"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});export const cardDetails = functions.https.onCall(async(request)=>{
    const card=request["body"]["card"]
    const url=baseURL+`issuing/cards/${card}`
    const body=request["body"]
    const headers=header.getHeader(body, url,"get")
    const result=await axios_.getRequest(url, headers)
    return result;

    
});

export const simulateAuthorizationReversal = functions.https.onCall(async(request)=>{
    const url=baseURL+"issuing/cards/reversal"
    const body=request["body"]
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;

    
});
export async function createCard1(body:any) {
    const url=baseURL+"issuing/cards"
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;
}


export async function activateCard1(body:any) {
    const url=baseURL+"issuing/cards/activate"
    const headers=header.getHeader(body, url,"post")
    const result=await axios_.postRequest({url:url, body:body, headers:headers})
    return result;
}



