import ballerina/sql;

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