import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as header from "../../headers";
import {axiosHelper} from "../../axiosfunctions";
import * as id from "uuid";
import * as card from "../cards/cards";

const ah=new axiosHelper();
const postMethod="post";
const baseURL = "https://sandboxapi.rapyd.net/v1/";
export const createUser=functions.https.onCall(async (request)=>{
  // time for major upgrade
  // save the user credenetials also apart from the id
  const body=request["body"];
  const status=await verifyCredentials(body["email"], body["phone_number"]);
  if (status!="success") {
    return status;
  }

  // success, now create wallet
  const wallet=await _createWallet(body);
  // now save user

  const newUserID= await _authenticateUser(body["email"], body["password"], body["phone_number"], body["name"]);
  console.log("user: ", newUserID);
  console.log("success, now creating wallet ");

  console.log("wallet ", wallet);
  const id=wallet["data"]["id"];
  // const type=request['type']
  // success, now save to database4
  await savetoDatabase(id, body, newUserID);
  return "success";
});

export const createUser1=functions.https.onCall(async (request)=>{
  const body=request["body"]["create"];
  const save=request["body"]["save"];
  const db=admin.firestore();

  db.runTransaction(async (t)=>{
    const status=await verifyCredentials(body["email"], body["phone_number"]);
    if (status) {
      const wallet=await _createWallet(body);
      if (wallet["status"]["status"]=="SUCCESS") {
        const newUserID= await _authenticateUser(body["email"], body["password"], body["phone_number"], body["name"]);
        const id=wallet["data"]["id"];

        await savetoDatabase(id, save, newUserID);
        console.log(wallet["data"]["contacts"]["data"][0]);
        const res= await card.createCard1({"country": "MX",
          "ewallet_contact": wallet["data"]["contacts"]["data"][0]["id"]});
        // activate card
        const cardID=res["data"]["card_id"];
        console.log(cardID);
        card.activateCard1({"card": cardID});
        return true;
      } return false;
    } return false;
  });
});

export const verifyEntry=functions.https.onCall(async (request)=>{
  const email=request["body"]["email"];
  const phone_number=request["body"]["phone_number"];
  const response=await verifyCredentials(email, phone_number);
  if (response=="success") {
    return true;
  }
  return false;
});
export const createFamily=functions.https.onCall(async (request)=>{
  const family:any =request["body"]["useCreate"];
  const familySave:any =request["body"]["usesave"];
  const family_ID=id.v1();
  // await createFamilyID(family_ID);

  // family is json of json of family members
  console.log("family sent is: ", family);
  console.log("family id: ", family_ID);
  const status= family.forEach(async (familymember:any) => {
    const wallet=await _createWallet(familymember);//
    console.log("the created wallet is ", wallet);

    let walletId; const user_type=familymember["user_type"];
    console.log("the  user_type id is ", user_type);

    if (wallet["status"]["status"]=="SUCCESS") {
      walletId=wallet["data"]["id"];
      console.log("wallet created succesfuly: id is ", walletId);
      console.log(wallet["data"]["contacts"]["data"][0]);
      const res= await card.createCard1({"country": "MX",
        "ewallet_contact": wallet["data"]["contacts"]["data"][0]["id"]});
      // activate card
      const cardID=res["data"]["card_id"];
      console.log(cardID);
      card.activateCard1({"card": cardID});
      // return true;
    } else {
      console.log(wallet);
      return false;
    }
    const lastname=familymember["last_name"];
    const name=familymember["first_name"];

    const full_name=name+ " "+lastname;
    // create user in auth
    const uid= await _authenticateUser(familymember["email"], "000000", familymember["phone_number"], full_name);
    // save user to databse...of family and users
    // const uid=userRecord['UserRecord']['uid'];
    console.log("user id is ", uid);
    familySave["familyID"]=family_ID;

    await savetoDatabase(walletId, familySave, uid );

    // save to family
    await savetoFamilyDB(uid, family_ID, walletId, user_type );
    return true;
  });
  return true;
});

