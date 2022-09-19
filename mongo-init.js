print('Start #################################################################');

db = db.getSiblingDB('deployd');
db.createUser({
   user: 'mongou',
   pwd: 'mongop',
   roles: [{ role: 'dbAdmin', db: 'deployd'}]
})
db.createCollection('users');