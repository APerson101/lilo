import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as id from "uuid";


export const getAllContacts=functions.https.onCall(async (request)=>{
    const userID=request.body.userID;
    let contacts:any=[]
     await admin.firestore().collection(`Users/${userID}/contacts`).get()
   .then((docs)=>{
       docs.docs.forEach(contact=>{
           contacts.push(contact.data())
       })
   }).catch((error)=>console.log(error));
   return contacts;
});

export const addNewContact=functions.https.onCall(async (request)=>{
    const userID=request.body.userID;
    let contact=request.body.contactData
    let contactId=id.v1();
    contact["id"]=contactId
   var status=await admin.firestore().doc(`Users/${userID}/contacts/${contactId}`).set(contact).then(
       ()=>{return true;}
   ).catch((error)=>{console.log(error);return false;})
   return status;

});

export const deleteContact=functions.https.onCall(async (request)=>{
    const userID=request.body.userID;
    const contactId=request.body.contactID
  const val= await admin.firestore().doc(`Users/${userID}/contacts/${contactId}`).delete().then(()=>
   {
       return true;
   }).catch((er)=>{console.log(er);return false;})
   return val;

});
export const updateContact=functions.https.onCall(async (request)=>{
    const userID=request.body.userID;
    const contactId=request.body.contactID
    const updateValues=request.body.update
  var value=await admin.firestore().doc(`Users/${userID}/contacts/${contactId}`).update(updateValues).then(
      ()=>{return true;}
  ).catch(()=>{return false;})
  return value;

});