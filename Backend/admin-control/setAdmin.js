const admin = require('firebase-admin');
require('dotenv').config();

// Initialize the Firebase Admin SDK using your service account key
admin.initializeApp({
    credential: admin.credential.cert(require('./service-account-key.json'))
});

// Set the user's UID here for whom you want to make admin
const firstAdminUID = process.env.ADMIN_ID; // Replace with the user's UID

console.log(firstAdminUID);
// Set custom claims
async function setAdminClaim(uid) {
    try {
        await admin.auth().setCustomUserClaims(uid, { admin: true });
        console.log(`Admin claim has been set for user ${uid}`);
    } catch (error) {
        console.error('Error setting admin claim:', error);
    }
}

// Call the function
setAdminClaim(firstAdminUID);
