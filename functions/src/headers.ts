import * as encrypt from "crypto";

const baseURL = "https://sandboxapi.rapyd.net/v1";
const _access_key="2B146C10B4E9C286189C";
const _secret_key="85335e819ceafb00cac0e56bacc47df138010d247b74e00fe26d0718b078e3ae1c83ce2420773b90";

export const getHeader=function(body:object|null, urlPath:string, httpMethod:string) {
  const timestamp = (Math.floor(new Date().getTime() / 1000) - 10).toString();
  const salt = encrypt.randomBytes(6).toString("hex");
  urlPath=urlPath.replace(baseURL, "/v1");

  let toSign = httpMethod.toLowerCase() +
        urlPath +
        salt +
        timestamp +
        _access_key +
        _secret_key;

  if (body!=null) toSign += JSON.stringify(body);
  const signature=getSignature(toSign);
  const headers={
    "content-type": "application/json",
    "access_key": _access_key,
    "timestamp": timestamp,
    "salt": salt,
    "signature": signature,

  };
  return headers;
};

function getSignature(toSign:string) {
  const uint8_Secret_Key= new TextEncoder().encode(_secret_key);
  const uint8_to_Sign= new TextEncoder().encode(toSign);
  const encoded=encrypt.createHmac("sha256", uint8_Secret_Key).update(uint8_to_Sign).digest("hex");

  const uint16Array=[];
  for (let index = 0; index < encoded.length; index++) {
    uint16Array.push(encoded.charCodeAt(index));
  }
  const signature =Buffer.from(new Uint16Array(uint16Array)).toString("base64");
  return signature;
}
