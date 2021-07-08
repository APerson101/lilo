import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as header from "../../headers";
import { axiosHelper } from "../../axiosfunctions";
const ah=new axiosHelper()
const getMethod="get";
const postMethod="post";
const baseURL = "https://sandboxapi.rapyd.net/v1/";

export const loadAccountsBalance=functions.https.onCall(async(request)=>{
  const eWalletID=request["body"]["eWalletID"]
  const path=`user/${eWalletID}/accounts`
  const fullPath=baseURL+path;
var headers=header.getHeader(null, fullPath, getMethod)
  var response =await ah.getRequest(fullPath, headers);
 console.log('accounts: ',response)
return response;

  
});

