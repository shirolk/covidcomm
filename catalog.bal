import ballerina/sql;
//import ballerina/io;

# A function to get all items in the catalog   
    # + return - json array of items in the catalog or error
    function getAllItems() returns Item[]|error? {
        // Send a response back to the caller.
        Item[] items = [];
        stream<Item, error?> resultStream = dbClient->query(`SELECT * FROM items`);
        check from Item item in resultStream
        do {
            items.push(item);
        };
        check resultStream.close();
        return items;
    }

    # A function to get all orders in the database 
    # + return - json array of orders in the database or error
    function getAllOrders() returns Order[]|error {
        // Send a response back to the caller.
        Order[] orders = [];
        stream<Order, error?> resultStream = dbClient->query(`SELECT * FROM orders`);
        check from Order curentorder in resultStream
        do {
            orders.push(curentorder);
        };
        check resultStream.close();
        return orders;
    }

    // a function to get all notifications in the database
    # + return - json array of notifications in the database or error
    # + return - error if there is an error while getting the notifications
     function getAllNotifications() returns Notification[]|error {
        // Send a response back to the caller.
        Notification[] notifications = [];
        stream<Notification, error?> resultStream = dbClient->query(`SELECT * FROM notifications`);
        //error? errorvar =  from Notification notification in resultStream
        check from Notification notification in resultStream
        do {
            notifications.push(notification);
        };
        //io:println(errorvar);
        check resultStream.close();
        return notifications;
     }

    //a function to add items to the catalog database   
    #+ item - item to be added to the catalog
    #+ return - error if there is an error while adding the item
     function addItem(Item item) returns error? {
        // Send a response back to the caller.
       sql:ExecutionResult _ = check dbClient->execute(`
        INSERT INTO items (Title, Includes, Intended_for, Color, Material, Price, Quantity)
       VALUES (${item.title}, ${item.includes}, ${item.intended_for}, ${item.color}, ${item.material}, ${item.price}, ${item.quantity})
      `);
     }

     //a function to update items in the catalog database
    #+ item - item to be updated in the catalog
    #+ return - error if there is an error while updating the item
     function updateItem(Item item) returns error? {
        // Send a response back to the caller.
       sql:ExecutionResult _ = check dbClient->execute(`
        UPDATE items SET Title = ${item.title}, Includes = ${item.includes}, Intended_for = ${item.intended_for}, Color = ${item.color}, Material = ${item.material}, Price = ${item.price}, Quantity = ${item.quantity} WHERE Item_Code = ${item.code}
      `);
     }

     //a function to delete items from the catalog database 
    #+ item - item to be deleted from the catalog
    # + return - error if there is an error while deleting the item
     function deleteItem(Item item) returns error? {
        // Send a response back to the caller.
       sql:ExecutionResult _ = check dbClient->execute(`
        DELETE FROM items WHERE Item_Code = ${item.code}
      `);
     }
    

    //a function to add orders to the database  
    #+ orderitem - order to be added to the database
    # + return - error if there is an error while adding the order
     function addOrder(Order orderitem) returns error? {
        // Send a response back to the caller.
       sql:ExecutionResult _ = check dbClient->execute(`
        INSERT INTO orders (id, item_code, price, amount, total, customer, card)
       VALUES (${orderitem.id}, ${orderitem.item_code}, ${orderitem.price}, ${orderitem.amount}, ${orderitem.total}, ${orderitem.customer}, ${orderitem.card})
      `);
     }

     //a function to update orders in the database
    #+ orderitem - order to be updated in the database
    # + return - error if there is an error while updating the order
     function updateOrder(Order orderitem) returns error? {
        // Send a response back to the caller.
       sql:ExecutionResult _ = check dbClient->execute(`
        UPDATE orders SET item_code = ${orderitem.item_code}, price = ${orderitem.price}, amount = ${orderitem.amount}, total = ${orderitem.total}, customer = ${orderitem.customer}, card = ${orderitem.card} WHERE Order_ID = ${orderitem.id}
      `);
     }

     //a function to delete orders from the database
    #+ orderitem - order to be deleted from the database
    # + return - error if there is an error while deleting the order
     function deleteOrder(Order orderitem) returns error? {
        // Send a response back to the caller.
       sql:ExecutionResult _ = check dbClient->execute(`
        DELETE FROM orders WHERE id = ${orderitem.id}
      `);
     }

    //a function to add notifications to the database
    #+ notification - notification to be added to the database
    # + return - error if there is an error while adding the notification
     function addNotification(Notification notification) returns error? {
        // Send a response back to the caller.
       sql:ExecutionResult _ = check dbClient->execute(`
        INSERT INTO notifications (customer, item_code, customer_email)
       VALUES (${notification.customer}, ${notification.item_code}, ${notification.customer_email})
      `);
     }

    // a function to get all notifications in the database for an item
    #+ code - item to get notifications for
    #+ return - json array of notifications in the database or error
     function getNotificationsForItem(int code) returns Notification[]|error {
        // Send a response back to the caller.
        Notification[] notifications = [];
        stream<Notification, error?> resultStream = dbClient->query(`SELECT * FROM notifications WHERE item_code = ${code}`);
        check from Notification notification in resultStream
        do {
            notifications.push(notification);
        };
        check resultStream.close();
        return notifications;
     }