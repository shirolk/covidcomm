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