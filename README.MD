# Getting started

## Step 1. (Setup NPM)

- Clone this repository and run `npm install`.

## Step 2. (Setup database)

- Spin up the mongodb container to insert a user into it (the mongo option in the docker-compose command to start only the database):

```
$ (sudo) docker-compose up -d mongo 
```

This should start the database locally. Connect to it:

```
$ mongo mongodb://localhost:27017
```

You should check before starting this that you didn't have another local instance of mongodb running on your computer, otherwise there will be a conflict on the port. If that happens to you, either shutdown your local mongoDB database or change the port in the .env file provided in this repository *and* in the docker-compose.yml file like this:

```
version: "3.8"
services:
# MongoDB
mongo:
image: mongo
ports:
- <YOUR_NEW_DB_PORT>:27017    ### Modify this line here.
volumes:
- ./mongodb/data:/data/db
```

- Insert a user in your database (replace the <YOUR_USERNAME> and <YOUR_PASSWORD> fields before copy-pasting in your mongo shell):

```
> use deployd
switched to db deployd
> db.createUser({
        user: "<YOUR_USERNAME>",
        pwd: "<YOUR_PASSWORD>",
        roles: [{ role: "dbAdmin", db: "deployd"}],
})
Successfully added user: {
        "user" : "<YOUR_USERNAME>",
        "roles" : [
                {
                        "role" : "dbAdmin",
                        "db" : "deployd"
                }
        ]
}
> db.getUsers() // sanity check
[
        {
                "_id" : "deployd.<YOUR_USERNAME>",
                "userId" : UUID("f40420c5-1f7c-47f9-ba94-c1d54f12725f"),
                "user" : "<YOUR_USERNAME>",
                "db" : "deployd",
                "roles" : [
                        {
                                "role" : "dbAdmin",
                                "db" : "deployd"
                        }
                ],
                "mechanisms" : [
                        "SCRAM-SHA-1",
                        "SCRAM-SHA-256"
                ]
        }
]
```

Note that if you exited the database, and then connected to it again, you won't be using the "deployd" database anymore if you connect via `mongo mongodb://localhost:27017`, so if you try `db.getUsers()` then, it'll show an empty list. You need to type `use deployd` again before running `db.getUsers()`.

- You can check that the database is working properly by trying to connect to it using authentication: 

```
$ mongo mongodb://<YOUR_USERNAME>:<YOUR_PASSWORD>@localhost:27017/deployd
```

This connects to the deployd mongoDB database, so no need to type `use deployd` again. To make sure you are properly connected, you can try running the mongo shell command `db.getUsers()` and get the same output as earlier.

## Step 3. Setting up the configuration files

- Make a copy of .env.example and rename it ".env" so that you can inject environment variables into the backend process. Enter your database credentials in the .env file under DB_USERNAME and DB_PASSWORD:

```
DB_USERNAME=<YOUR_USERNAME>
DB_PASSWORD=<YOUR_PASSWORD>
```

- Run the following script, which updates the items setup and the database scheme:

```
$ npm run setup -- config/default-item-config.js
```

## Step 4. (Launching backend servers in development) 

- Start the database container (if not already running):

```
$ (sudo) docker-compose up -d mongo
```

- Start the backend servers:

```
$ npm run start-production
$ npm run start-public-api
```

To test that it works, write the following command in your terminal:

```
$ curl localhost:2413
```

It should return the following HTML document:

```
<!DOCTYPE html>
<html>
<head>
</head>
<body>
        works
</body>
</html>
```

(or look at in in your browser and see a blank page with the word "works" in it).

- To stop the servers:

```
$ npm run stop-production
$ npm run stop-public-api
```

- To stop the database:

```
$ sudo docker-compose down
```

## Step 5. (Enter dashboard)

In order to see the dashboard you need a key. To get the key, you need the deployd command line interface.

- Install the deployd CLI globally (if not already present): 

```
$ npm install deployd-cli -g
```

- Generate a DPD key 

If you have created a key already, use this command to re-use the previously generated key:

```
$ cd dpd && dpd showkey && cd ..
```

If you haven't generated a key yet, running the above commands will generate the following console output:

```
No key file found. Run the following to create one:

dpd keygen

```

so follow these instructions instead:

```
$ cd dpd
$ mkdir .dpd	#skip if you have done this before
$ dpd keygen    #skip if you have done this before
$ dpd showkey
$ cd ..
```

- Visualize the dashboard

Open `localhost:2413/dashboard` (with the servers running, see Step 4 if necessary) in your browser and enter the key in the output of dpd keygen in the field displayed in the browser. This should give you access to the dashboard.
