import React, { useEffect, useState } from "react";
import { db } from "../../firebase";

import { getDoc, doc, getDocs, collection,updateDoc } from "firebase/firestore";

const Read = () => {
  const [data, setData] = useState([]);
  const [verify, setVerify] = useState(false);
  const fetchData = async () => {
    const querySnapshot = await getDocs(collection(db, "user"));
    querySnapshot.forEach((doc) => {
      // doc.data() is never undefined for query doc snapshots
      console.log(doc.id, " => ", doc.data());
      setData((prev) => [...prev, doc.data()]);
    });
  };
  
  const  getUser = (id) => {
    console.log(id);
    // update doc
    const docRef = doc(db, "user", id);
    console.log(docRef);
    updateDoc(docRef, {

      "user_information.isRider":true,
        
    
    });
    };
  // update doc data function
  // 


  


  useEffect(() => {
    fetchData();
  }, []);

  return (
    <div>
      <h1>read data from firebase firestore</h1>
      // map data uisng key value
      <table style={{ width: "100%" }}>
        <thead>
          <tr>
            <th>FirsTname</th>
            <th>LastName</th>
            <th>IsVrifird</th>
           
          </tr>
        </thead>
        <tbody>
          {data.map((item, key) => (
            <tr key={key}>
              <td>{item.user_information.firstName}</td>
              <td>{item.user_information.lastName}</td>
             
              <td>{item.user_information.isRider}</td>
              <td>
                <button
                  variant="secondary"
                  className="edit"
                  onClick={() => getUser(item.user_information.uuid)}
                >
                  Edit
                </button>
              </td>
              {/* <td>{item?.vpersonal_verification?.address}</td>
              <td>{item?.vpersonal_verification?.legal_firstname}</td> */}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Read;
// console.log(item.vpersonal_verification)

// create table
// <div key={key}>
//   <h1>{item.user_information.firstName}</h1>
//   <h1>{item.user_information.email}</h1>

//   {/* if there is address then print otherwise not */}
//   <h1>{item.vpersonal_verification?.address}</h1>

// </div>
