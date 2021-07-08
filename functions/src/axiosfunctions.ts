import axios from "axios";

/**
 *
 * @param request Map<String, dynamic> that would be used to make get requests
 * @returns
 */

export class axiosHelper {
   
  APIKEY={"Authorization":`Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJTSEEyNTYifQ==.bmMwdWx5YWEzUFBac3ROSUV1RERURlhENG03S21HaUNyMGw3cEdKbUFDVmNxL1ZHRE1KQlhBWUdrbnphM0dLcHhLTTR2MHZCZWpEVVJjQ1FvaHY0QkhiUTlEeDlzdUROeVl2SHp6dy81aklWVjNkVGFFMHhQOUFGWHNGd2U5bXM=./8SIrb1erFXzaU7qrTQwKLh5zsUyPnZcWNEFBh0rjCg=`}
  rewardHeaders={"Authorization":`Bearer TEST_e9d77f93319e52d7d416f11f08338749e7dc33a8ba1b07c1647f667b2e422014`};
  async getRewardRequest(url: string) {
    const result=await axios.get(url, {headers:this.rewardHeaders}).then
    ((value)=>{
      // console.log(value.data)
      return value.data;
    }).catch((error)=>{
      if (axios.isAxiosError(error)) {
        console.log(error.response?.data)
        return error.response?.data;
      }
    });
    return result;
  }

  async postgiftCard2(url:string, body:any)
  {
  
    const result=await axios.post(url,body, {headers:this.APIKEY}).then((res)=>{
      console.log(res.data)
      return res.data;
    }).catch((error)=>{
      if (axios.isAxiosError(error)) {
        console.log(error.response?.data)
        return error.response?.data;
      }
    });
    return result;
  
    }

    async getgiftCrd2()
    {
     let url:string= `https://api-testbed.giftbit.com/papi/v1/brands?currencyisocode=USD&embeddable=true`;
    
   let result;
    await axios.get(url, {headers:this.APIKEY}).then((res)=>{console.log(res.data); result= res.data;}).then(burst=>console.log(burst))
   return result;
    }

  async postGiftCard(url:string, body:any)
  {
const result=await axios.post(url,body, {headers:this.rewardHeaders}).then((res)=>{
  console.log(res.data)
  return res.data;
}).catch((error)=>{
  if (axios.isAxiosError(error)) {
    console.log(error.response?.data)
    return error.response?.data;
  }
});
return result;
  }
  async getRequest(url:string, headers:any)
  {
    console.log(url);
    const result=await axios.get(url,{headers:headers}).then
    ((value)=>{
      console.log(value.data);
      return value.data;
    }).catch((error)=>{
      if (axios.isAxiosError(error)) {
        console.log(error.response?.data)
        return error.response?.data;
      }
    });
    return result.data;
  }

    postRequest (request:any) {
    const body=JSON.stringify(request["body"]);
    const result=axios.post(request["url"],
        body, {params: request["params"], headers: request["headers"]}).then(
        (res)=>{
        console.log(res.data); 
        return res.data;
        }
    ).catch((error)=>{
      if (axios.isAxiosError(error)) {
        console.log(error.response?.data)
        return error.response?.data;
      }
    });
    return result;
  }

  putRequest(request:any)
  {
  const res=  axios.put(request["url"], request["body"],{headers:request["headers"], params:request["params"]}).then(
      (val)=>{return val.data}
    ).catch(
      (val)=>{ if(axios.isAxiosError(val)){console.log(val);return val.response?.data}}
    ); return res;
  }


  deleteResponse(request:any)
  {
    const result=axios.delete(request["url"],
        {headers: request["headers"],
      data: request["body"]}).then(
        (res)=>{
        console.log(res.data); return res.data;
        }
    ).catch((error)=>{
      if (axios.isAxiosError(error)) {
        return error.response?.data;
      }
    });
    return result;
  }
  

}
