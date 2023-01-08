// JavaScript
// src/firebase.js
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";


const firebaseConfig = {
    apiKey: "AIzaSyBXHLRS65_qSjdRelkAQogjcMxt06uXTLw",
    authDomain: "roadway-core.firebaseapp.com",
    databaseURL: "https://roadway-core-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "roadway-core",
    storageBucket: "roadway-core.appspot.com",
    messagingSenderId: "884502786471",
    appId: "1:884502786471:web:8276d4e8ac6b68ae9a4682",
    measurementId: "G-XZG6F0HG1X"
  };

  const app = initializeApp(firebaseConfig)
  const db = getFirestore(app)
  export {db}


// firebaseConfig.initializeApp(firebaseConfig);

// export default firebase;