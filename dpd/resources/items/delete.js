cancelUnless(internal || (me && me.privileges.indexOf('delete_items') != -1), "Unauthorized", 401)