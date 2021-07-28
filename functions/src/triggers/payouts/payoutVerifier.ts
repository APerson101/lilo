import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const Verifier=async function(eWalletID:string, amount:string, currency:string) {
/**
 * if eWalletID is a familyWallet, then check if it has sending restrictions
 * @currency restrictions???
 */
  const [accountType, userRestrictions]=await getUserAccountDetails(eWalletID);
  console.log(accountType);
  if (accountType!="family_member" || accountType==null) {
    return true;
  }
  return verifyFamilyAccount(userRestrictions, amount, currency);
};

async function getUserAccountDetails(eWalletID:string) {
  let userRestrictions;
  let accountType;
  const user=await admin.firestore().collection("Users").where("eWalletID", "==", eWalletID).get();
  user.forEach((document)=>{
    console.log(document.data());
    accountType=document.get("user_type");
    userRestrictions=document.get("restrictions");
  });
  return [accountType, userRestrictions];
}

// highest amount a person can spend
function verifyFamilyAccount(userRestrictions:any, amount:string, currency:string) {
  // get restriction for currency account:
  if (userRestrictions==null) {
    return true;
  }
  const amoutOnCurrency=userRestrictions["currencies"][currency]["amount"];
  console.log(amoutOnCurrency);
  if (Number.parseFloat(amount)>Number.parseInt(amoutOnCurrency)) {
    console.log("kai malam ba za a barka ba");
    return false;
  }
  return true;
}

// highest amount a person can request for
export const verifyrequest=async function(userID:string, amount:string, currency:string) {
  const max_request=(await admin.firestore().doc(`Users/${userID}`).get()).get("max_request");
  if (max_request==null) return true;
  return max_request[currency]["value"]>=Number.parseFloat(amount);
};