export const addFamilyMember=functions.https.onCall(async (request)=>{
  const userDetails=request.body.userDetails;
  const familyID=request.body.familyID;
  let walletId;
  const wallet=await _createWallet(userDetails);
  if (wallet["status"]["status"]=="SUCCESS") {
    walletId=wallet["data"]["id"];
    console.log("wallet created succesfuly: id is ", walletId);
  } else {
    console.log(wallet);
    return false;
  }
  const lastname=userDetails["last_name"];
  const name=userDetails["first_name"];

  const full_name=name+ " "+lastname;
  // create user in auth
  const uid= await _authenticateUser(userDetails["email"], userDetails["00000000"], userDetails["phone_number"], full_name);
  // save user to databse...of family and users
  // const uid=userRecord['UserRecord']['uid'];
  console.log("user id is ", uid);
  const user_type="family_member";
  userDetails["user_type"]=user_type;
  userDetails["familyID"]=familyID;
  await savetoDatabase(walletId, userDetails, uid );

  // save to family
  await savetoFamilyDB(uid, familyID, walletId, user_type );
  return true;
});
async function savetoFamilyDB(userID:string, family_ID:string, eWalletID:string, user_type:string) {
  const path=admin.firestore().doc(`Family/${family_ID}`);
  path.get().then(async (doc)=>{
    if (doc.exists) {
      await admin.firestore().doc(`Family/${family_ID}/members/${userID}`).set({
        "eWalletID": eWalletID, "user_type": user_type, "userID": userID});
    } else {
      await admin.firestore().doc(`Family/${family_ID}`).set({});
      await admin.firestore().doc(`Family/${family_ID}/members/${userID}`).set({
        "eWalletID": eWalletID, "user_type": user_type, "userID": userID});
    }
  }).catch((error)=>console.log("burst"));
}

async function verifyCredentials(email:string, number:string) {
  let status="";
  await admin.auth().getUserByEmail(email).then((result)=>{
    status= "email already exists";
  }).catch(( error)=>{
    // does not exist//
    status= "success";
  });
  if (status=="success") {
    await admin.auth().getUserByPhoneNumber(number).then((result)=>{
      status= "phone number already exists";
    }).catch((error)=>{
      status= "success";
    });
  }
  return status;
}


async function savetoDatabase(walletID:string, data:any, userID:string) {
  const lastname=data["last_name"];
  const name=data["first_name"];

  const full_name=name+ " "+lastname;
  const dob=data["date_of_birth"];
  const phone=data["phone_number"];
  const type=data["type"];
  const user_Type=data["user_type"];
  data["eWalletID"]=walletID;
  data["userID"]=userID;
  data["entity_type"]="individual";
  if (user_Type==null) {
    data["user_type"]="personal";
  }


  const result = await admin.firestore().collection("Users").doc(`${userID}`)
      .create(data).then((val)=>console.log("saved succesful here it is ", val));
  return result;
}
function _authenticateUser(email:string, password:string, phone:string, name:string) {
  const status= admin.auth().createUser({email: email, password: "000000", phoneNumber: phone, displayName: name}).then
  ((userRecord)=>{
    console.log("user authentication succesful: ", userRecord);
    return userRecord.uid;
  }).catch((error)=> {
    console.log("error creating: ", error["errorInfo"]); return error;
  });

  return status;
}

async function _createWallet(body:any) {
  const fullPath=baseURL+"user";
  const headers=header.getHeader(body, fullPath, postMethod);
  const req={
    url: fullPath, headers: headers, body: body,
  };
  const response=await ah.postRequest(req);
  return response;
}


export const loadWallet=functions.https.onCall(async (request)=>{
  const userID=request["body"]["eWalletID"];
  const path=baseURL+`user/${userID}`;
  const headers=header.getHeader(null, path, "get");
  const userWallet= await ah.getRequest(path, headers);
  console.log(userWallet);
  return userWallet;
});

export const addWithdraw=functions.https.onCall(async (request)=>{
  const _type=request["params"];
  const fullpath=baseURL+`account/${_type}`;
  const body=request["body"];
  const headers=header.getHeader(body, fullpath, "post");
  const response =await ah.postRequest({url: fullpath, body: body, headers: headers});
  console.log(response);
  return response;
});
