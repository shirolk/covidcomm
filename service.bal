import ballerina/graphql;
import ballerinax/mysql.driver as _;
import ballerinax/mysql;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database="shiro_db", connectionPool={maxOpenConnections: 3}
);

# catalog item
public type Item record {|
    int code?;
    string title;
    string includes;
    string intended_for;
    string color;
    string material;    
    float price;
    int quantity;
|};

# order 
public type Order record {|
    int id;
    int item_code;
    float price;
    int amount;
    float total;
    string customer;
    string card;
|};

// notification 
public type Notification record {|
    string customer;
    int item_code;
    string customer_email;
|};


public distinct service class ItemData {
    private final readonly & Item entryRecord;

    function init(Item entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
    }

    resource function get title() returns string {
        return self.entryRecord.title;
    }

    resource function get includes() returns string {
        return self.entryRecord.includes;
    }

    resource function get intended_for() returns string {
        return self.entryRecord.intended_for;
    }

    resource function get color() returns string {
        return self.entryRecord.color;
    }

    resource function get material() returns string {
        return self.entryRecord.material;
    }

    resource function get price() returns float {
        return self.entryRecord.price;
    }

    resource function get quantity() returns int {
        
        return self.entryRecord.quantity;
    }

}

// service class for orderData
public distinct service class OrderData {
    private final readonly & Order entryRecord;

    function init(Order entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
    }

    resource function get id() returns int {
        return self.entryRecord.id;
    }

    resource function get item_code() returns int {
        return self.entryRecord.item_code;
    }

    resource function get price() returns float {
        return self.entryRecord.price;
    }

    resource function get amount() returns int {
        return self.entryRecord.amount;
    }

    resource function get total() returns float {
        return self.entryRecord.total;
    }

    resource function get customer() returns string {
        return self.entryRecord.customer;
    }

    resource function get card() returns string {
        return self.entryRecord.card;
    }

}

// service class for notificationData
public distinct service class NotificationData {
    private final readonly & Notification entryRecord;

    function init(Notification entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
    }

    resource function get customer() returns string {
        return self.entryRecord.customer;
    }

    resource function get iten_code() returns int {
        return self.entryRecord.item_code;
    }

    resource function get customer_email() returns string {
        return self.entryRecord.customer_email;
    }

}


service /covid19 on new graphql:Listener(9000) {
    resource function get allitems() returns ItemData[] {
        Item[] items;
        Item[]|error? unionResult = getAllItems();
        if unionResult is Item[] {
            items = unionResult;
        } else {
            items = [];
        }
        return items.map(entry => new ItemData(entry));
        //CovidEntry[] covidEntries = covidEntriesTable.toArray().cloneReadOnly();
        //return covidEntries.map(entry => new CovidData(entry));
    }

    resource function get allorders() returns OrderData[] {
        Order[] orders;
        Order[]|error? unionResult = getAllOrders();
        if unionResult is Order[] {
            orders = unionResult;
        } else {
            orders = [];
        }
        return orders.map(entry => new OrderData(entry));
    }

    resource function get allnotifications() returns NotificationData[] {
        Notification[] notifications;
        Notification[]|error? unionResult = getAllNotifications();
        if unionResult is Notification[] {
            notifications = unionResult;
        } else {
            notifications = [];
        }
        return notifications.map(entry => new NotificationData(entry));
    }

    resource function get filteritems(int code) returns ItemData? {
        Item[] items;
        Item[]|error? unionResult = getAllItems();
        if unionResult is Item[] {
            items = unionResult;
        } else {
            items = [];
        }

        foreach Item item in items {
            if (item.code == code)
            {
                return new ItemData(item);
            }
        }
        return;
    }

    // resource function to get all notifications for an item
    resource function get itemnotifications(int code) returns Notification[] {
        Notification[] itemNotifications;
        Notification[]|error? unionResult = getNotificationsForItem(code);
        if unionResult is Notification[] {
            itemNotifications = unionResult;
        } else {
            itemNotifications = [];
        }

        return itemNotifications;
    }

    // resource function to insert an item  
    remote function addItem(string title, float price) returns ItemData|error {
        
        Item item = {title: title, price: price,quantity: 0, color: "", material: "", intended_for: "", includes: ""};
        check addItem(item);
        return new ItemData(item);
    }

    // resource function to inssert an order
    remote function addOrder(int id, int item_code, float price, int amount, float total, string customer, string card) returns Order|error {
        Order orderItem = {id: id, item_code: item_code, price: price, amount: amount, total: total, customer: customer, card: card};
        check addOrder(orderItem);
        return orderItem;
    }

    // resource function to insert a notification
    remote function addNotification(string customer, int item_code, string customer_email) returns Notification|error {
        Notification notificationItem = {customer: customer, item_code: item_code, customer_email: customer_email};
        check addNotification(notificationItem);
        return notificationItem;
    }
    
}

