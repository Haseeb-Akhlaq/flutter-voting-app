const functions = require('firebase-functions');

const admin=require('firebase-admin');

admin.initializeApp();


//On New User Created
exports.newUser=functions.auth.user().onCreate(async (user)=>{
   await admin.firestore().collection('users').doc(user.uid).set({
      'userId':user.uid,
      'name':user.displayName,
      'email':user.email,
    })
});

//On User Deleted
exports.deleteUser=functions.auth.user().onDelete(async (user)=>{
    const doc=admin.firestore().collection('users').doc(user.uid);

    await doc.delete();

});

//On New Election Created
exports.onNewElection=functions.firestore.document("/createdPolls/{userId}/onGoingPolls/{electionId}").onCreate( async (snapshot,context)=>{
    const electionCreated=context.data();
    const electionId=context.params.electionId;
    admin.firestore.collection("polls").doc(electionId).set(electionCreated);
});


