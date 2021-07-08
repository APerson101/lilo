importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

var firebaseConfig = {
    apiKey: "AIzaSyDuCdvipng1KRB1xeegYFyKoH5oDNb5_CA",
    authDomain: "lilo-5663c.firebaseapp.com",
    projectId: "lilo-5663c",
    storageBucket: "lilo-5663c.appspot.com",
    messagingSenderId: "196534833052",
    appId: "1:196534833052:web:eb11a8bbb7f6aa9ce24259"
  };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
  });