const functions = require('firebase-functions');

const admin=require('firebase-admin');

admin.initializeApp();



exports.newUser=functions.auth.user().onCreate((user)=>{
   return admin.firestore().collection('users').doc(user.uid).set({
      'userId':user.uid,
      'name':user.displayName,
      'email':user.email,
    })
    console.log('firestore created');
});

exports.deleteUser=functions.auth.user().onDelete((user)=>{
    const doc=admin.firestore().collection('users').doc(user.uid);

    return doc.delete();

});